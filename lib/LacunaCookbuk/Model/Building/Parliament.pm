use v6;

use LacunaCookbuk::Model::LacunaBuilding;

class Parliament is LacunaBuilding;

constant $URL = '/parliament';

method view_propositions returns Hash {
    self.rpc($URL).view_propositions(self.session_id, self.id)<propositions>;
}
