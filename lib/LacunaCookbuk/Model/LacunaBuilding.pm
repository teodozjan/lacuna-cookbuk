use v6;

use LacunaCookbuk::Model::Building::BuildingView;
use LacunaCookbuk::Id;
use LacunaCookbuk::Model::Empire;

role LacunaBuilding does Id;

has $.url; 


method upgrade {
    rpc(self.url).upgrade(session_id, self.id);    
}

method view returns BuildingView {    
    BuildingView.new(|rpc(self.url).view(session_id, self.id)<building>);    
}
