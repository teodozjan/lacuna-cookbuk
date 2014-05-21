use v6;

use LacunaCookbuk::Model::LacunaSession;


class Body is LacunaSession;

constant $URL = '/body';
has $.id;
has @.buildings = self.get_buildings;

method name (--> Str){
    self.planet_name(self.id);
}

method get_buildings { #( --> Array[Hash]) {
    my %buildings = self.rpc($URL).get_buildings(self.session_id, self.id);
    my Hash @result = gather for keys %buildings<buildings> -> $building_id {
	my Hash $building = %buildings<buildings>{$building_id};
	$building<id> = $building_id;
	take $building;
    }     
}

method get_buildings_view {#( --> BuildingsView) {
    gather for self.buildings -> %building {
	my $rpc = self.rpc(%building<url>);
	my %building_view =  $rpc.view(self.session_id, %building<id>);
	%building_view<building><id> = %building<id>;	 
	take %building_view<building>;
    }     
}

method lac_status($id) is cached {
    self.rpc($URL).get_status(self.session_id, $id);
}



