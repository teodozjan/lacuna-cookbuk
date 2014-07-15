use v6;


use LacunaCookbuk::Model::LacunaBuilding;
use LacunaCookbuk::Model::Empire;

class Body does Id;

constant $URL = '/body';
has LacunaBuilding @.buildings;
has %.ore; 

method get_status { 
    rpc($URL).get_status(session_id, self.id);
}

submethod get_buildings { 
  my %buildings = rpc($URL).get_buildings(session_id, self.id);
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
	my $rpc = rpc(%building<url>);
	my %building_view =  $rpc.view(session_id, %building<id>);
	%building_view<building><id> = %building<id>;	 
	take %building_view<building>;
    }     
}


method get_happiness(--> Int:D){
    my %res = rpc($URL).get_status(session_id, self.id);
    %res<body><happiness>;

}

method find_buildings(Str $url) {
    my LacunaBuilding @buildings = gather for self.buildings -> LacunaBuilding $building {
	take $building if $building.url ~~ $url;
    };    
   
    @buildings;
  
}

method name(--> Str) {
    Empire.planet_name(self.id);
}
