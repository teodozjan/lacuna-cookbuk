use v6;

use LacunaCookbuk::LacunaBuilding;
use LacunaCookbuk::RPCMaker;

class Trade is LacunaBuilding;

submethod getGlyphs {
##	my @array =
##	gather 
    my @array;
    for RPCMaker.aq_client_for('/trade').get_glyph_summary(self.session_id, self.id)<glyphs> -> @glyph
    {
	for @glyph -> %sth { 
	    my Hash $hash = %(:type("glyph"), :name(%sth<name>), :quantity(%sth<quantity>));
	    @array.push($hash);
	    
	}
	
   }
   return @array;
} 

submethod getGlyphsHash {
    my Int %hash;
    for RPCMaker.aq_client_for('/trade').get_glyph_summary(self.session_id, self.id)<glyphs> -> @glyph
    {
	for @glyph -> %sth { 
	    %hash{%sth<name>} = +(%sth<quantity>);
	}
	
    }
    return %hash;
} 

method getResources {
    RPCMaker.aq_client_for('/trade').get_stored_resources(self.session_id, $.id)<resources>;
}


method getPlans {
    RPCMaker.aq_client_for('/trade').get_plan_summary(self.session_id, $.id)<plans>;
} 

method getPushShips($targetId) {
    RPCMaker.aq_client_for('/trade').get_trade_ships(self.session_id, $.id, $targetId)<ships>;

}

method pushTo($dst_planet_id, $cargo) {
    RPCMaker.aq_client_for('/trade').push_items(self.session_id, $.id, $dst_planet_id, $cargo)<ship>
}
