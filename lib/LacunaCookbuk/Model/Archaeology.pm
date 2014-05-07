use v6;

use LacunaCookbuk::Model::LacunaBuilding;

class Archaeology is LacunaBuilding;
constant $URL = '/archaeology';
method assemble_glyphs(@glyphs, Int $quantity){
#    my Array $array;
#    $array.push($_) for(@glyphs);

    say self.rpc($URL).assemble_glyphs(self.session_id,self.id, @glyphs, $quantity)<item_name>;
  
}

 
