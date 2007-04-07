/*
 * Bag.java
 *
 * Created on April 7, 2007, 12:00 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

/**
 *
 * @author Eric
 */
public class Bag {
    private String guts;
    /** Creates a new instance of Bag */
    public Bag(String s) {
        guts = s;
    }
    
    public Boolean empty() {
        return guts.length() == 0;
    }
    
}
