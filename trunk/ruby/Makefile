all:

profile:
	time ruby -I /usr/local/stow/ruby/lib/ruby/gems/1.8/gems/ZenHacks-1.0.1/lib/	\
		-I /usr/local/stow/ruby/lib/ruby/gems/1.8/gems/RubyInline-3.5.0		\
		-rzenprofile anagrams.rb "Ernest"

check:
	ruby test_bag.rb
	time ruby anagrams.rb "Ernest Hemingway"


.PHONY: all check
