use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Building::BuildingView;

role LacunaBuilding is LacunaSession;

has $.id;
has $.url; 


method upgrade {
    self.rpc(self.url).upgrade(self.session_id, self.id);    
}

method view returns BuildingView {    
    BuildingView.new(|self.rpc(self.url).view(self.session_id, self.id)<building>);    
}
