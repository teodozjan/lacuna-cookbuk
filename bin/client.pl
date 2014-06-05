use v6;

use LacunaCookbuk::Client::TaskClient;
use LacunaCookbuk::Client::ReportClient;

multi sub MAIN(:$tasks = 'all'){
    my @todo=$tasks.split(/\s+/);
    
    @todo := <fill_cache ordinary chairman> if @todo.grep('all'); 

    my LacunaSession $f = LacunaSession.new;
    $f.create_session;
    my TaskClient $client .= new(session => $f);
    
    for @todo -> $willdo {
	$client."$willdo"();
    }

    $f.close_session;
}

multi sub MAIN(:$report){

    my LacunaSession $f = LacunaSession.new;
    $f.create_session;
    my ReportClient $client .= new(session => $f);
    
    die "NIY";

    $f.close_session;
}


