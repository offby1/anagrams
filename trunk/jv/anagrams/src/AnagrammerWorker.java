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
    private Vector<DictionaryReaderWorker.entry> wordlist;
    private JTextArea output_goes_here;
    private Vector<DictionaryReaderWorker.entry> prune(Bag input, Vector<DictionaryReaderWorker.entry> wordlist) {
        Vector<DictionaryReaderWorker.entry> rv = new Vector<DictionaryReaderWorker.entry>();
        for (Iterator it = wordlist.iterator(); it.hasNext();) {
            DictionaryReaderWorker.entry elem = (DictionaryReaderWorker.entry ) it.next();
            if (input.subtract(elem.b) != null) {
                rv.add(elem);
            }
        }
        return rv;
    }
    private Vector<Vector<String>> combine(String[] words, Vector<Vector<String>> ans) {
        Vector<Vector<String>> rv = new Vector<Vector<String>> ();
        return rv;
    }
    private Vector<Vector<String>> do_em(Bag input, Vector<DictionaryReaderWorker.entry> wordlist) {
        Vector<Vector<String>> rv = new Vector<Vector<String>>();
        int entries_examined = 0;
        wordlist = prune(input, wordlist);
        for (Iterator it = wordlist.iterator(); it.hasNext();) {
            DictionaryReaderWorker.entry elem = (DictionaryReaderWorker.entry) it.next();
            Bag diff = input.subtract(elem.b);
            if (diff != null){
                if (diff.empty()) {
                    for (int i = 0; i < elem.words.length; i++) {
                        Vector<String> loner = new Vector<String>();
                        loner.add(elem.words[i]);
                        rv.add(loner);
                    }
                } else {
                    // BUGBUG TODO YAYAYAYA -- don't pass wordlist; instead pass the dictionary starting at the current element.
                    Vector<Vector<String>> from_smaller = do_em(diff, wordlist);
                    if (from_smaller.size() > 0) {
                        rv.addAll(combine(elem.words, from_smaller));
                    }
                }
            }
            ArrayList<String> l = new ArrayList<String>();
            l.add(String.format("%d: %s",
                    entries_examined,
                    elem.b.toString()));
            
            for (int i = 0; i < elem.words.length; i++) {
                l.add(elem.words[i]);
            }
            publish(l);
            entries_examined++;
        }
        return rv;
    }
    @Override
    public String doInBackground() {
        Vector <String> publish_me = new Vector<String>();
        
        publish_me.add(String.format("working ... on wordlist with %d elements ...",
                wordlist.size()));
        publish(publish_me);
        do_em(new Bag(input), wordlist);
        
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
            Vector<DictionaryReaderWorker.entry> wl) {
        input = s;
        output_goes_here = jta;
        wordlist = wl;
    }
    
}
