use v6;

use LacunaCookbuk::RPCMaker;
use LacunaCookbuk::Config;


class LacunaSession;
my %.session;

method create_session {
    %.session = RPCMaker.aq_client_for('/empire').login(|%login);
}

method close_session(){
    RPCMaker.aq_client_for('/empire').logout(self.session_id);
}

method session_id{
    %.session<session_id>;
}


