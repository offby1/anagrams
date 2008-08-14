require 'dict'
require 'bag'
require 'getoptlong'

dict_filename = "/usr/share/dict/words"

opts = GetoptLong.new(
                        [ "--dictionary-fn",    "-d",            GetoptLong::OPTIONAL_ARGUMENT ]
                      )

opts.each do |opt, arg|
  dict_filename = arg
end

The_Bag = Bag.new(ARGV[0])
the_dict = Read(dict_filename)
the_dict = Prune(the_dict, The_Bag)

def combine(words, anagrams)
  rv = []
  words.each {
    |w|
    anagrams.each {
      |a|
      rv.push([w] + a)
    }
  }
  rv
end

def anagrams(bag, dict)
  rv = []
  (0..(dict.size - 1)).each {
    |words_processed|
    entry = dict[words_processed]
    key = entry[0]
    words = entry[1]
    smaller_bag = bag - key
    next if (not smaller_bag)
    if (smaller_bag.empty)
      words.each {
        |w|
        rv.push([w])
      }
    else
      from_smaller_bag = anagrams(smaller_bag,
                                  Prune(dict[words_processed..dict.size() - 1], smaller_bag))
      next if (0 == from_smaller_bag.size)
      combine(words, from_smaller_bag).each {
        |new|
        rv.push(new)
      }
    end
  }
  rv
end

result = anagrams(The_Bag, the_dict)

puts "#{result.size} anagrams of #{ARGV[0]}"

puts "("

result.each {
  |a|

  a.each {
    |words|

    printf words.inspect

  }
  puts ""
}
puts ")"
