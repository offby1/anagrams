## -*-pir-*-
.sub 'main' :main
        .param pmc args
        load_bytecode './dict.pbc'
        load_bytecode './bag.pbc'
        load_bytecode 'dumper.pir'
        .local string input
        .local BigInt ibag
        .local pmc dict
        .local pmc level
        level = new .Integer
        global "level" = level

        input = shift args
        join input, " ", args

        bag_init()
        ibag = make_bag(input)

        input = ibag
        dict = snarf_dict ()
        .local pmc result
        .local pmc iterator
        new iterator, .Iterator, dict
        result = anagrams (ibag, iterator)
        print "OK, here's the final result:"
        _dumper (result)
.end

.sub 'anagrams'
        .param BigInt input_bag
        .param pmc dict_it
        .local pmc rv
        .local pmc pruned_it
        new rv, .ResizablePMCArray
        #dpr ("input_bag is ")
        #print input_bag
        #print "\n"

        pruned_it = prune (input_bag, dict_it)
next_entry:     
        unless pruned_it goto done
        .local pmc one_entry
        .local BigInt entry_bag
        .local BigInt smaller_bag
        .local pmc new_iter
        shift one_entry, pruned_it

        clone one_entry, one_entry
        entry_bag = shift one_entry
        #dpr ("front entry: ")
        #print entry_bag
        #print "\n"
        smaller_bag = subtract_bags (input_bag, entry_bag)

        unless smaller_bag == 0 goto nonzero
        #dpr ("subtracting failed -- input_bag ")
        #print input_bag
        #print " doesn't contain entry_bag "
        #print entry_bag
        #print "\n"
        goto next_entry
nonzero:        
        unless smaller_bag == 1 goto recur
        #dpr ("subtracting yielded 1 -- input_bag ")
        #print input_bag
        #print " equals entry_bag "
        #print entry_bag
        #print "\n"

        .local pmc words_it
        .local pmc list_of_one_word
        new words_it, .Iterator, one_entry
next_word:      
        unless words_it goto done
        new list_of_one_word, .ResizableStringArray
        .local string one_word
        shift one_word, words_it
        push list_of_one_word, one_word
        push rv, list_of_one_word
        goto next_word

        #dpr ("Top, bottom, diff:\n")
        #dpr (input_bag)
        #dpr ("; ")
        #dpr (entry_bag)
        #dpr ("; ")
        #dpr (smaller_bag)
        #dpr ("\n")

recur:  

        #dpr ("subtracting yielded > 1 -- input_bag ")
        #print input_bag
        #print " contains entry_bag "
        #print entry_bag
        #print " with leftover of "
        #print smaller_bag
        #print "\n"

        .local pmc from_smaller_bag
        inc_level (1)
        clone new_iter, pruned_it
        from_smaller_bag = anagrams (smaller_bag, new_iter)
        inc_level (-1)
        unless from_smaller_bag goto next_entry
        .local pmc combined
        combined = combine (one_entry, from_smaller_bag)
        splice rv, combined, 0, 0
        goto next_entry
done:

        #dpr ("Anagrams of ")
        #print input_bag
        #print " are "
        #_dumper (rv)

        .return (rv)
.end

.sub 'prune'
        .param BigInt bag
        .param pmc input_it
        .local pmc smaller_dict
        .local pmc rv
        .local pmc it

        clone it, input_it
        new smaller_dict, .ResizablePMCArray

#         print "prune: bag is "
#         say bag

next_entry:
        unless it goto done
        .local pmc one_entry
        shift one_entry, it
        .local pmc entry_it
        new entry_it, .Iterator, one_entry
        .local BigInt this_bag
        .local BigInt difference
        this_bag = shift entry_it
        difference = subtract_bags (bag, this_bag)
        if difference == 0 goto next_entry
        push smaller_dict, one_entry
        goto next_entry
done:
        new rv, .Iterator, smaller_dict
        .return(rv)
.end

.sub 'combine'
        .param pmc words
        .param pmc in_anagrams
        .local pmc rv
        .local pmc anagrams

#         print "combine: "
#         _dumper (words, "words")
#         _dumper (in_anagrams, "in_anagrams")

        new rv, .ResizablePMCArray
next_word:
        unless words goto cleanup
        clone anagrams, in_anagrams
        .local string one_word
        shift one_word, words
        .local pmc one_anagram
next_anagram:   
        unless anagrams goto next_word
        shift one_anagram, anagrams
        clone one_anagram, one_anagram
        unshift one_anagram, one_word
        push rv, one_anagram
        goto next_anagram
cleanup:
        .return (rv)
.end

.sub 'test_combine'
        load_bytecode 'dumper.pir'
        .local pmc anagrams
        new anagrams, .ResizablePMCArray
        .local pmc temp_list
        new temp_list, .ResizableStringArray
        push temp_list, "foo"
        push temp_list, "bar"
        push temp_list, "baz"
        push anagrams, temp_list
        new temp_list, .ResizableStringArray
        push temp_list, "zap"
        .local pmc result
        result = combine (temp_list, anagrams)
        _dumper (result)
        print "\n\n"
        new temp_list, .ResizableStringArray
        push temp_list, "zip"
        push temp_list, "zap"
        push temp_list, "zop"
        result = combine (temp_list, anagrams)
        _dumper (result)
        print "\n\n"

        new anagrams, .ResizablePMCArray
        new temp_list, .ResizableStringArray
        push temp_list, "one"
        push temp_list, "two"
        push temp_list, "three"
        push anagrams, temp_list
        new temp_list, .ResizableStringArray
        push temp_list, "1"
        push temp_list, "2"
        push temp_list, "3"
        push anagrams, temp_list
        new temp_list, .ResizableStringArray
        push temp_list, "cow"
        push temp_list, "horse"
        result = combine (temp_list, anagrams)
        _dumper (result)
        print "\n\n"
.end

.sub 'dpr'
        .param string text
        .local pmc level
        .local string padding
        level = global "level"
        $I0 = level
        repeat padding, " ", $I0

        printerr padding
        printerr text

.end

.sub 'inc_level'
        .param int howmuch
        .local pmc level
        level = global "level"
        $I0 = level
        $I0 += howmuch
        level = $I0
        global "level" = level
.end
