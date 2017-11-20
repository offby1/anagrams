import java.io.File

val HAS_A_VOWEL = Regex("""[aeiouy]""")
val LONG_ENOUGH = Regex("""^i$|^a$|^..""")
val NON_LETTER = Regex("""[^a-zA-Z]""")

fun word_acceptable(w: String): Boolean {
    return HAS_A_VOWEL.find(w) != null && LONG_ENOUGH.find(w) != null && NON_LETTER.find(w) == null
}

data class BagEntry(val bag: Bag, val words: List<String>)

fun read_dict(fileName: String): List<BagEntry> {
	val hash = HashMap<Bag, MutableSet<String>>()
	File(fileName).forEachLine { // Probably not optimized
		val w = it.toLowerCase()
		if (word_acceptable(w)) {
			val bag = Bag(w)
			var existing = hash[bag]
			if (existing != null) {
				existing.add(w)
			} else {
				existing = mutableSetOf(w)
				hash[bag] = existing
			}
		}
	}
	val rv = mutableListOf<BagEntry>()
	hash.forEach { rv.add(BagEntry(it.key, it.value.toList())) }
	return rv
}