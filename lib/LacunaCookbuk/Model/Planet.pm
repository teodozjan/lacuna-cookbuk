use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Archaeology;
use LacunaCookbuk::Model::Trade;
use LacunaCookbuk::Model::Body;

class Planet is Body;

submethod find_archaeology_ministry (--> Archaeology){
    for self.buildings -> %building {
	return Archaeology.new(id => %building<id>) if %building<url> ~~ $Archaeology::URL;
    }
    note "No archaeology ministry on " ~ self.name;
    Archaeology;
}   

submethod find_trade_ministry { #(--> Trade)){
    for self.buildings -> %building {
	return Trade.new(id => %building<id>) if %building<url> ~~ $Trade::URL;
    }
    note "No trade ministry on " ~ self.name;
    Trade;
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

method home_planet(--> Planet) is cached {
    Planet.new(id => self.home_planet_id);
}
