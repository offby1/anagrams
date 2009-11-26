
import java.util.ArrayList;
import java.util.Enumeration;
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
public class DictionaryReaderWorker extends SwingWorker<ArrayList<DictionaryReaderWorker.entry>, Void> {

    public class entry {

        public Bag b;
        public ArrayList<String> words;
    }
    public ArrayList<entry> rv;

    @Override
    public ArrayList<DictionaryReaderWorker.entry> doInBackground() {
        try {
            java.io.BufferedReader in =
                new java.io.BufferedReader(new java.io.FileReader(this.dict_full_name));

            setProgress(0);
            // We'll loop twice: once to read the word file into a simple list, and again to convert the list into a hash table.
            // Since the first loop is fast and the second slow, this lets us initialize a progress bar for the second loop,
            // since we'll know how many items need to be processed.
            ArrayList<String> words_from_file = new ArrayList<String>();
            {
                String line;

                while ((line = in.readLine()) != null) {
                    line = line.toLowerCase();
                    if (line.length() > 1 || line.equalsIgnoreCase("i") || line.equalsIgnoreCase("a")) {
                        // BUGBUG -- this removes perfectly good vowels, like LATIN SMALL LETTER E WITH ACUTE
                        line = line.replaceAll("\\W+", "");
                        if (line.contains("a") || line.contains("e") || line.contains("i") || line.contains("o") || line.contains("u") || line.contains("y")) {
                            words_from_file.add(line);
                        }
                    }
                }
            }
            NewJFrame.ht = new Hashtable<Bag, ArrayList<String>>();
            int words_examined = 0;
            for (Iterator it = words_from_file.iterator(); it.hasNext();) {
                String line = (String) it.next();

                Bag linebag = new Bag(line);
                ArrayList<String> existing = NewJFrame.ht.get(linebag);
                if (existing == null) {
                    existing = new ArrayList<String>();
                }


                if (!existing.contains(line)) {
                    existing.add(line);
                }
                NewJFrame.ht.put(linebag, existing);


                setProgress(++words_examined * 100 / words_from_file.size());
            }
            rv = new ArrayList<entry>();
            for (Enumeration<Bag> e = NewJFrame.ht.keys(); e.hasMoreElements();) {
                Bag bag = e.nextElement();
                ArrayList<String> words = NewJFrame.ht.get(bag);

                entry ent = new entry();
                ent.b = bag;
                ent.words = words;
                rv.add(ent);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return rv;
    }

    @Override
    protected void done() {
    }
    private static javax.swing.JFrame parent_frame;
    public static String dict_full_name;

    /** Creates a new instance of DictionaryReaderWorker */
    public DictionaryReaderWorker(javax.swing.JFrame ParentFrame) {

        this.parent_frame = ParentFrame;
        java.awt.FileDialog FD = new java.awt.FileDialog(this.parent_frame,
                "Where the dictionary at?");
        FD.setVisible(true);
        // BUGBUG -- handle a null return, which happens if they hit "Cancel"
        this.dict_full_name = FD.getDirectory() + "/" + FD.getFile();
    }
}
