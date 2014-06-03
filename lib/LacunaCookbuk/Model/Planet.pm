use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Archaeology;
use LacunaCookbuk::Model::Trade;
use LacunaCookbuk::Model::Body;
use LacunaCookbuk::Model::SpacePort;
use LacunaCookbuk::Model::Intelligence;
use LacunaCookbuk::Model::Development;

class Planet is Body;

submethod find_archaeology_ministry(--> Archaeology) {
    for self.buildings -> LacunaBuilding $building {
	return Archaeology.new(id => $building.id) if $building.url ~~ $Archaeology::URL;
    }
    note "No archaeology ministry on " ~ self.name;
    Archaeology;
}   

submethod find_trade_ministry(--> Trade) { #(--> Trade)){
    for self.buildings -> LacunaBuilding $building {
	return Trade.new(id => $building.id, url=>$building.url) if $building.url ~~ $Trade::URL;
    }
    note "No trade ministry on " ~ self.name;
    Trade;
}   

submethod find_space_port(--> SpacePort) {
    for self.buildings -> LacunaBuilding $building {
	
	if $building.url ~~ $SpacePort::URL {
	    my %attr = self.rpc($SpacePort::URL).view(self.session_id,$building.id);
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
	    
	    my %attr = self.rpc($building.url).view(self.session_id, $id)<spies>;	  
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
	    my %resp = self.rpc($building.url).view(self.session_id, $id);
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
    +self.id == +self.home_planet_id;
}

