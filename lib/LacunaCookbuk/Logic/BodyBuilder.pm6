use v6;

use LacunaCookbuk::Model::Body::SpaceStation;
use LacunaCookbuk::Model::Body::Planet;
use PerlStore::FileStore;
use LacunaCookbuk::Model::LacunaBuilding;
use LacunaCookbuk::Model::Empire;

class BodyBuilder;

my Planet @planets;
my SpaceStation @stations;


method read {


    my $path_planets = make_path('planets.pl');
    my $path_stations = make_path('stations.pl');

=begin pod
    @planets = from_file($path_planets);
    @stations = from_file($path_stations);
=end pod



    #moar hack
    note 'Readin $path_planets';
    my $plan = slurp $path_planets;
    @planets = EVAL $plan;

    #moar hack
    note 'Readin $path_stations';
    my $stat =  slurp $path_stations;
    @stations = EVAL $stat; 


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
		
	
       
	if $body.is_station {
	    my SpaceStation $station .= new(id => $planet_id, buildings => $body.buildings);
	    note $station.name ~ " is a Space Station";
	    @stations.push($station)
	}elsif $body.is_planet {
	    my Planet $planet .= new(id => $planet_id, buildings => $body.buildings, ore => $body.ore);
	    note $planet.name ~ " is a Planet";
	    @planets.push($planet)
	}else {
	    warn $body.name ~ " Cannot be used -- neither planet neither station";
	}
    } 
    BodyBuilder.write;
}

sub home_planet(--> Planet) is export {
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
