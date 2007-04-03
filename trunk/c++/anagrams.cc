#include <iostream>
#include <sstream>
#include <cassert>

#include "numeric-bag.h"
#include "dict.h"

std::vector<entry > the_dictionary;

namespace {
  std::ostream &
  operator <<(std::ostream &o, const wordlist &w)
  {
    for (wordlist::const_iterator i = w.begin ();
         i != w.end ();
         i++)
      {
        o << *i;
        if (i + 1 != w.end ())
          o << " ";
      }
    return o;
  }

  std::ostream &
  operator <<(std::ostream &o, const std::vector<wordlist> &anagrams)
  {
    o << "(";
    for (std::vector<wordlist>::const_iterator i = anagrams.begin ();
         i != anagrams.end ();
         i++)
      {
        o << *i;
        if (i + 1 != anagrams.end ())
          o << " ";
      }
    o << ")";
    return o;
  }

  std::string
  wordlist_to_string (const wordlist &wl)
  {
    std::ostringstream o;
    o << wl;
    return o.str ();
  }

  std::vector<wordlist>
  prepend_words_to_anagrams (const wordlist &these_words,
                             const std::vector<wordlist> &some_anagrams)
  {
    assert (these_words.size ());
    assert (some_anagrams.size ());

    std::vector<wordlist> rv;
    for (wordlist::const_iterator word = these_words.begin ();
         word != these_words.end ();
         word++)
      {
        for (std::vector<wordlist>::const_iterator an = some_anagrams.begin ();
             an != some_anagrams.end ();
             an++)
          {
            wordlist one_new_anagram;
            one_new_anagram.push_back (*word);
            for (wordlist::const_iterator i = an->begin ();
                 i != an->end ();
                 i++)
              one_new_anagram.push_back (*i);
            rv.push_back (one_new_anagram);
          }
      }

    return rv;
  }
}

std::ostream &
operator <<(std::ostream &o, const entry &e)
{
  o << "["
    << e.first
    << " => "
    << e.second
    << "]";
  return o;
}


std::vector<wordlist>
anagrams_internal (const bag &b,
                   std::vector<entry>::const_iterator dict,
                   std::vector<entry>::const_iterator dict_end,
                   unsigned int level)
{
  std::vector<wordlist> rv;
  bag *smaller_bag = 0;
  for (;
       dict != dict_end;
       dict++)
    {
      delete smaller_bag; smaller_bag = 0;

      const bag &key_bag (dict->first);
      const wordlist &these_words (dict->second);

      smaller_bag = (b.subtract_bag (key_bag));
      if (!smaller_bag) continue;

      if (smaller_bag->is_empty ())
        {
          for (wordlist::const_iterator wd = these_words.begin ();
               wd != these_words.end ();
               wd++)
            {
              wordlist result;
              result.push_back (*wd);
              rv.push_back (result);
            }
        }
      else
        {
          std::vector<entry> pruned;
          for (std::vector<entry>::const_iterator i = dict;
               i != dict_end;
               i++)
            {
              const bag&candidate = i->first;
              const bag *tmp = smaller_bag->subtract_bag(candidate);
              if (tmp)
                {
                  delete tmp;
                  pruned.push_back (*i);
                }
            }
          std::vector<wordlist> from_smaller_bag (anagrams_internal (*smaller_bag,
                                                                     pruned.begin(),
                                                                     pruned.end(),
                                                                     level + 1));
          if (!from_smaller_bag.size ()) continue;
          std::vector<wordlist> more (prepend_words_to_anagrams (these_words, from_smaller_bag));
          for (std::vector<wordlist>::const_iterator i = more.begin ();
               i != more.end ();
               i++)
            {
              rv.push_back (*i);
            }
        }
    }

  return rv;
}

std::vector<wordlist>
all_anagrams (const bag &b)
{
  std::cerr << "Snarfing the dictionary and whatnot ... ";
  init (b);
  std::cerr << " done" << std::endl;
  return anagrams_internal (b,
                            the_dictionary.begin (),
                            the_dictionary.end (),
                            0);
}

#if 1
int
main (int argc, char *argv[])
{
  try {
    if (argc > 1)
      {
        argc--;
        argv++;

        const std::string input = argv[0];
        const bag b (input);

        std::vector<wordlist> ans (all_anagrams (b));
        std::cerr << ans.size () << " anagrams of " << input << std::endl;
        for (std::vector<wordlist>::const_iterator i = ans.begin ();
             i != ans.end ();
             i++)
          {
            std::cout << "("
                      << *i
                      << ")"
                      << std::endl;
          }
      }
  } catch (std::exception &e)
    {
      std::cerr << e.what () << std::endl;
    }
}
#endif

