## See if we can make one iterator from another, and have each keep its own state.
## $Id: iter.pir 3354 2007-02-21 20:21:20Z erich $

.sub 'foo'
        .local pmc array
        .local pmc it_1
        new array, .ResizablePMCArray
        push array, "one"
        push array, "two"
        push array, "three"
        push array, "four"

        new it_1, .Iterator, array

        dump_it (it_1, "original, virgin")
        dump_it (it_1, "same thing again")
        
        $S0 = shift it_1
        $S0 = shift it_1
        $S0 = shift it_1
        
        dump_it (it_1, "original, after some shifts")

        .local pmc it_2
        new it_2, .Iterator, it_1
        
        dump_it (it_2, "copy of original")
.end

.sub 'dump_it'
        .param pmc it
        .param string descr
        print descr
        print ": as a string: "
        $S0 = it
        print $S0
        print "; as an integer: "
        $I0 = it
        print $I0
        print "\n"

        .local string item
next:   
        unless it goto done
        shift item, it
        print "One item: "
        print item
        print "\n"
        goto next
done:   
.end
