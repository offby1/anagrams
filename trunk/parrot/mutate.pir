.sub 'main' :main
        load_bytecode 'dumper.pir'
        .local ResizablePMCArray rv
        .local ResizableStringArray fields
        new rv, .ResizablePMCArray
        split fields, ",", "hey,you"
        _dumper (fields)

        .local pmc big
        new big, .BigInt
        _dumper (big)

        set big, "1234567890987654321"
        _dumper (big)

        push rv, big

        .local pmc iterator
        new iterator, .Iterator, fields
        unless iterator goto done
        .local string one_word
        shift one_word, iterator
        push rv, one_word
done:   
        _dumper (rv)
.end
