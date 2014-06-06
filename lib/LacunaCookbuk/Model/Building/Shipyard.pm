use v6;

use LacunaCookbuk::Model::LacunaBuilding;

class Shipyard is LacunaBuilding;

constant $URL = '/shipyard';

method get_buildable {
    self.rpc($URL).get_buildable(self.session_id,self.id)<buildable>
}
