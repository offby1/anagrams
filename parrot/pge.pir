.sub 'pge' :main
#     Once PGE is compiled and installed, you generally load it using the
#     load_bytecode operation, as in

        load_bytecode 'PGE.pbc'          

#     This imports the PGE::P6Regex compiler, which can be used to compile
#     strings of Perl 6 rules. A sample compile sequence would be:

        .local pmc p6regex_compile
        p6regex_compile = compreg 'PGE::P6Regex'         # get the compiler

        .local string pattern       
        .local pmc rulesub                     
        pattern = '^(From|Subject)\:'                  # pattern to compile
        rulesub = p6regex_compile(pattern)             # compile it to rulesub

#     Then, to match a target string we simply call the subroutine to get back
#     a "PGE::Match" object:

        .local pmc match
        $S0 = 'From: pmichaud@pobox.com'               # target string
        match = rulesub($S0)                           # execute rule

#     The Match object is true if it successfully matched, and contains the
#     strings and subpatterns that were matched as part of the capture.
#     Parrot's "Data::Dumper" can be used to quickly view the results of the
#     match:

        load_bytecode 'dumper.pir'
        load_bytecode 'PGE/Dumper.pir'

      match_loop:
        unless match goto match_fail                   # if match fails stop
        print "match succeeded\n"
        _dumper(match)                      
        match.'next'()                                 # find the next match
        goto match_loop

      match_fail:
        print "match failed\n"            
.end
        