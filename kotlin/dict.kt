val HAS_A_VOWEL = Regex("""[aeiouy]""")
val LONG_ENOUGH = Regex("""^i$|^a$|^..""")
val NON_LETTER = Regex("""[^a-zA-Z]""")

fun word_acceptable(w: String): Boolean {
    return HAS_A_VOWEL.find(w) != null && LONG_ENOUGH.find(w) != null && NON_LETTER.find(w) == null
}

