use v6;

use LacunaCookbuk::Model::Inbox;

class LacunaCookbuk::Logic::Secretary;

method clean(@tags){
    my Inbox $box .= new;
    say "Delete:" ~ $box.trash_messages_where(@('Parliament'));

}

method clean_wastin_res {
    my Inbox $box .= new;
    say "Delete:" ~ $box.trash_messages_where(@('Complaints'), 'Wasting%');
}
