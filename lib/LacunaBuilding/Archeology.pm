use v6;

use LacunaCookbuk::LacunaBuilding;

class Archeology is LacunaBuilding;

method assemble_glyphs(@glyphs, $quantity){
    RPCMaker.aq_client_for('/archeology').assemble_glyphs(self.session_id,$.id,@glyphs, $quantity)
}

 
