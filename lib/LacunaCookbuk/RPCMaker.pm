use v6;
use JSON::RPC::Client;

class RPCMaker; 
my %rpcs;
method new {!!!}
method aq_client_for($name --> JSON::RPC::Client) {
    unless %rpcs{$name} {
	#say "Creating client for $name";
	my $url = 'http://us1.lacunaexpanse.com'~ $name;
	%rpcs{$name} = JSON::RPC::Client.new( url => $url);
    }

    return %rpcs{$name}
}

