package openthesaurus

import com.vionto.vithesaurus.WordListLookup

/**
 * Get word lists from remote server.
 * This is specific to openthesaurus.de, for linking korrekturen.de.
 */
class WordListService {

  static transactional = false

  Map<String,WordListLookup> wordToLookup = null
  Map<String,WordListLookup> wordToGenderLookup = null
  Map<String,WordListLookup> wordToMistakeLookup = null

  WordListLookup remoteWordUrlAndMetaInfo(String word) {
    return getUrlFromMapOrNull(word, wordToLookup)
  }

  WordListLookup remoteGenderUrlAndMetaInfo(String word) {
    return getUrlFromMapOrNull(word, wordToGenderLookup)
  }

  WordListLookup remoteCommonMistakeUrlAndMetaInfo(String word) {
    return getUrlFromMapOrNull(word, wordToMistakeLookup)
  }

  WordListLookup getUrlFromMapOrNull(String word, Map<String,WordListLookup> map) {
    if (map) {
      WordListLookup lookup = map.get(word.trim().toLowerCase())
      if (lookup) {
        log.info("Linking korrekturen.de for '${word.trim()}': ${lookup.url}")
        return lookup
      }
    }
    return null
  }

  def refreshWordList() {
    wordToLookup = loadListFromUrl("https://www.korrekturen.de/data/lemmata/wortliste.txt", false)
    log.info("Done refreshing word list - list now contains ${wordToLookup.size()} items - ${getSomeKeys(wordToLookup)}...")
  }

  def refreshGenderList() {
    wordToGenderLookup = loadListFromUrl("https://www.korrekturen.de/data/lemmata/genus.txt", false)
    log.info("Done refreshing gender list - list now contains ${wordToGenderLookup.size()} items - ${getSomeKeys(wordToGenderLookup)}...")
  }

  def refreshCommonMistakesList() {
    wordToMistakeLookup = loadListFromUrl("https://www.korrekturen.de/data/lemmata/fehler.txt", true)
    log.info("Done refreshing common mistakes list - list now contains ${wordToMistakeLookup.size()} items - ${getSomeKeys(wordToMistakeLookup)}...")
  }

  def loadListFromUrl(String url, boolean storeMetaAsLookup) {
    log.info("Refreshing list from ${url}")
    Map<String,WordListLookup> wordMap = new HashMap<String,WordListLookup>()
    String text = new URL(url).getText("utf-8")
    Scanner scanner = new Scanner(text)
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine()
      line = line.replaceAll("<i>", "__i__")  // keep italics
      line = line.replaceAll("</i>", "__/i__")
      line = line.replaceAll("<em>.*?</em>", "")
      line = line.replaceAll("<br/>", "")
      line = line.replaceAll("<br />", "")
      line = line.replaceAll("<nobr>.*?</nobr>", "")
      line = line.replaceAll("&thinsp;", " ")
      line = line.replaceAll("\\(.*?\\)", " ")
      line = line.replaceAll("__i__", "<i>")
      line = line.replaceAll("__/i__", "</i>")
      String[] parts = line.split("\\|")
      if (parts.length != 2 && parts.length != 3) {
        log.warn("Unexpected line format: " + line)
        continue
      }
      String term = parts[0]
      String metaInfo = null
      String targetUrl = null
      if (parts.length == 2) {
        targetUrl = parts[1]
      } else if (parts.length == 3) {
        metaInfo = parts[1]
        targetUrl = parts[2]
      }
      partsToMap(parts[0].split("[,;/]"), targetUrl, wordMap, term, metaInfo)
      if (storeMetaAsLookup) {
        partsToMap(parts[1].split("[,;/]"), targetUrl, wordMap, term, metaInfo)
      }
    }
    return wordMap
  }

  private void partsToMap(String[] wordParts, String targetUrl, HashMap<String, WordListLookup> wordMap, String term, String metaInfo) {
    String saneTargetUrl = sanityCheckUrl(targetUrl)
    for (String part : wordParts) {
      part = part.trim().toLowerCase()
      if (part.length() > 0) {
        wordMap.put(part, new WordListLookup(term, saneTargetUrl, metaInfo))
      }
    }
  }

  String sanityCheckUrl(String url) {
    if (url.length() < 250 && (url.trim().startsWith("http://www.korrekturen.de") || url.trim().startsWith("http://korrekturen.de") ||
            url.trim().startsWith("https://www.korrekturen.de") || url.trim().startsWith("https://korrekturen.de"))) {
      return url
    }
    throw new Exception("Unexpected URL or URL length: ${url}")
  }

  private List getSomeKeys(Map<String,WordListLookup> wordMap) {
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
