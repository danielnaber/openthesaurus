package vithesaurus

/**
 * Get word lists from remote server.
 * This is specific to openthesaurus.de, for linking korrekturen.de.
 */
class WordListService {

  static transactional = false

  Set<String> genderWords = null

  def isWordInGenderList(String word) {
    if (genderWords) {
      return genderWords.contains(word.trim().toLowerCase())
    }
    return false
  }

  // TODO: more lists...

  def refreshGenderList() {
    def url = "http://www.korrekturen.de/data/lemmata/genus.txt"
    log.info("Refreshing gender list from ${url}")
    Set<String> words = new HashSet<String>()
    String text = new URL(url).getText("utf-8")
    Scanner scanner = new Scanner(text)
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine()
      String[] parts = line.split("[;/]")
      for (String part : parts) {
        words.add(part.trim().toLowerCase())
      }
    }
    if (genderWords == null) {
      genderWords = new HashSet<String>()
    } else {
      genderWords.clear()
    }
    genderWords.addAll(words)
    List firstItems = []
    for (String item in genderWords) {
      firstItems.add(item)
      if (firstItems.size() > 4) {
        break
      }
    }
    log.info("Done refreshing gender list - list now contains ${genderWords.size()} items - ${firstItems}...")
  }

}
