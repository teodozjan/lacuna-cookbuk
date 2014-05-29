use v6;

use LacunaCookbuk::Model::LacunaSession;

role LacunaBuilding is LacunaSession;

has $.id;
has $.url; 


method upgrade returns Bool {
    self.rpc(self.url).upgrade(self.session_id, self.id);    
}

method level returns Int {
    warn "This may be not sort efficient";
    +self.rpc(self.url).view(self.session_id, self.id)<building><level>;    
}
