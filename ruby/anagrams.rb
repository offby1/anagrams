#!/usr/bin/env ruby

require 'dict'
require 'bag'
require 'getoptlong'

dict_filename = "../words.utf8"

opts = GetoptLong.new(
                        [ "--dictionary-fn",    "-d",            GetoptLong::OPTIONAL_ARGUMENT ]
                      )

opts.each do |opt, arg|
  dict_filename = arg
end

The_Bag = Bag.new(ARGV[0] || "")
the_dict = Read(dict_filename)

def combine(words, anagrams)
  rv = []
  words.each do |w|
    anagrams.each do
      |a|
      rv.push([w] + a)
    end
  end
  rv
end

def anagrams(bag, dict)
  rv = []
  (0..(dict.size - 1)).each do |words_processed|
    key, words = dict[words_processed]

    smaller_bag = bag - key
    next if (not smaller_bag)
    if (smaller_bag.empty)
      words.each do |w|
        rv.push([w])
      end
    else
      from_smaller_bag = anagrams(smaller_bag,
                                  dict[words_processed..dict.size() - 1].select do |entry|
                                    smaller_bag - entry[0]
                                  end)
      next if (0 == from_smaller_bag.size)
      combine(words, from_smaller_bag).each do |new|
        rv.push(new)
      end
    end
  end
  rv
end

result = anagrams(The_Bag, the_dict)

puts "#{result.size} anagrams of #{ARGV[0]}"

puts "("

result.each do |a|

  a.each do |words|
    printf words.inspect
  end
  puts ""
end
puts ")"
