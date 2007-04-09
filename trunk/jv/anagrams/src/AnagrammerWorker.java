import java.awt.HeadlessException;
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
public class AnagrammerWorker extends SwingWorker<Object, Vector<String>> {
    private String input;
    private Vector<Vector<Object>> wordlist;
    
    // I suspect that, in order to do things the Politically-Correct
    // Java Way, I should make this member not a JTextArea, but
    // rather the highest class that supports the few methods I call
    // on it.
    private JTextArea output_goes_here;
    
    @Override
    protected String doInBackground() {
        try {
            //anagrams (input, wordlist);
            JOptionPane.showMessageDialog(null, "doin background got called");
            Vector <String> publish_me = new Vector<String>();
            publish_me.add(String.format("working ... on wordlist with %d elements ...\n",
                    wordlist.size()));
            publish(publish_me);
            publish_me.clear();
            publish_me.add("working ...");
            publish(publish_me);
            java.lang.Thread.sleep(5000);
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        }
        return null;
    }
    @Override
    protected void done() {
        output_goes_here.append("OK, all done!");
        output_goes_here.setEnabled(true);
    }
    @Override
    protected void process(List some_anagrams){
        JOptionPane.showMessageDialog(null, "process got called");
        for (Iterator it = some_anagrams.iterator(); it.hasNext();) {
            Vector<String> one_anagram = (Vector<String>) it.next();
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
    public AnagrammerWorker(String s,
            JTextArea jta,
            Vector<Vector<Object>> wordlist) {
        input = s;
        output_goes_here = jta;
    }
    
}
