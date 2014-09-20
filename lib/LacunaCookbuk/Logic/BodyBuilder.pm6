use v6;

use LacunaCookbuk::Model::Body::SpaceStation;
use LacunaCookbuk::Model::Body::Planet;
use PerlStore::FileStore;
use LacunaCookbuk::Model::LacunaBuilding;
use LacunaCookbuk::Model::Empire;
use Term::ANSIColor;

#| Class is responsible for reading bodies and storing them
class LacunaCookbuk::Logic::BodyBuilder;

my Planet @planets;
my SpaceStation @stations;


submethod read {
    my $path_planets = make_path('planets.pl');
    my $path_stations = make_path('stations.pl');

=begin pod
I want this code back

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
	#TODO report rakudobug for .=
	my Body $body = Body.new(id => $planet_id);
	$body.get_buildings;	
       
	if $body.is_station {
	    my SpaceStation $station .= new(id => $planet_id, buildings => $body.buildings,  x => $body.x, y => $body.y);
	    note $station.name ~ " is a Space Station";
	    @stations.push($station)
	}elsif $body.is_planet {
	    my Planet $planet .= new(id => $planet_id, buildings => $body.buildings, ore => $body.ore, x => $body.x, y => $body.y);
	    note $planet.name ~ " is a Planet";
	    @planets.push($planet)
	}else {
	    warn $body.name ~ " Cannot be used -- neither planet nor station";
	}
    } 
    LacunaCookbuk::Logic::BodyBuilder.write;
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

constant $ZONE_SIZE = 250;

submethod report_zones {
    for @planets, @stations -> $body {
	my Int $zone_x = (+$body.x / $ZONE_SIZE).Int;	
	my Int $zone_y = (+$body.y / $ZONE_SIZE).Int;

	my $color = "default";
	$color = "blue" if all($zone_x, $zone_y) == 0;
	$color = "yellow" if all($zone_x.abs, $zone_y.abs) == 1;
	$color = "green" if $zone_x == -3 and $zone_y == 0;
	say colored("{$body.name} is in zone $zone_x|$zone_y", $color);
    }


}