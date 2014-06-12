use v6;

use LacunaCookbuk::Logic;
use LacunaCookbuk::Model::Inbox;
class Secretary does Logic;

method clean(@tags){
    my Inbox $box .= new;
    my @to_del;
    while (@to_del = $box.view_inbox(@tags).map({.<id>})) {
    say "Delete:" ~ $box.trash_messages(@to_del);
    }
}
