use v6;



use LacunaCookbuk::Config;
use JSON::RPC::Client;


class EmpireInfo {

  has %!session;
  has $!body = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/body');
  has $!trade = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/trade');
  has $!empire = JSON::RPC::Client.new( url => 'http://us1.lacunaexpanse.com/empire');

  method find_home_planet_id{
    %!session<status><empire><home_planet_id>;
  }

  method find_planets{
    %!session<status><empire><planets>;
  }

  method find_trade_ministry($planet_id){
    my %buildings = $!body.get_buildings(self!session_id, $planet_id)<buildings>;
    for keys %buildings -> $building_id {
      return $building_id if %buildings{$building_id}<url> ~~ '/trade';
      }
      #die("No trade ministry on $planet_id");
  }

  submethod !session_id{
    %!session<session_id>;
    }


  submethod create_session{
    %!session = $!empire.login(|%login);
   }

    submethod close_session(){
      $!empire.logout(self!session_id);
    }
}


my $f = EmpireInfo.new;
$f.create_session;

my $home_planet_id = $f.find_home_planet_id;
my @planets = keys $f.find_planets;
for @planets -> $planet_id {
			    next if $planet_id == $home_planet_id;
			    my $trade = $f.find_trade_ministry($planet_id);
			    say $trade;
			   }
  $f.close_session;
