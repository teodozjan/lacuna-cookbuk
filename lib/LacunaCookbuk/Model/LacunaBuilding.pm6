use v6;

use LacunaCookbuk::Model::Structure::BuildingView;
use LacunaCookbuk::Id;
use LacunaCookbuk::Model::Empire;

use Term::ANSIColor;

unit role LacunaBuilding;

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

method repaired returns Bool {
    if self.view.damaged {
        say colored($!url ~ " damaged", 'red');
        try self.repair;
        return False if $!;
        say colored("Repair successful", 'blue');
    }
    return True;
}
