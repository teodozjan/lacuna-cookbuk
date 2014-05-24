use v6;

use LacunaCookbuk::Model::LacunaBuilding;

class SpacePort is LacunaBuilding;

constant $URL = '/spaceport';
has $.view =  self.rpc($URL).view(self.session_id,self.id);

method free_docks(--> Int){
+(self.view<docks_available>)
}

method max_ships (--> Int) {
+(self.view<max_ships>)
}
