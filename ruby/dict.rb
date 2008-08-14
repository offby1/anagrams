require 'bag'

# First snarf the dictionary and do as much pre-processing as we can

def Read(fn)
  the_dict = {}
  begin
    File.open("hash.cache", "r") do |fp|
      printf "Snarfing hash.cache ..."
      $stdout.flush
      the_dict = Marshal.load(fp.read)
      puts "Loaded dictionary from hash.cache"
    end

  rescue Errno::ENOENT
    File.open(fn, "r") do |aFile|
      the_dict = {}
      printf "Snarfing #{fn} ..."
      $stdout.flush
      has_a_vowel_re = /[aeiou]/
      long_enough_re = /^(..|i|a)/
      has_a_non_letter_re = /[^a-z]/
      aFile.each_line do |aLine|
        aLine.chomp!()
        aLine.downcase!()
        next if has_a_non_letter_re.match(aLine)
        next if !has_a_vowel_re.match(aLine)
        next if !long_enough_re.match(aLine)

        b = Bag.new(aLine)
        if (the_dict.has_key?(b))
          the_dict[b] = the_dict[b] | [aLine]     # avoid duplicates
        else
          the_dict[b] = [aLine]
        end

      end
      puts " (#{the_dict.length} slots) done"
    end
    File.open("hash.cache", "w") do |aCache|
      Marshal.dump(the_dict, aCache)
      puts "Wrote hash.cache"
    end
  end
  the_dict
end

def Prune(dict, max)
  result = []
  dict.each {
    | bag, words |
    if (max - bag)
      result.push([bag, words])
    end
  }

  result
end

