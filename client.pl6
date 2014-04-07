use v6;

use JSON::RPC::Client;
use JSON::Tiny;
use LacunaCookbuk::Config;




class Client {
  # TODO modules are roles here 
  has $!empire = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/empire');
  has $!body = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/body');
  has $!buildings = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/buildings');
 # has $!buildings = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/mine');
  has %.status;
  has %.planets;
  has %!session;

  method create_session{
    %!session = $!empire.login(|%login);

    %.planets = %!session<status><empire><planets>;
  }
    method close_session(){
      $!empire.logout(self!session_id);
    }

  method get_buildings($planet_id){
    my %sum;
    say %!planets{$planet_id};
    my %response = $!body.get_buildings(self!session_id, $planet_id);
    %.status = %response<status>;
    my %buildings = %response<buildings>;
    for keys  %buildings -> $building {
				       my %building =  self!aq_building_rpc(%buildings{$building}<url>).view(self!session_id, $building);
				       %building = %building<building>;
				       
				       for (keys %building).grep(/_hour/) -> $key {
					 %sum{$key} += %building{$key};
				       }
				      }
      say %sum;
    
  }

  method !session_id{
    %!session<session_id>;
    }

    method !aq_building_rpc(Str $s){
      my $url = 'http://us1.lacunaexpanse.com'~ $s;
      JSON::RPC::Client.new( url => $url);
    }
  
}



my $s = Client.new;
$s.create_session;
for keys $s.planets -> $planet_id{

			       $s.get_buildings($planet_id);
				  last;
				  
}

$s.close_session;



