use v6;
use LacunaCookbuk::Model::Empire;
use LacunaCookbuk::Model::LacunaBuilding;

unit class LacunaCookbuk::Model::Structure::Archaeology is LacunaCookbuk::Model::LacunaBuilding;

constant $URL = '/archaeology';
method assemble_glyphs(@glyphs, Int $quantity --> Str){
    my Array $array;
    $array.append(@glyphs);
    rpc($URL).assemble_glyphs(session_id,self.id, $array, $quantity)<item_name>;
  
}

 
