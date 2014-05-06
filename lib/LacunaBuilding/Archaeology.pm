use v6;

use LacunaCookbuk::LacunaBuilding;


class Archaeology is LacunaBuilding;

method assemble_glyphs(@glyphs, Int $quantity){
    my Array $array;
    $array.push($_) for(@glyphs);
#TODO string constants urls
    say RPCMaker.aq_client_for('/archaeology').assemble_glyphs(self.session_id,self.id, $array, $quantity)<item_name>;
  
}

 
