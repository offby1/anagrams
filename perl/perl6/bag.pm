use v6;
module bag;

sub bag_from_letters($letters) is export {
    my %bag;
    for $letters.split('') -> $l {
        my $lc = $l.lc;
        %bag{$lc}++ if $lc ~~ 'a' .. 'z';
    }
    %bag;
}

sub bag_empty($b)  is export {
    return $b == {};
}

sub subtract($minuend, $subtrahend)  is export {
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
