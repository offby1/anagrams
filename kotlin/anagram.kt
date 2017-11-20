import java.io.File

fun prune(input_bag: Bag, dict: List<BagEntry>): List<BagEntry> {
	return dict.filter {input_bag - it.bag != null}
}

fun combine(words: List<String>, anagrams: List<List<String>>): List<List<String>> {
	val rv = mutableListOf<List<String>>()
	for (w: String in words) {
		for (a: List<String> in anagrams) {
			val combined = mutableListOf(w)
			combined.addAll(a)
			rv.add(combined)
		}
	}
	return rv
}

fun anagrams(input_bag: Bag, dict: List<BagEntry>): List<List<String>> {
	val rv = mutableListOf<List<String>>()
	val pruned_dict = prune(input_bag, dict)

	for (entry: BagEntry in pruned_dict) {
		val smaller_bag = input_bag - entry.bag
		
		if (smaller_bag != null) {
			if (smaller_bag.empty()) {
				for (w: String in entry.words) {
					rv.add(listOf(w))
				}
			} else {
				val from_smaller_bag = anagrams(smaller_bag, pruned_dict)
				if (from_smaller_bag.size > 0) {
					rv.addAll(combine(entry.words, from_smaller_bag))
				}
			}
		}
	}
	return rv
}

fun main(args: Array<String>) {
	val input_phrase = args.joinToString(separator=" ")
	val input_bag = Bag(input_phrase)

	val dict = prune(input_bag, read_dict("../words.utf8"))
	
	val results = anagrams(input_bag, dict)
	val result_file = File(input_phrase).printWriter()
	results.forEach { result_file.println(it.joinToString(separator=" ")) }
	result_file.close()
}
