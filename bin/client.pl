#!perl6

use v6;

use LacunaCookbuk::Client;

sub MAIN(:$tasks!){
  my LacunaSession $f = LacunaSession.new;
  my Client $client .= new(session => $f);
  $f.create_session;

  my @todo=$tasks.split(/\s+/);

  @todo := <fill_cache defend ordinary spies chairman ships votes> if @todo.grep('all');

  for @todo -> $willdo {
			$client."$willdo"();
		       }
    $f.close_session;
}


