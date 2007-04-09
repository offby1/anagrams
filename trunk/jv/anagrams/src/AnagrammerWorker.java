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
public class AnagrammerWorker extends SwingWorker<Object, List<String>> {
    private String input;
    private JTextArea output_goes_here;
    @Override
    public String doInBackground() {
        Vector <String> publish_me = new Vector<String>();
        try {
            publish_me.add("foo");
            publish(publish_me);
            java.lang.Thread.sleep(1000);
            
            publish_me.add("bar");
            publish(publish_me);
            java.lang.Thread.sleep(1000);
            
            publish_me.add("baz");
            publish(publish_me);
            java.lang.Thread.sleep(1000);
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
    public AnagrammerWorker(String s, JTextArea jta) {
        input = s;
        output_goes_here = jta;
    }
    
}
