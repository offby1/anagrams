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
    private static java.math.BigInteger primes[] = {new java.math.BigInteger("2"),
    new java.math.BigInteger("3"),
    new java.math.BigInteger("5"),
    new java.math.BigInteger("7"),
    new java.math.BigInteger("11"),
    new java.math.BigInteger("13"),
    new java.math.BigInteger("17"),
    new java.math.BigInteger("19"),
    new java.math.BigInteger("23"),
    new java.math.BigInteger("29"),
    new java.math.BigInteger("31"),
    new java.math.BigInteger("37"),
    new java.math.BigInteger("41"),
    new java.math.BigInteger("43"),
    new java.math.BigInteger("47"),
    new java.math.BigInteger("53"),
    new java.math.BigInteger("59"),
    new java.math.BigInteger("61"),
    new java.math.BigInteger("67"),
    new java.math.BigInteger("71"),
    new java.math.BigInteger("73"),
    new java.math.BigInteger("79"),
    new java.math.BigInteger("83"),
    new java.math.BigInteger("89"),
    new java.math.BigInteger("97"),
    new java.math.BigInteger("101")};
    private java.math.BigInteger guts;
    /** Creates a new instance of Bag */
    public Bag(String s) {
        s = s.toLowerCase();
        guts = java.math.BigInteger.ONE;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c >= 'a' && c <= 'z') {
                guts = guts.multiply(primes[c - 'a']);
            }
            
        }
    }
    
    public Boolean empty() {
        return guts == java.math.BigInteger.ONE;
    }
    
}
