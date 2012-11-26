package vithesaurus

/**
 * Get word lists from remote server.
 * This is specific to openthesaurus.de, for linking korrekturen.de.
 */
class WordListService {

  static transactional = false

  Map<String,String> wordToUrl = null
  Map<String,String> wordToGenderUrl = null

  def remoteWordUrl(String word) {
    return getUrlFromMapOrNull(word, wordToUrl)
  }

  def remoteGenderUrl(String word) {
    return getUrlFromMapOrNull(word, wordToGenderUrl)
  }

  def getUrlFromMapOrNull(String word, Map map) {
    if (map) {
      def url = map.get(word.trim().toLowerCase())
      if (url) {
        log.info("Linking korrekturen.de for '${word.trim()}': ${url}")
        return url
      }
    }
    return null
  }

  def refreshWordList() {
    wordToUrl = loadListFromUrl("http://www.korrekturen.de/data/lemmata/wortliste.txt")
    log.info("Done refreshing word list - list now contains ${wordToUrl.size()} items - ${getSomeKeys(wordToUrl)}...")
  }

  def refreshGenderList() {
    wordToGenderUrl = loadListFromUrl("http://www.korrekturen.de/data/lemmata/genus.txt")
    log.info("Done refreshing gender list - list now contains ${wordToGenderUrl.size()} items - ${getSomeKeys(wordToGenderUrl)}...")
  }

  def loadListFromUrl(String url) {
    log.info("Refreshing gender list from ${url}")
    Map<String,String> wordMap = new HashMap<String,String>()
    String text = new URL(url).getText("utf-8")
    Scanner scanner = new Scanner(text)
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine()
      line = line.replaceAll("<i>.*?</i>", "")
      line = line.replaceAll("<em>.*?</em>", "")
      line = line.replaceAll("<br/>", "")
      line = line.replaceAll("<br />", "")
      line = line.replaceAll("<nobr>.*?</nobr>", "")
      line = line.replaceAll("&thinsp;", " ")
      line = line.replaceAll("\\(.*?\\)", " ")
      String[] parts = line.split("\\|")
      if (parts.length != 2) {
        log.warn("Unexpected line format: " + line)
        continue
      }
      String[] wordParts = parts[0].split("[,;/]")
      for (String part : wordParts) {
        part = part.trim().toLowerCase()
        if (part.length() > 0) {
          wordMap.put(part, parts[1])
        }
      }
    }
    return wordMap
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
