use v6;

use LacunaCookbuk::Model::LacunaSession;



class Inbox is LacunaSession;

constant $URL = '/inbox';


method trash_messages(@msg_ids){
    self.rpc($URL).trash_messages(self.session_id,$(@msg_ids))<success>
}

method view_inbox(@tags){
 	self.rpc($URL).view_inbox(self.session_id, %(tags => @tags))<messages>
}

sub fake_ref(@array --> Str){
'[' ~ @array.join(',') ~ ']'

}

