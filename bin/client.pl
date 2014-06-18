#!perl6

use v6;

use LacunaCookbuk::Client;


multi sub MAIN(Bool :$help!){
note "Available tasks" ~ Client.^methods.join(", ")
}

multi sub MAIN(:$tasks!, Bool :$update?){

  my Client $client .= new;
 
  create_session;

  my @todo=$tasks.split(/\s+/);

  @todo := <defend ordinary spies chairman ships votes> if @todo.grep('all');

  if $update {
      BodyBuilder.process_all_bodies;
  } else {
      BodyBuilder.read;
  }
  for @todo -> $willdo {
			$client."$willdo"();
		       }

  close_session;  
}


