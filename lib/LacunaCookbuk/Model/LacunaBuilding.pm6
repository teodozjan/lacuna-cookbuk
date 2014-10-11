use v6;

use LacunaCookbuk::Model::Structure::BuildingView;
use LacunaCookbuk::Id;
use LacunaCookbuk::Model::Empire;

role LacunaBuilding;

has $.url; 
has $.id;


method upgrade {
    rpc($!url).upgrade(session_id, $!id);    
}

method view returns BuildingView {    
    BuildingView.new(|%(rpc($!url).view(session_id, $!id)<building>));    
}

method repair {
    rpc($!url).repair(session_id, $!id);    
}
