import java.awt.HeadlessException;
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
    private void do_em(Bag input, Vector<DictionaryReaderWorker.entry> wordlist) {
        int entries_examined = 0;
        int things_published = 0;
        for (Iterator it = wordlist.iterator(); it.hasNext();) {
            DictionaryReaderWorker.entry elem = (DictionaryReaderWorker.entry) it.next();
            if (true) {
                if (elem.words.length > 1) {
                    ArrayList<String> l = new ArrayList<String>();
                    l.add(String.format("%d: %s",
                            entries_examined,
                            elem.b.toString()));
                    
                    for (int i = 0; i < elem.words.length; i++) {
                        l.add(elem.words[i]);
                    }
                    publish(l);
                    things_published++;
                }
            }
            entries_examined++;
        }
        JOptionPane.showMessageDialog(null, String.format("published %d gizmos", things_published));
    }
    @Override
    public String doInBackground() {
        Vector <String> publish_me = new Vector<String>();
        try {
            publish_me.add(String.format("working ... on wordlist with %d elements ...",
                    wordlist.size()));
            publish(publish_me);
            
            java.lang.Thread.sleep(1000);
            publish_me.clear();
            publish_me.add(wordlist.get(0).words[0]);
            publish(publish_me);
            
            java.lang.Thread.sleep(1000);
            publish_me.clear();
            publish_me.add(wordlist.get(1).words[0]);
            publish(publish_me);
            java.lang.Thread.sleep(1000);
            
            publish_me.clear();
            publish_me.add(wordlist.get(2).words[0]);
            publish(publish_me);
            java.lang.Thread.sleep(1000);
            do_em(new Bag(input), wordlist);
        } catch (HeadlessException ex) {
            ex.printStackTrace();
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        }
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
