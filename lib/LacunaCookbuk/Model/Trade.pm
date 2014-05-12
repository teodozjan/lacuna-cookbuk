use v6;

use LacunaCookbuk::Model::LacunaBuilding;


class Trade is LacunaBuilding;

constant $URL = '/trade';

submethod get_glyphs { #( --> Array[Hash]) {
##	my @array =
##	gather 
    my Hash  @array;
    for self.rpc($URL).get_glyph_summary(self.session_id, self.id)<glyphs> -> @glyph
    {
	for @glyph -> %sth { 
	    my Hash $hash = %(:type("glyph"), :name(%sth<name>), :quantity(%sth<quantity>));
	    @array.push($hash);
	    
	}
	
   }
   @array;
} 

#todo move to achaeology
submethod get_glyphs_hash { #(--> Hash) {
    my Int %hash;
    for self.rpc($URL).get_glyph_summary(self.session_id, self.id)<glyphs> -> @glyph
    {
	for @glyph -> %sth { 
	    %hash{%sth<name>} = +(%sth<quantity>);
	}
	
    }
    %hash;
} 

method get_resources {
   self.rpc($URL).get_stored_resources(self.session_id, $.id)<resources>;
}


method get_plans {
   self.rpc($URL).get_plan_summary(self.session_id, $.id)<plans>;
} 

method get_push_ships($targetId = self.home_planet_id) {
   self.rpc($URL).get_trade_ships(self.session_id, $.id, $targetId)<ships>;
}

method push($cargo, $dst_planet_id = self.home_planet_id) {
   self.rpc($URL).push_items(self.session_id, self.id, $dst_planet_id, $cargo)<ship>
}
