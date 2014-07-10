use v6;

use LacunaCookbuk::Model::Body::SpaceStation;
use LacunaCookbuk::Model::Body::Planet;
use PerlStore::FileStore;
use LacunaCookbuk::Model::Empire;

class BodyBuilder;

my Planet @planets;
my SpaceStation @stations;


submethod read {
    my $path_planets = make_path('planets.pl');
    my $path_stations = make_path('stations.pl');

    @planets = from_file($path_planets);
    @stations = from_file($path_stations);
}

submethod write {
    my $path_planets = make_path('planets.pl');
    my $path_stations = make_path('stations.pl');

    to_file($path_planets, @planets);
    to_file($path_stations, @stations);
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
