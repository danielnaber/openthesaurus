package vithesaurus

/**
 * Get word lists from remote server.
 * This is specific to openthesaurus.de, for linking korrekturen.de.
 */
class WordListService {

  static transactional = false

  Map<String,String> wordToUrl = null

  def remoteGenderUrl(String word) {
    if (wordToUrl) {
      def url = wordToUrl.get(word.trim().toLowerCase())
      if (url) {
        log.info("Linking korrekturen.de for gender tips for '${word.trim()}'")
        return url
      }
    }
    return null
  }

  // TODO: more lists...

  def refreshGenderList() {
    def url = "http://www.korrekturen.de/data/lemmata/genus.txt"
    log.info("Refreshing gender list from ${url}")
    Map<String,String> wordMap = new HashMap<String,String>()
    String text = new URL(url).getText("utf-8")
    Scanner scanner = new Scanner(text)
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine()
      String[] parts = line.split("\\|")
      if (parts.length != 2) {
        log.warn("Unexpected line format: " + line)
        continue
      }
      String[] wordParts = parts[0].split("[;/]")
      for (String part : wordParts) {
        wordMap.put(part.trim().toLowerCase(), parts[1])
      }
    }
    wordToUrl = wordMap
    List someItems = getSomeKeys(wordToUrl)
    log.info("Done refreshing gender list - list now contains ${wordToUrl.size()} items - ${someItems}...")
  }

  private List getSomeKeys(Map<String,String> wordMap) {
    List firstItems = []
    for (String item in wordMap.keySet()) {
      firstItems.add(item)
      if (firstItems.size() > 4) {
        break
      }
    }
    return firstItems
  }

}
