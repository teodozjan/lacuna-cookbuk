use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Archaeology;
use LacunaCookbuk::Model::Trade;

class Planet is LacunaSession;
constant $URL = '/body';
has $.id = self.home_planet_id;
has @.buildings = self.get_buildings;
my Planet %planets;

method planet ($id) {
    %planets{$id} = Planet.new(id => $id) unless %planets{$id};
    %planets{$id}
}

submethod find_archaeology_ministry(){
  
    for self.buildings -> %building {
	return Archaeology.new(id => %building<id>) if %building<url> ~~ $Archaeology::URL;
    }
    note "No archaeology ministry on " ~ self.name;
}   

submethod find_trade_ministry(){
    for self.buildings -> %building {
	return Trade.new(id => %building<id>) if %building<url> ~~ $Trade::URL;
    }
    note "No trade ministry on" ~ self.name;
}   


submethod get_buildings( --> List) {
    my %buildings = self.rpc($URL).get_buildings(self.session_id, self.id);
    gather for keys %buildings<buildings> -> $building_id {
	my Hash $building = %buildings<buildings>{$building_id};
	$building<id> = $building_id;
	take $building;
    }     
}

submethod get_buildings_view( --> List) {
    gather for self.buildings -> %building {
	my $rpc = self.rpc(%building<url>);
	my %building_view =  $rpc.view(self.session_id, %building<id>);
	%building_view<building><id> = %building<id>;	 
	take %building_view<building>;
    }     
}

#todo -> compare with body hour production - supply chains
submethod calculate_sustainablity {
    my %balance;
    for self.get_buildings_view -> %building {
	for (keys %building).grep(/_hour/) -> $key {
	    %balance{$key} += %building{$key};
	}
   }
    %balance;
}  

submethod name {
    self.planet_name(self.id);
}
