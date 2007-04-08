import java.util.List;
import javax.swing.JOptionPane;
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
    @Override
    public String doInBackground() {
        JOptionPane.showMessageDialog(null, "Here I go, anagramming something");
        return null;
    }
    @Override
    protected void done() {
        JOptionPane.showMessageDialog(null, "I guess I'm done");
    }
    
    /** Creates a new instance of AnagrammerWorker */
    public AnagrammerWorker() {
    }
    
}
