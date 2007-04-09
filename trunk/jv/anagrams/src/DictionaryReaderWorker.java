import java.util.Enumeration;
import javax.swing.SwingWorker;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;
/*
 * DictionaryReaderWorker.java
 *
 * Created on April 7, 2007, 1:33 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

/**
 *
 * @author Eric
 */
public class DictionaryReaderWorker extends SwingWorker<Vector<Vector<Object>>, Void> {
    public Vector<Vector<Object>> rv ;
    
    @Override
    public Vector<Vector<Object>> doInBackground() {
        try {
            // TODO -- Rather than hard-coding this, use a FileOpen
            // dialog to get it; then cache the content somewhere.
            // Not to save time (it's mighty fast as it is), but so
            // that we don't have to see the dialog more than once per
            // computer.
            java.io.BufferedReader in
                    = new java.io.BufferedReader(new java.io.FileReader(System.getProperty("user.home") + "/doodles/anagrams/words"));
            
            setProgress(0);
            // We'll loop twice: once to read the word file into a simple list, and again to convert the list into a hash table.
            // Since the first loop is fast and the second slow, this lets us initialize a progress bar for the second loop,
            // since we'll know how many items need to be processed.
            Vector<String> words_from_file = new Vector<String>();
            {
                String line;
                
                while ((line = in.readLine()) != null) {
                    line = line.toLowerCase();
                    if (line.length() > 1 || line == "i" || line == "a"){
                        line = line.replaceAll("\\W+", "");
                        if (line.contains("a") || line.contains("e") || line.contains("i") || line.contains("o") || line.contains("u") || line.contains("y")) {
                            words_from_file.add(line);
                        }
                    }
                }
            }
            NewJFrame.ht
                    = new Hashtable<Bag, Vector<String>>();
            int words_examined = 0;
            for (Iterator it = words_from_file.iterator(); it.hasNext();) {
                String line = (String) it.next();
                
                Bag linebag = new Bag(line);
                Vector<String> existing = NewJFrame.ht.get(linebag);
                if (existing == null)
                    existing = new Vector<String>();
                
                
                if (!existing.contains(line))
                    existing.add(line);
                NewJFrame.ht.put(linebag, existing);
                
                setProgress(++words_examined * 100 / words_from_file.size());
            }
            rv = new Vector<Vector<Object>>();
            for (Enumeration<Bag> e = NewJFrame.ht.keys(); e.hasMoreElements();) {
                Bag bag = e.nextElement();
                Vector<String> words = NewJFrame.ht.get(bag);
                Vector<Object> one_entry = new Vector<Object>();
                one_entry.add(bag);
                one_entry.add(words);
                rv.add(one_entry);
            }
        }
        
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return rv;
    }
    
    
    @Override
    protected void done() {
        
    }
    /** Creates a new instance of DictionaryReaderWorker */
    public DictionaryReaderWorker() {
    }
    
}
