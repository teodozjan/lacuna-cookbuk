use v6;
use Test;

use LacunaCookbuk::Client;
use IO::Capture::Simple;
 

plan 8;

unless %*ENV<TRAVIS> {
skip-rest 'Cannot perform all test without game login data'; 
exit;
}


my $client;
lives-ok {$client = LacunaCookbuk::Client.new}, 'Construction'; 

lives-ok {create_session}, 'Login';
silent_lives_ok {LacunaCookbuk::Logic::BodyBuilder.process_all_bodies}, 'Update';

silent_lives_ok {$client.cleanbox}, 'Remove mail';
silent_lives_ok {$client.defend}, 'Show attackers';
silent_lives_ok {$client.ordinary}, 'Make halls  and transport them';
silent_lives_ok {$client.chairman}, 'Upgrade buildings';

lives-ok {close_session}, "Logout";

sub silent_lives_ok(Callable $code, $reason = ''){
    lives-ok {capture_stdout ($code,$reason)}
}
