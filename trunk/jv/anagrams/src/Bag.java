/*
 * Bag.java
 *
 * Created on April 7, 2007, 12:00 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

import java.math.BigInteger;
/**
 *
 * @author Eric
 */
public class Bag {
    // I know, I know.
    private static BigInteger primes[] = {new BigInteger("2"),
    new BigInteger("3"),
    new BigInteger("5"),
    new BigInteger("7"),
    new BigInteger("11"),
    new BigInteger("13"),
    new BigInteger("17"),
    new BigInteger("19"),
    new BigInteger("23"),
    new BigInteger("29"),
    new BigInteger("31"),
    new BigInteger("37"),
    new BigInteger("41"),
    new BigInteger("43"),
    new BigInteger("47"),
    new BigInteger("53"),
    new BigInteger("59"),
    new BigInteger("61"),
    new BigInteger("67"),
    new BigInteger("71"),
    new BigInteger("73"),
    new BigInteger("79"),
    new BigInteger("83"),
    new BigInteger("89"),
    new BigInteger("97"),
    new BigInteger("101")};

    private BigInteger guts;
    
    // strictly for debugging: the string which we were created from
    private String source;
    
    /** Creates a new instance of Bag */
    public Bag(BigInteger b) {
        guts = b;
    }
    
    public Bag(String s) {
        source = s;
        s = s.toLowerCase();
        guts = BigInteger.ONE;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c >= 'a' && c <= 'z') {
                guts = guts.multiply(primes[c - 'a']);
            }
        }
    }
    public BigInteger guts ()
    {
        return guts;
    }
    public int hashCode() {
        return guts.hashCode();
    }
    public Boolean empty() {
        return guts.equals(BigInteger.ONE);
    }
    
    public boolean equals(Object other){
        return guts.equals(((Bag)other).guts);
    }
    
    public Bag subtract(Bag other){
        BigInteger rem = guts.remainder(other.guts);
        if (!BigInteger.ZERO.equals(rem))
            return null;
        BigInteger quo = guts.divide(other.guts);
        return new Bag(quo);
    }
    
    
}
