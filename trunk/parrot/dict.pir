# -*-pir-*-
.sub 'snarf_dict' :main
        load_bytecode 'PGE.pbc'
        load_bytecode 'bag.pbc'
        load_bytecode 'dumper.pir'
        load_bytecode 'String/Utils.pbc'
        .local pmc chomp
        .local string one_line
        .local pmc infile_handle
        .local string cache_file
        .local int stat_info
        cache_file = 'dict.cache'
#        cache_file = 'dict.cache.little'
        .local pmc dict_hash    # used to build up the final entries
        new dict_hash, .Hash

        chomp = get_global ['String';'Utils'], 'chomp'

        bag_init()
        stat stat_info, cache_file, 0
        if stat_info goto call_snarf_cache
        say "No dict cache; reading the actual dictionary"
#        infile_handle = open "words-100", "<"
        infile_handle = open "/usr/share/dict/words", "<"

        .local pmc p5regex_compile
        p5regex_compile = compreg 'PGE::P5Regex'         # get the compiler
        .local pmc has_a_vowel_rulesub, long_enough_rulesub, non_alpha_rulesub, match
        .local pmc the_bag
        has_a_vowel_rulesub = p5regex_compile('[aeiouyAEIOUY]')
        long_enough_rulesub = p5regex_compile('[iaIA]|..')
        non_alpha_rulesub   = p5regex_compile('[^a-zA-Z]')

next_line:
        readline one_line, infile_handle
        length I0, one_line
        if I0 == 0 goto write_cache

        chomp (one_line)
        downcase one_line
        match = has_a_vowel_rulesub (one_line)
        unless match goto next_line

has_vowel:
        match = long_enough_rulesub (one_line)
        unless match goto next_line

nothing_weird:
        match = non_alpha_rulesub (one_line)
        unless match goto acceptable

goto next_line

acceptable:
        .local pmc existing_entry
        the_bag = make_bag (one_line)

        existing_entry = dict_hash[the_bag]
        unless_null existing_entry, adjoin
        .local pmc new_entry
        new new_entry, .ResizablePMCArray
        push new_entry, one_line
        dict_hash[the_bag] = new_entry
        goto next_line

adjoin: 
        adjoin (one_line, existing_entry)
        goto next_line

call_snarf_cache:
        say "Snarfing the cache"
        .local pmc entries
        entries = snarf_cache (cache_file)
        print entries
        print " distinct bags\n"
        goto cleanup
write_cache:
        entries = write_cache (dict_hash, cache_file)
cleanup:
        close infile_handle
        .return (entries)
.end

.sub 'adjoin'
        .param string s
        .param pmc list
        .local pmc iterator

        new iterator, .Iterator, list
next:   
        unless iterator goto push
        .local string this_entry
        shift this_entry, iterator
        if this_entry == s goto done
        goto next
push:   push list, s
done:
.end

.sub 'write_entry'
        .param pmc cache_fd
        .param pmc this_bag
        .param pmc these_words
        .local pmc iterator
        .local pmc word

        print cache_fd, this_bag
        
        new iterator, .Iterator, these_words
next_word:   
        unless iterator goto done
        shift word, iterator
        print cache_fd, ","
        print cache_fd, word
        goto next_word
done:
        print cache_fd, "\n"
.end

.sub 'write_cache'
        .param pmc hash
        .param string cache_file_name
        .local pmc iterator
        .local pmc cache_fd
        .local pmc entries_as_written
        cache_fd = open cache_file_name, ">"
        new iterator, .Iterator, hash
        new entries_as_written, .ResizablePMCArray
next:   
        unless iterator goto cleanup
        .local string digit_string
        .local pmc this_bag
        .local pmc these_words
        .local pmc one_entry
        new one_entry, .ResizablePMCArray
        shift digit_string, iterator
        new this_bag, .BigInt
        set this_bag, digit_string
        these_words = hash[digit_string]
        write_entry (cache_fd, digit_string, these_words)
        push one_entry, this_bag
next_word:      
        if these_words goto one_word
        push entries_as_written, one_entry
        goto next
one_word:       
        .local pmc one_word
        shift one_word, these_words
        push one_entry, one_word
        goto next_word
cleanup:
        close cache_fd
        .return (entries_as_written)
.end

.sub 'snarf_cache'
        .param string cache_file_name
        .local string one_line
        .local pmc cache_fd
        .local pmc rv
        .local pmc fields
        .local pmc chomp
        .local pmc bag
        new rv, .ResizablePMCArray
        chomp = get_global ['String';'Utils'], 'chomp'
        cache_fd = open cache_file_name, "<"
next_line:       
        readline one_line, cache_fd
        unless one_line goto cleanup
        chomp (one_line)
        split fields, ",", one_line

        .local string digit_string
        shift digit_string, fields
        new bag, .BigInt
        set bag, digit_string

        .local pmc iterator
        new iterator, .Iterator, fields
        .local pmc one_entry
        new one_entry, .ResizablePMCArray
        push one_entry, bag
next_word:      
        unless iterator goto finish_entry
        .local string one_field
        shift one_field, iterator
        push one_entry, one_field
        goto next_word
finish_entry:
        push rv, one_entry
        goto next_line
cleanup:
        close cache_fd
        .return (rv)
.end
