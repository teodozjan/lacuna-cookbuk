use v6;

use LacunaCookbuk::Model::Inbox;

unit class LacunaCookbuk::Logic::Secretary;

method clean(@tags){
    my LacunaCookbuk::Model::Inbox $box .= new;
    say "Delete:" ~ $box.trash_messages_where(@('Parliament'))<deleted_count>;

}

method clean_wastin_res {
    my LacunaCookbuk::Model::Inbox $box .= new;
    say "Delete:" ~ $box.trash_messages_where(@('Complaints'), 'Wasting%')<deleted_count>;
}
