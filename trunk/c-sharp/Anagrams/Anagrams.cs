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
    public delegate void bottom_of_main_loop();
    public delegate void done_pruning(uint recursion_level, List<bag_and_anagrams> pruned);
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
        private static List<bag_and_anagrams> prune(Bag bag, List<bag_and_anagrams> dictionary, done_pruning done_pruning_callback, uint recursion_level)
        {
            List<bag_and_anagrams> rv = new List<bag_and_anagrams>();
            foreach (bag_and_anagrams pair in dictionary)
            {
                Bag this_bag = pair.b;
                if (bag.subtract(this_bag) != null)
                {
                    rv.Add(pair);
                }
            }
            done_pruning_callback(recursion_level, rv);
            return rv;
        }


        public static anagrams anagrams(Bag bag,
            List<bag_and_anagrams> dictionary,
            uint recursion_level,
            bottom_of_main_loop bottom,
            done_pruning done_pruning_callback,
            found_anagram success_callback)
        {
            anagrams rv = new anagrams();
            List<bag_and_anagrams> pruned = prune(bag,
                dictionary,
                done_pruning_callback,
                recursion_level);
            int pruned_initial_size = pruned.Count;
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
                            if (recursion_level == 0)
                                success_callback(loner);
                        }
                    }
                    else
                    {
                        anagrams from_smaller = anagrams(diff, pruned, recursion_level + 1,
                            bottom,
                            done_pruning_callback,
                            success_callback);
                        anagrams combined = combine(entry.words, from_smaller);
                        foreach (strings an in combined)
                        {
                            rv.Add(an);
                            if (recursion_level == 0)
                                success_callback(an);
                        }
                    }
                }
                pruned.RemoveAt(0);
                if (recursion_level == 0)
                    bottom();

                Application.DoEvents();
            }
            return rv;
        }

    }
}
