use v6;

use LacunaCookbuk::Model::Body::SpaceStation;
use LacunaCookbuk::Model::Body::Planet;
use LacunaCookbuk::CoreAdditions::FileSerialization;
use LacunaCookbuk::Model::Empire;

class BodyBuilder;

my Planet @planets;
my SpaceStation @stations;

my $path = IO::Path.new($*PROGRAM_NAME).parent.parent ~ '/var/';
submethod read {
    @planets = from_file($path ~ 'planets.pl');
    @stations = from_file($path ~ 'stations.pl');
}

submethod write {
    to_file($path ~ 'planets.pl', @planets);
    to_file($path ~ 'stations.pl', @stations);
}

#this not something I'm proud of
submethod process_all_bodies {
    @planets = ();
    @stations = ();
    for Empire.planets_hash.keys -> $planet_id {      
	my Body $body .= new(id => $planet_id);
	$body.get_buildings;
	#todo consider usability of having separate classes for space station and planet while it can be a fields
	my SpaceStation $station .= new(id => $planet_id, buildings => $body.buildings);
	my Planet $planet .= new(id => $planet_id, buildings => $body.buildings, ore => $body.ore);
       
	if $station.find_parliament {
	    note $station.name ~ " is a Space Station";
	    @stations.push($station)
	}elsif $planet.find_trade_ministry {
	    note $planet.name ~ " is a Planet";
	    @planets.push($planet)
	}else {
	    warn $planet.name ~ " Cannot be used";
	}
    } 
    BodyBuilder.write;
}

sub home_planet(--> Planet) is cached is export {
    for @planets -> Planet $planet {
	return $planet if $planet.is_home;
    }
    Planet;
}

sub planets is export {
    @planets
}

sub stations is export {
    @stations
}
