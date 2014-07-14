use v6;

use LacunaCookbuk::Model::Empire;
use LacunaCookbuk::Model::Body;

use LacunaCookbuk::Model::Building::Archaeology;
use LacunaCookbuk::Model::Building::Trade;
use LacunaCookbuk::Model::Building::SpacePort;
use LacunaCookbuk::Model::Building::Intelligence;
use LacunaCookbuk::Model::Building::Development;
use LacunaCookbuk::Model::Building::Shipyard;

class Planet is Body;

submethod find_archaeology_ministry(--> Archaeology) {
    for self.buildings -> LacunaBuilding $building {
	return Archaeology.new(id => $building.id) if $building.url ~~ $Archaeology::URL;
    }
    note "No archaeology ministry on " ~ self.name;
    Archaeology;
}   

submethod find_trade_ministry(--> Trade) { 
    for self.buildings -> LacunaBuilding $building {
	return Trade.new(id => $building.id, url=>$building.url) if $building.url ~~ $Trade::URL;
    }
    note "No trade ministry on " ~ self.name;
    Trade;
}   

submethod find_shipyard(--> Shipyard) { 
    for self.buildings -> LacunaBuilding $building {
	return Shipyard.new(id => $building.id, url=>$building.url) if $building.url ~~ $Shipyard::URL;
    }
    note "No shipyard on " ~ self.name;
    Shipyard;
} 

submethod find_space_port(--> SpacePort) {
    for self.buildings -> LacunaBuilding $building {
	
	if $building.url ~~ $SpacePort::URL {
	    my %attr = %(rpc($SpacePort::URL).view(session_id,$building.id));
	    %attr<id> = $building.id;
	    return SpacePort.new(|%attr)
	}
    }
    note "No space port on " ~ self.name;
    SpacePort;
}


submethod find_intelligence_ministry(--> Intelligence) {
    
    for self.buildings -> LacunaBuilding $building {
	
	if $building.url ~~ $Intelligence::URL {
	    my $id = $building.id;
	    
	    my %attr = rpc($building.url).view(session_id, $id)<spies>;	  
	    %attr<id> = $id;
	    return Intelligence.new(|%attr);
	}
    }
    note "No intelligence on " ~ self.name;
    Intelligence;
}

submethod find_development_ministry(--> Development) {
    
    for self.buildings -> LacunaBuilding $building {
	
	if $building.url ~~ $Development::URL {
	    my $id = $building.id;
	    my %resp = rpc($building.url).view(session_id, $id);
	    my %attr = %resp;
	    %attr<url> = $building.url;
	    %attr<id> = $id;
	    return Development.new(|%attr);
	}
    }
    note "No intelligence on " ~ self.name;
    Development;
}

#todo -> compare with body hour production - supply chains
submethod calculate_sustainablity (--> Hash) {
    my %balance;
    for self.get_buildings_view -> %building {
	for (keys %building).grep(/_hour/) -> $key {
	    %balance{$key} += %building{$key};
	}
   }
    %balance;
}  

method is_home(--> Bool) {
    +self.id == +Empire.home_planet_id;
}

