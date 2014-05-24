use v6;

use LacunaCookbuk::Model::SpaceStation;
use LacunaCookbuk::Model::Planet;
use LacunaCookbuk::CoreAdditions::FileSerialization;


class BodyBuilder does FileSerialization;

has LacunaSession $.session;
#serialization of this class is terribly slow
has Planet @.planets;
has SpaceStation @.stations;

#this not something I'm proud of
submethod process_all_bodies($planets_hash) {

    for $planets_hash.keys -> $planet_id {      
	my $body = Body.new(id => $planet_id);
	$body.get_buildings;
#todo consider usability of having separate classes for space station and planet while it can be a fields
	my SpaceStation $station = SpaceStation.new(id => $planet_id, buildings => $body.buildings);
	my Planet $planet = Planet.new(id => $planet_id, buildings => $body.buildings);
	
	if $station.find_parliament {
	    note $station.name ~ " is a Space Station";
	    self.stations.push($station)
	}elsif $planet.find_trade_ministry {
	    note $planet.name ~ " is a Planet";
	    self.planets.push($planet)
	}else {
	    warn $planet.name ~ " Cannot be used";
	}
    } 
}



