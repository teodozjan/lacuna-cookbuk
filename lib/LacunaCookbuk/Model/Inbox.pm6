use v6;

use LacunaCookbuk::Model::Empire;


class Inbox;

constant $URL = '/inbox';


method trash_messages(@msg_ids){
    rpc($URL).trash_messages(session_id,$(@msg_ids))<success>
}

method view_inbox(@tags){
    rpc($URL).view_inbox(session_id, %(tags => @tags))<messages>;
}

method trash_messages_where(@tags, $subject){
    rpc($URL).trash_messages_where(session_id, %(tags => @tags,subject => $subject))<messages>
}


