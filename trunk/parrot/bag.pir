# -*-pir-*-
.include  "cclass.pasm"

.sub 'bag_init' :main
        .local pmc primes
        new primes, .FixedIntegerArray
        global "primes" = primes
        primes = 26
        primes[0] = 2
	primes[01] = 3
	primes[02] = 5
	primes[03] = 7
	primes[04] = 11
	primes[05] = 13
	primes[06] = 17
	primes[07] = 19
	primes[08] = 23
	primes[09] = 29
	primes[10] = 31
	primes[11] = 37
	primes[12] = 41
	primes[13] = 43
	primes[14] = 47
	primes[15] = 53
	primes[16] = 59
	primes[17] = 61
	primes[18] = 67
	primes[19] = 71
	primes[20] = 73
	primes[21] = 79
	primes[22] = 83
	primes[23] = 89
	primes[24] = 97
	primes[25] = 101

        test_empty()
.end

.sub 'make_bag'
        .param string arg

        .local int a_code
        ord a_code, "a"

        .local pmc primes
        primes = global "primes"

        .local pmc rv
        new rv, .BigInt
        rv = 1

        .local int chars_examined
        chars_examined = 0

        .local int len
        length len, arg

next:
        if chars_examined == len goto done
        .local string char
        substr char, arg, chars_examined, 1
        downcase char

        .local int isalpha
        is_cclass isalpha, .CCLASS_ALPHABETIC, char, 0
        unless isalpha goto skip

        .local int index
        .local int a_prime
        ord index, char
        index -= a_code
        a_prime = primes[index]
        rv = rv * a_prime

skip:
        inc chars_examined
        goto next

done:

        .return(rv)

.end

.sub 'subtract_bags'
        .param pmc top
        .param pmc bottom

        .local pmc rv
        .local pmc remainder
        new rv, .BigInt
        new remainder, .BigInt
        mod remainder, top, bottom
        if remainder  goto fail
        rv = top / bottom
        goto cleanup

fail:   rv = 0
cleanup:        
        .return (rv)
.end

.sub 'bag_empty'
        .param pmc b
        if b == 0 goto yup
        .return (0)
yup:
        .return(1)
.end

.sub 'test_empty'
        .local pmc b
        b = make_bag ("")
#         print "This had better be one:"
#         print b
#         print "\n"
.end
