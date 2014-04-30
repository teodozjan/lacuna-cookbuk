use v6;

use JSON::RPC::Client;
use JSON::Tiny;
use LacunaCookbuk::Config;


class Rpc {
  my %rpcs;
  method new {!!!}
  method aq_client_for($name --> JSON::RPC::Client) {
    unless %rpcs{$name} {
				say "Creating client for $name";
				 my $url = 'http://us1.lacunaexpanse.com'~ $name;
				 %rpcs{$name} = JSON::RPC::Client.new( url => $url);
				}

      return %rpcs{$name}
  }
}

class Client {
  # TODO modules are roles here 
  has $!empire = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/empire');
  has $!body = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/body');
  has $!buildings = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/buildings');
  has %.status;
  has %.planets;
  has %!session;

  method create_session{
    %!session = $!empire.login(|%login);

    %.planets = %!session<status><empire><planets>;
    my $fh = open "var/session", :w;
    $fh.say(%!session.perl);
    $fh.close;
   }
    method close_session(){
      $!empire.logout(self!session_id);
    }

  method get_buildings($planet_id){
    my %response = $!body.get_buildings(self!session_id, $planet_id);
    %.status = %response<status>;
    my %buildings = %response<buildings>;
    gather for keys  %buildings -> $building {
					 my %building =  Rpc.aq_client_for(%buildings{$building}<url>).view(self!session_id, $building);
					 %building = %building<building>;
					 take %building;
					}
  }

  method !session_id{
    %!session<session_id>;
    }

    method get_planet_name($planet_id){
          %!planets{$planet_id};
    }
}



my $s = Client.new;
$s.create_session;
for keys $s.planets -> $planet_id{
				  my $planetname = $s.get_planet_name($planet_id);
				  my $path = "./var/$planetname";
				  say "Saving to $path";
				  my $fh = open $path, :w;
				  $fh.say($s.get_buildings($planet_id).perl);
				  $fh.close;
}

$s.close_session;



