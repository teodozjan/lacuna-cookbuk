use v6;
use PerlStore::FileStore;
use JSON::RPC::Client;

#! Data provided by this class are required by anything in this  game 
class Empire;

constant $EMPIRE = '/empire';
my %status;
my %login;
my $session_id;


sub lacuna_url(Str $url){
    'http://us1.lacunaexpanse.com'~ $url
}

sub rpc(Str $name --> JSON::RPC::Client) is cached is export {
    JSON::RPC::Client.new( url => lacuna_url($name))
}

submethod create_session {
    find_credentials unless %login;
    my %logged = rpc($EMPIRE).login(|%login);
    %status = %logged<status>;
    $session_id = %logged<session_id>
}

submethod close_session {
    rpc($EMPIRE).logout($session_id);
    $session_id=Str;
}

submethod planet_name($planet_id --> Str)  {
    %status<empire><planets>{$planet_id};
}

submethod home_planet_id {
    %status<empire><home_planet_id>;
}

submethod planets_hash {
    %status<empire><planets>;
}

sub find_credentials returns Hash {
    my $path = make_path('login.pl');

    my $obj = from_file($path);
    
    if $obj {
	%login = $obj;
    } else {
	%login  = 
	    :api_key('07a052e0-d92b-49bb-ad38-cc1e433eb869'),
	    :MyGreatEmpire('password');
	to_file($path, %login);
	die "Must fill your data in $path, data were pregenerated for you"
    }
}

#= Need testing
submethod api_key(Str $key) {
    %login<api_key> = $key;
}

#= Need testing
submethod credentials(Pair $user_password){ 
    %login{$user_password.key} = $user_password.value;
}


sub session_id is export {
    $session_id;
}

sub make_path(Str $anyth) is export {
    mkdir('.lacuna_cookbuk') unless '.lacuna_cookbuk'.IO ~~ :e;
    IO::Path.new('.lacuna_cookbuk/' ~ $anyth)
}
