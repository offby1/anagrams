use v6;
use Test;

sub bag_from_letters($letters) {
    my %bag;
    for $letters.split('') -> $l {
        my $lc = $l.lc;
        %bag{$lc}++ if $lc ~~ 'a' .. 'z';
    }
    %bag;
}

sub bag_empty($b) {
    return $b == {};
}

sub subtract($minuend, $subtrahend) {
    my %diff = $minuend;
    for $subtrahend.keys -> $k {
        unless %diff{$k} { return; }
        my $diff = $subtrahend{$k} - $minuend{$k};
        if $diff < 0 { return ; }
        if $diff > 0 {
            %diff{$k} = $diff ;
        } else {
            %diff.delete($k);
        }
    }
    %diff;
}

is_deeply(bag_from_letters('abcdeaa'), {a=>3, b=>1, c=>1, d=>1, e=>1});
is_deeply(bag_from_letters('AB!!!c') , {a=>1, b=>1, c=>1});
ok(bag_empty(bag_from_letters('')));
nok(bag_empty(bag_from_letters('whoa nellie')));
is_deeply(bag_from_letters('a '), bag_from_letters('a'));
is_deeply(bag_from_letters('abc'), bag_from_letters('cba'));

is_deeply(subtract(bag_from_letters('abcd'), bag_from_letters('ab')), bag_from_letters('cd'));
nok(subtract(bag_from_letters('ab'), bag_from_letters('abcd')));

done;
