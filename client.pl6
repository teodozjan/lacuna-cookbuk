use v6;

use JSON::RPC::Client;
use JSON::Tiny;
use LacunaCookbuk::Config;


class Client {
  has $!c = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/empire');
  has %!session;

  method create_session{
    %!session = $!c.login(|%login);

    my %status =  %(%!session<status>);
    my %planets = %(%status<empire>)<planets>;
    say %planets;
  }
    method close_session(){
      $!c.logout(%!session<session_id>);
    }
}



my $s = Client.new;
$s.create_session;
$s.close_session;
