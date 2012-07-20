#!/usr/bin/env ruby

require './dict'
require './bag'
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
    anagrams.each { |a| rv.push([w] + a) }
  end
  rv
end

def anagrams(bag, dict)
  rv = []
  dict.each_with_index do |entry, words_processed|
    key, words = entry

    smaller_bag = bag - key
    next unless smaller_bag

    if smaller_bag.empty
      words.each { |w| rv.push([w])}
    else
      from_smaller_bag = anagrams(smaller_bag,
                                  dict[words_processed..dict.size() - 1].select do |entry|
                                    smaller_bag - entry[0]
                                  end)

      next unless from_smaller_bag.size > 0

      combine(words, from_smaller_bag).each { |new| rv.push(new)}
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
