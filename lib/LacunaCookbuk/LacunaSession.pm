use v6;

use LacunaCookbuk::RPCMaker;
use LacunaCookbuk::Config;


class LacunaSession;
my %.status;
my $.session_id;

method create_session {
  my %logged = RPCMaker.aq_client_for('/empire').login(|%login);
  %.status = %logged<status>;
  $.session_id = %logged<session_id>
}

method close_session(){
    RPCMaker.aq_client_for('/empire').logout($.session_id);
}




