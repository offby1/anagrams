#include <stdexcept>
#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <cstring>
#include <cassert>
#include <regex.h>
#include <cerrno>

#include "dict.h"

bool
entry::operator < (const entry &other) const
{
  bool rv = ((this->second.at(0).size () > other.second.at(0).size ())
             ||
             (this->second.at(0).size () == other.second.at(0).size ()
              &&
              this->second.at(0) < other.second.at(0)));
  return rv;
}

namespace {
  regex_t has_a_vowel;
  regex_t is_long_enough;
  regex_t contains_non_ascii;

  bool
  acceptable (const bag&filter,
              const std::string &candidate)
  {
    bag *difference = filter.subtract_bag (candidate);
    bool rv = ((0 == (regexec (&has_a_vowel       , candidate.c_str (), 0, 0, 0)))
               &&
               (0 == (regexec (&is_long_enough    , candidate.c_str (), 0, 0, 0)))
               &&
               (0 != (regexec (&contains_non_ascii, candidate.c_str (), 0, 0, 0)))
               &&
               difference
               );
    delete difference;
    return rv;
  }
}

typedef std::map<bag, wordlist> hash_t;

void
init (const bag &filter)
{
  assert (!regcomp (&has_a_vowel       , "[aeiou]"     , REG_EXTENDED | REG_NOSUB));
  assert (!regcomp (&is_long_enough    , "^(i|a)$|^.." , REG_EXTENDED | REG_NOSUB));
  assert (!regcomp (&contains_non_ascii, "[^[:alpha:]]", REG_EXTENDED | REG_NOSUB));

  hash_t  hash;
  
  const std::string dict_file_name ("/usr/share/dict/words");
  std::ifstream words (dict_file_name.c_str ());
  if (!words)
    {
      std::ostringstream whine;
      whine << "Can't open dictionary `";
      whine << dict_file_name;
      whine << "' because ";
      whine << strerror (errno);
      throw std::runtime_error (whine.str ());
    }
  while (words)
    {
      std::string one_string;
      words >> one_string;

      for (int i = 0; i < one_string.size (); i++)
        {one_string.at (i) = tolower (one_string.at (i));}

      bag one_bag (one_string);
      if (acceptable (filter,
                      one_string))
        {
          hash_t::iterator existing = hash.find(one_bag);
          if (existing == hash.end ())
            {
              wordlist singleton;
              singleton.push_back (one_string);

              hash.insert (entry (one_bag, singleton));
            }
          else
            {
              bool duplicate = false;
              for (wordlist::const_iterator i = existing->second.begin ();
                   !duplicate && i != existing->second.end ();
                   i++)
                {
                  if (*i == one_string)
                    {
                      duplicate = true;
                    }
                }
              if (!duplicate)
                {
                  existing->second.push_back (one_string);
                  hash.insert (entry (existing->first, existing->second));
                }
            }
        }
    }

  // now convert the hash to a list.
  for (hash_t::const_iterator i = hash.begin ();
       i != hash.end ();
       i++)
    {
      the_dictionary.push_back (entry (i->first, i->second));
    }

  sort (the_dictionary.begin (),
        the_dictionary.end ());
  
  std::cout << "hash           hath " << hash          .size () << " elements" << std::endl;
  std::cout << "the_dictionary hath " << the_dictionary.size () << " elements" << std::endl;
}

#if 0
int
main ()
{
  bag b ("hey");
  init (b);
}
#endif
