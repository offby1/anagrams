using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace Anagrams
{
    public class strings : List<string>
    {
    }
    public class anagrams : List<strings>
    {
    }

    // callback functions to indicate progress.
    public delegate void started_pruning(Bag filter, List<bag_and_anagrams> dict);
    public delegate void pruned_one();
    public delegate void done_pruning();
    public delegate void found_anagram(strings words);

    // each entry is a bag followed by words that can be made from that bag.

    public class bag_and_anagrams : IComparable
    {
        public Bag b;
        public strings words;

        // *sigh* this is tediously verbose
        public bag_and_anagrams(Bag b, strings words)
        {
            this.b = b;
            this.words = words;
        }

        #region IComparable Members

        public int CompareTo(object obj)
        {
            return this.b.CompareTo(((bag_and_anagrams)obj).b);
        }

        #endregion
    }

    class Anagrams
    {

        // given a list of words and a list of anagrams, make more
        // anagrams by combining the two.
        private static anagrams combine(strings ws, anagrams ans)
        {
            anagrams rv = new anagrams();
            foreach (strings a in ans)
            {
                foreach (string word in ws)
                {
                    strings bigger_anagram = new strings();
                    bigger_anagram.InsertRange(0, a);
                    bigger_anagram.Add(word);
                    rv.Add(bigger_anagram);
                }
            }

            return rv;
        }

        // return a list that is like d, but which contains only those items which can be made from the letters in b.
        private static List<bag_and_anagrams> prune(Bag bag, List<bag_and_anagrams> dictionary, started_pruning started_pruning_callback, pruned_one pruned_one_callback, done_pruning done_pruning_callback, uint recursion_level)
        {
            started_pruning_callback(bag, dictionary);
            List<bag_and_anagrams> rv = new List<bag_and_anagrams>();
            foreach (bag_and_anagrams pair in dictionary)
            {
                Bag this_bag = pair.b;
                if (bag.subtract(this_bag) != null)
                {
                    rv.Add(pair);
                }
                pruned_one_callback();
            }
            done_pruning_callback();
            return rv;
        }


        public static anagrams anagrams(Bag bag,
            List<bag_and_anagrams> dictionary,
            uint recursion_level,
            started_pruning started_pruning_callback,
            pruned_one pruned_one_callback,
            done_pruning done_pruning_callback,
            found_anagram success_callback)
        {
            anagrams rv = new anagrams();
            List<bag_and_anagrams> pruned = prune(bag,
                dictionary,
                started_pruning_callback,
                pruned_one_callback,
                done_pruning_callback,
                recursion_level);
            while (pruned.Count > 0)
            {
                bag_and_anagrams entry = pruned[0];
                Bag this_bag = entry.b;
                Bag diff = bag.subtract(this_bag);
                if (diff != null)
                {
                    if (diff.empty())
                    {
                        foreach (string w in entry.words)
                        {
                            strings loner = new strings();
                            loner.Add(w);
                            rv.Add(loner);
                        }
                    }
                    else
                    {
                        anagrams from_smaller = anagrams(diff, pruned, recursion_level + 1,
                            started_pruning_callback,
                            pruned_one_callback,
                            done_pruning_callback,
                            success_callback);
                        if (from_smaller.Count > 0)
                        {
                            rv.AddRange(combine(entry.words, from_smaller));
                        }
                    }
                }
                pruned.RemoveAt(0);
                Application.DoEvents();
            }
            if (recursion_level == 0)
            {

                foreach (strings anagram in rv)
                {
                    success_callback(anagram);
                }
            }
            return rv;
        }

    }
}
