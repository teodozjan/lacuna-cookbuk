use v6;

use LacunaCookbuk::Model::SpaceStation;
use LacunaCookbuk::Model::Planet;


class BodyBuilder;

has LacunaSession $.session;
has Planet @.planets;
has SpaceStation @.stations;

#this not something I'm proud of
submethod process_all_bodies($planets_hash) {

    for $planets_hash.keys -> $planet_id {      
#todo stop wasting rpc calls
	my SpaceStation $station = SpaceStation.new(id => $planet_id);
	my Planet $planet = Planet.new(id => $planet_id);

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

