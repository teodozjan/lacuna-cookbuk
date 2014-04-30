use v6;




use LacunaCookbuk::Config;
#use LacunaCookbuk::RpcMaker; #rakudo bug?
use JSON::RPC::Client;


class RpcMaker {
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
					      my $rpc = RpcMaker.aq_client_for(%buildings{$building}<url>);
					      my %building =  $rpc.view(self!session_id, $building);
					      %building = %building<building>;
					      take %building;
					      if %buildings{$building}<url> ~~ '/planetarycommand' {
												    my $fh_plans = open self!get_path($planet_id, 'plans'), :w;
												   $fh_plans.say($rpc.view_plans(self!session_id, $building)<plans>.perl);
												   $fh_plans.close;
												   my $fh_chains = open self!get_path($planet_id, 'supply_in'), :w;
												   $fh_chains.say($rpc.view_incoming_supply_chains(self!session_id, $building)<supply_chains>.perl);
												   $fh_chains.close;
												  }
					      elsif %buildings{$building}<url> ~~ '/spaceport' {
											       #TODO stop hope you don't have many
											       my $fh_ships = open self!get_path($planet_id, 'ships'), :w;
											       $fh_ships.say($rpc.view_all_ships(self!session_id, $building)<ships>.perl);
											       $fh_ships.close;
											      }
					      elsif %buildings{$building}<url> ~~ '/archeology' {
												my $fh_glyphs = open self!get_path($planet_id, 'glyphs'), :w;
												$fh_glyphs.say($rpc.get_glyph_summary(self!session_id, $building)<glyphs>.perl);
												$fh_glyphs.close;
											      }
					      elsif %buildings{$building}<url> ~~ '/trade' {
											    my $fh_chains = open self!get_path($planet_id, 'supply_out'), :w;
											    $fh_chains.say($rpc.view_supply_chains(self!session_id, $building)<glyphs>.perl);
											    $fh_chains.close;
											   }
					}
  }

  method !session_id{
    %!session<session_id>;
    }

    method get_planet_name($planet_id){
          %!planets{$planet_id};
    }

  method !get_path($file, $prefix){
    return './var/' ~ $file ~ '_' ~ $prefix;

  }
  
}



my $s = Client.new;
$s.create_session;
for keys $s.planets -> $planet_id{
				  my $path = "./var/$planet_id";
				  say "Saving to $path";
				  my $fh = open $path, :w;
				  $fh.say($s.get_buildings($planet_id).perl);
				  $fh.close;
}

$s.close_session;



