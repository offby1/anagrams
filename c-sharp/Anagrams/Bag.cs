using System;
using System.Collections.Generic;
using System.Text;

namespace Anagrams
{
    public class Bag : IComparable
    {
        static private string subtract_strings(string minuend, string subtrahend)
        {
            Bag m = new Bag(minuend);

            Bag s = new Bag(subtrahend);
            Bag diff = m.subtract(s);
            if (diff == null) return null;
            return diff.AsString();
        }

        private string guts;
        public Bag(string s)
        {
            Char[] chars = s.ToLower().ToCharArray();
            Array.Sort(chars);
            Char[] letters = Array.FindAll<char>(chars, Char.IsLetter);
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Insert(0, letters);
            guts = sb.ToString();
        }
        public bool empty()
        {
            return (guts.Length == 0);
        }
        public Bag subtract(Bag subtrahend)
        {
            string m = guts;
            string s = subtrahend.guts;
            string difference = "";

            while (true)
            {
                if (s.Length == 0) return new Bag(difference + m);
                if (m.Length == 0) return null;
                {
                    char s0 = s[0];
                    char m0 = m[0];
                    if (m0 > s0) return null;
                    if (m0 < s0)
                    {
                        m = m.Substring(1);
                        difference += m0;
                        continue;
                    }
                    System.Diagnostics.Trace.Assert(m0 == s0,
                        "internal error!  Aggggh");
                    m = m.Substring(1);
                    s = s.Substring(1);
                }
            }
        }
        private static void test_subtraction(string minuend, string subtrahend, string expected_difference)
        {
            string actual_difference = subtract_strings(minuend, subtrahend);
            System.Diagnostics.Trace.Assert (actual_difference == expected_difference,
                                             "Test failure: "
                                             + "Subtracting `" + subtrahend
                                             + "' from `" + minuend
                                             + "' yielded `" + actual_difference
                                             + "', but should have yielded `" + expected_difference + "'.");
        }
        public static void test()
        {
            test_subtraction("dog", "god", "");
            test_subtraction("ddog", "god", "d");
            test_subtraction("a", "b", null);
            Console.WriteLine("Bag tests all passed.");
        }

        public string AsString()
        {
            return guts;
        }
        public override int GetHashCode()
        {
            return guts.GetHashCode();
        }
        public override bool Equals(object obj)
        {
            return guts.Equals(((Bag)obj).guts);
        }

        #region IComparable Members

        public int CompareTo(object obj)
        {
            Bag other = (Bag)obj;
            if (this.guts.Length > other.guts.Length)
                return -1;
            else if (this.guts.Length < other.guts.Length)
                return 1;
            else
                return 0;
        }

        #endregion
    }
}
