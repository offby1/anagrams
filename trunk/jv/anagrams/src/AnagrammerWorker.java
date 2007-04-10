import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import javax.swing.JOptionPane;
import javax.swing.JTextArea;
import javax.swing.SwingWorker;
/*
 * AnagrammerWorker.java
 *
 * Created on April 8, 2007, 3:13 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

/**
 *
 * @author Eric
 */
public class AnagrammerWorker extends SwingWorker<Object, List<String>> {
    private String input;
    private ArrayList<DictionaryReaderWorker.entry> flummoxicillin;
    private JTextArea output_goes_here;
    private ArrayList<DictionaryReaderWorker.entry> prune(Bag input, ArrayList<DictionaryReaderWorker.entry> wordlist) {
        ArrayList<DictionaryReaderWorker.entry> rv = new ArrayList<DictionaryReaderWorker.entry>();
        for (Iterator it = wordlist.iterator(); it.hasNext();) {
            DictionaryReaderWorker.entry elem = (DictionaryReaderWorker.entry ) it.next();
            if (input.subtract(elem.b) != null) {
                rv.add(elem);
            }
        }
        return rv;
    }
    
    String flatten(ArrayList<String> words) {
        String rv = new String();
        for(String w: words) {
            if(rv.length() > 0)
                rv += ", ";
            rv += w;
        }
        return rv;
    }
    
    String flatten_ans(ArrayList<ArrayList<String>> ans) {
        String rv = new String();
        for (ArrayList<String> gram : ans) {
            if (rv.length() > 0) rv += ", ";
            rv += "[" + flatten(gram) + "]";
        }
        return rv;
    }

    private ArrayList<ArrayList<String>> combine(ArrayList<String> ws, ArrayList<ArrayList<String>> ans) {

        ArrayList<ArrayList<String>> rv = new ArrayList<ArrayList<String>> ();

        for (ArrayList<String> a : ans) {
            for (String word : ws) {
                ArrayList<String> bigger_anagram = new ArrayList<String>();
                bigger_anagram.addAll(a);
                bigger_anagram.add(word);
                rv.add(bigger_anagram);
            }
        }
        
        return rv;
    }
    
    private ArrayList<ArrayList<String>> do_em(Bag input,
            ArrayList<DictionaryReaderWorker.entry> wordlist,
            int recursion_level) {
        
        ArrayList<ArrayList<String>> rv = new ArrayList<ArrayList<String>>();
        
        wordlist = prune(input, wordlist);
        while (wordlist.size() > 0) {
            DictionaryReaderWorker.entry elem = wordlist.get(0);
            Bag diff = input.subtract(elem.b);
            
            if (diff != null) {
                if (diff.empty()) {
                    
                    for (int i = 0; i < elem.words.size(); i++) {
                        ArrayList<String> loner = new ArrayList<String>();
                        loner.add(elem.words.get(i));
                        if (recursion_level == 0)
                            publish(loner);
                        rv.add(loner);
                    }
                } else {
                    
                    ArrayList<ArrayList<String>> from_smaller = do_em(
                                                                      diff,
                                                                      wordlist,
                                                                      recursion_level + 1
                                                                      );
                    if (from_smaller.size() > 0) {
                        rv.addAll(combine(elem.words, from_smaller));
                    }
                }
            }
            int before = wordlist.size();
            wordlist.remove(0);
            int after = wordlist.size();
        }
        if (recursion_level == 0)
        {
            for (ArrayList<String> an : rv) {
                publish(an);
            }
        }
        
        return rv;
    }
    @Override
    public String doInBackground() {
        do_em(new Bag(input), flummoxicillin, 0);
        
        return null;
    }
    @Override
    protected void done() {
        output_goes_here.setEnabled(true);
    }
    @Override
    protected void process(List<List<String>> some_anagrams){
        for (Iterator it = some_anagrams.iterator(); it.hasNext();) {
            List<String> one_anagram = (List<String>) it.next();
            String flattened = new String();
            for (Iterator it2 = one_anagram.iterator(); it2.hasNext();) {
                Object elem = (Object) it2.next();
                if (flattened.length() > 0)
                    flattened += ", ";
                flattened += elem;
            }
            output_goes_here.append(flattened + "\n");
        }
    }
    /** Creates a new instance of AnagrammerWorker */
    public AnagrammerWorker(String s, JTextArea jta,
            ArrayList<DictionaryReaderWorker.entry> wl) {
        input = s;
        output_goes_here = jta;
        flummoxicillin = wl;
    }
}
