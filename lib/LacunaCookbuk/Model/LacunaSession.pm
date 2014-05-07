use v6;

use LacunaCookbuk::Config;
use JSON::RPC::Client;

class LacunaSession;

constant $EMPIRE = '/empire';
my %.status;
my $.session_id;
my %rpcs;

method rpc(Str $name --> JSON::RPC::Client) {
    unless %rpcs{$name} {
	#say "Creating client for $name";
	my $url = 'http://us1.lacunaexpanse.com'~ $name;
	%rpcs{$name} = JSON::RPC::Client.new( url => $url);
    }

    %rpcs{$name}
}


method create_session {
  my %logged = self.rpc($EMPIRE).login(|%login);
  %.status = %logged<status>;
  $.session_id = %logged<session_id>
}

method close_session {
    self.rpc($EMPIRE).logout($.session_id);
}

method planet_name($planet_id --> Str){
    self.status<empire><planets>{$planet_id};
}

method home_planet_id{
    self.status<empire><home_planet_id>;
}

method planets {
    self.status<empire><planets>;
}




