use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::LacunaBuilding;

class Body is LacunaSession;

constant $URL = '/body';
has $.id;
has LacunaBuilding @.buildings; 
method name (--> Str){
    self.planet_name(self.id);
}

# perl does not see difference between inherriting and calling on object
# so it must be method for Planet.home_planet instead of submethod
method get_buildings { #( --> Array[Hash]) {
    my %buildings = self.rpc($URL).get_buildings(self.session_id, self.id);
    my LacunaBuilding @result = gather for keys %buildings<buildings> -> $building_id {
	my LacunaBuilding $building = LacunaBuilding.new(id =>$building_id, url => %buildings<buildings>{$building_id}<url>);
	note $building.perl;
	#%buildings<buildings>{$building_id};
	#$building<id> = $building_id;
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



