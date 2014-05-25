use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::LacunaBuilding;

class Body is LacunaSession;

constant $URL = '/body';
has $.id;
has LacunaBuilding @.buildings;
has %.ore; 
method name (--> Str){
    self.planet_name(self.id);
}

submethod get_buildings { 
    my %buildings = self.rpc($URL).get_buildings(self.session_id, self.id);
    self.ore = %buildings<status><body><ore>;    
    my LacunaBuilding @result = gather for keys %buildings<buildings> -> $building_id {
	my LacunaBuilding $building = LacunaBuilding.new(id =>$building_id, url => %buildings<buildings>{$building_id}<url>);
	note $building.perl;
	take $building;
    }   

    self.buildings = @result;  
}

method get_buildings_view {#( --> BuildingsView) {
    gather for self.buildings -> %building {
	my $rpc = self.rpc(%building<url>);
	my %building_view =  $rpc.view(self.session_id, %building<id>);
	%building_view<building><id> = %building<id>;	 
	take %building_view<building>;
    }     
}



