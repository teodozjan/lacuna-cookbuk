use v6;

use LacunaCookbuk::Model::LacunaBuilding;

class SpacePort is LacunaBuilding;

constant $URL = '/spaceport';

has $.max_ships;
has $.docks_available;
has %.docked_ships;

method view_all_ships {
    self.rpc($URL).view_all_ships(self.session_id,self.id)<ships>;
}

method scuttle_ship($id) {
self.rpc($URL).scuttle_ship(self.session_id, self.id, $id)

}
