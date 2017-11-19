import java.math.BigInteger

class Bag(var num: BigInteger) {
    companion object {
        private val _primes = arrayOf(
            BigInteger("2"),
            BigInteger("3"),
            BigInteger("5"),
            BigInteger("7"),
            BigInteger("11"),
            BigInteger("13"),
            BigInteger("17"),
            BigInteger("19"),
            BigInteger("23"),
            BigInteger("29"),
            BigInteger("31"),
            BigInteger("37"),
            BigInteger("41"),
            BigInteger("43"),
            BigInteger("47"),
            BigInteger("53"),
            BigInteger("59"),
            BigInteger("61"),
            BigInteger("67"),
            BigInteger("71"),
            BigInteger("73"),
            BigInteger("79"),
            BigInteger("83"),
            BigInteger("89"),
            BigInteger("97"),
            BigInteger("101")
        )
    }

    constructor(s: String) : this(BigInteger.ONE) {
        for (c in s.toLowerCase()) {
            if (c >= 'a' && c <= 'z') {
                num = num.multiply(_primes[c - 'a'])
            }
        }
    }

    fun empty(): Boolean {
        return num == BigInteger.ONE
    }

    fun equals(other: Any): Boolean {
        return num == (other as Bag).num;
    }

    override fun hashCode(): Int {
        return num.hashCode()
    }

    operator fun minus(other: Bag): Bag? {
        if (num % other.num != BigInteger.ZERO) return null
        return Bag(num / other.num)
    }
}
