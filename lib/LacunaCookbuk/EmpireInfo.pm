use v6;

use LacunaCookbuk::LacunaSession;
use LacunaCookbuk::RPCMaker;

use LacunaBuilding::Archaeology;
use LacunaBuilding::Trade;

class EmpireInfo is LacunaSession;

has $!body = RPCMaker.aq_client_for('/body');
has $!empire = RPCMaker.aq_client_for('/empire');

method getPlanetName($planet_id --> Str){
    %.session<status><empire><planets>{$planet_id};
}

method find_home_planet_id{
    $.session<status><empire><home_planet_id>;
}

method find_planets{
    $.session<status><empire><planets>;
}

method find_archeology_ministry($planet_id){
    my %buildings = $!body.get_buildings(self.session_id, $planet_id)<buildings>;
    for keys %buildings -> $building_id {
	return Archaeology.new(id => $building_id, session => self.session) if %buildings{$building_id}<url> ~~ '/archaeology';
    }
    die("No archeology ministry on $planet_id");
}   

method find_trade_ministry($planet_id){
    my %buildings = $!body.get_buildings(self.session_id, $planet_id)<buildings>;
    for keys %buildings -> $building_id {
	return Trade.new(id => $building_id, session => self.session) if %buildings{$building_id}<url> ~~ '/trade';
    }
    #die("No trade ministry on $planet_id");
}   

submethod get_buildings($planet_id --> Array){
    my %buildings = $!body.get_buildings(self.session_id, $planet_id)<buildings>;
    gather for keys  %buildings -> $building {
	my $rpc = RPCMaker.aq_client_for(%buildings{$building}<url>);
	my %building =  $rpc.view(self.session_id, $building)<building>;	  
	take %building;
    }     
}

submethod calculateSustainablity($planet_id){
    my %balance;
    my %buildings = $!body.get_buildings(self.session_id, $planet_id)<buildings>;
    my @houses = gather for keys  %buildings -> $building {
	my $rpc = RPCMaker.aq_client_for(%buildings{$building}<url>);
	my %building =  $rpc.view(self.session_id, $building)<building>;	  
	take %building;
    }     
#	my @buildings = get_buildings($planet_id); #rakudo bug causes no ICU loaded error
    for @houses -> %building {
	for (keys %building).grep(/_hour/) -> $key {
	    %balance{$key} += %building{$key};
	}
    }
    return %balance;
}  
