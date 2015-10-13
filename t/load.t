use v6;
use Test;


plan 1;

use LacunaCookbuk::Client;
my $client;
lives-ok {$client = LacunaCookbuk::Client.new}, "Construction"; 

lives-ok create_session, "Login";

lives-ok LacunaCookbuk::Logic::BodyBuilder.process_all_bodies, "Update";

lives-ok $client.cleanbox,"Remove mail";
lives-ok $client.defend,"Show attackers";
lives-ok $client.ordinary,"Make halls  and transport them";
lives-ok $client.chairman,"Upgrade buildings";

lives-ok close_session, "Logout";

