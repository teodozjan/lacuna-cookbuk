use v6;

use LacunaCookbuk::Model::Building::Trade;

role Cargo{
    method gather(Trade $Trade --> List) { ... }   
}

class Glyphs does Cargo {
   

    method gather(Trade $trade --> List){
	$trade.get_glyphs;
    }

}

class Plans does Cargo {
    
    method gather(Trade $trade --> List){
	$trade.get_plans;
    }
}
