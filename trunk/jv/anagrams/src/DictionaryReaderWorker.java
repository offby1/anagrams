import javax.swing.SwingWorker;
import java.util.Hashtable;
import java.util.Iterator;
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
public class DictionaryReaderWorker extends SwingWorker<String, Void> {
    @Override
    public String doInBackground() {
        try {
            java.io.BufferedReader in
                    = new java.io.BufferedReader(new java.io.FileReader(System.getProperty("user.home") + "/doodles/anagrams/words"));
            
            setProgress(0);
            // We'll loop twice: once to read the word file into a simple list, and again to convert the list into a hash table.
            // Since the first loop is fast and the second slow, this lets us initialize a progress bar for the second loop,
            // since we'll know how many items need to be processed.
            java.util.Vector<String> words_from_file = new java.util.Vector<String>();
            {
                String line;
                
                while ((line = in.readLine()) != null) {
                    // TODO -- do the Java equivalent of C sharps "Application.DoEvents()" here
                    line = line.toLowerCase();
                    if (line.length() > 1 || line == "i" || line == "a"){
                        if (line.contains("a") || line.contains("e") || line.contains("i") || line.contains("o") || line.contains("u") || line.contains("y")) {
                            words_from_file.add(line);
                        }
                    }
                }
            }
            NewJFrame.ht
                    = new Hashtable<Bag, java.util.Vector<String>>();
            int words_examined = 0;
            for (Iterator it = words_from_file.iterator(); it.hasNext();) {
                String line = (String) it.next();
                
                Bag linebag = new Bag(line);
                java.util.Vector<String> existing = NewJFrame.ht.get(linebag);
                if (existing == null)
                    existing = new java.util.Vector<String>();
                
                
                if (!existing.contains(line))
                    existing.add(line);
                NewJFrame.ht.put(linebag, existing);
                
                setProgress(++words_examined * 100 / words_from_file.size());
            }
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "Useless";
    }
    
    @Override
    protected void done() {
        
    }
    /** Creates a new instance of DictionaryReaderWorker */
    public DictionaryReaderWorker() {
    }
    
}
