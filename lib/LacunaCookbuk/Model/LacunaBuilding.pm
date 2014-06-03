use v6;

use LacunaCookbuk::Model::LacunaSession;

role LacunaBuilding is LacunaSession;

has $.id;
has $.url; 


method upgrade {
    self.rpc(self.url).upgrade(self.session_id, self.id);    
}

method level returns Int {    
    +self.rpc(self.url).view(self.session_id, self.id)<building><level>;    
}
