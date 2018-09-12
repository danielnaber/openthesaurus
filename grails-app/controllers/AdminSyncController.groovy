/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2017 Daniel Naber (www.danielnaber.de)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import com.vionto.vithesaurus.Term
import com.vionto.vithesaurus.tools.StringTools
import grails.gorm.DetachedCriteria

/**
 * Helper to show admin page for comparing with words from other 
 * Open Source sites like formulierung-mit-stil.de.
 */
class AdminSyncController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]
    
    def index = {
        //File f = new File("/home/dnaber/thesaurus/abgleich/otus/otus_a_small.txt")
        //File f = new File("/home/dnaber/thesaurus/abgleich/otus/otus_a.txt")
        //File f = new File("/home/dnaber/thesaurus/abgleich/otus/otus_complete.txt")
        File f = new File("/home/dnaber/thesaurus/abgleich/otus/otus_complete.txt")
        int headWordUnknown = 0  // a headword from the dictionary is not known at all
        int synWordUnknown = 0   // a synonym from the dictionary is not known at all
        int synUnknown = 0       // an entry has a synonym that's not known as a synonym in OT
        Scanner sc = new Scanner(f)
        int lineCount = 0
        int displayCount = 0
        int from = params.from ? Integer.parseInt(params.from) : 0
        int pageSize = 100
        render "<ul>"
        while (sc.hasNextLine()) {
            String line = sc.nextLine()
            if (line.startsWith("#")) {
                continue
            }
            String[] parts = line.split("=>")
            //String[] parts = line.split(": ")
            if (parts.length > 2) {
                parts[1] = parts[1..parts.length-1].join(": ")
                print "joined: " + parts[0] + " -> " + parts[1]
            } else if (parts.length != 2) {
                //render "skipping: " + line + "<br>"
                continue
            }
            lineCount++
            String headWord = parts[0].trim()
            String[] synonyms = parts[1].trim().split(",\\s*|\\d\\.")
            headWord = headWord.replaceFirst("(.+), sich", "(sich) \$1")
            //render "---<br>"
            //render headWord + " -> " + synonyms + "<br>"

            List result = getMatches(headWord)
            boolean headWordFound = true
            if (result.size() == 0) {
                //render "Headword unknown: " + headWord + " (" + line + ")<br>"
                headWordUnknown++
                headWordFound = false
            }
            if (displayCount > from + pageSize) {
                print "limit reached at " + displayCount
                break
            }
            int synMatches = 0
            for (String syn : synonyms) {
                if (syn.trim().isEmpty()) {
                    continue
                }
                syn = syn.trim().replaceAll("\u00AD", "")
                syn = syn.trim().replaceAll("\u202F", "")
                syn = syn.replace("sich ", "(sich) ")
                syn = syn.replace(", sich", "(sich) ")
                syn = syn.replace("jmd. ", "")
                syn = syn.replace("etw. ", "")
                syn = syn.replaceAll("^ein ", "")
                syn = syn.replaceAll("^eine ", "")
                syn = syn.trim()
                List otResult = getMatches(syn)
                if (otResult.size() > 0) {
                    synMatches++
                } else {
                    print "lineCount " + lineCount + ", displayCount " + displayCount
                    if (displayCount < from) {
                        displayCount++
                        continue
                    }
                    String enc = URLEncoder.encode(syn, "utf-8")
                    String style = " style='color:lightblue' "
                    render "<li>" + displayCount + ". <a target='ot' href='https://www.openthesaurus.de/synonyme/" + URLEncoder.encode(syn, "utf-8") + "'>" +
                            syn + "</a> <a $style target='_blank' href='https://de.wiktionary.org/wiki/" + enc +"'>Wiktionary</a> " +
                            //"<a target='_blank' href='https://www.startpage.com/do/asearch?q=" + enc + "'>Google</a> " +
                            "<a $style target='_blank' href='http://www.google.de/search?hl=de&source=hp&biw=&bih=&q=\"" + enc + "\"'>Google</a> " +
                            line + "<br>\n"
                    displayCount++
                }
            }
            /*if (!headWordFound && synMatches == 0) {
                render displayCount + ". <a target='ot' href='https://www.openthesaurus.de/synonyme/" + URLEncoder.encode(parts[0].trim(), "utf-8") + "'>" +
                        parts[0].trim() + "</a>"
                for (String syn : synonyms) {
                    if (syn.trim().isEmpty()) {
                        continue
                    }
                    String encQuery = URLEncoder.encode(syn, "utf-8")
                    render " - <a target='ot' href='https://www.openthesaurus.de/synonyme/" + encQuery + "'>" + syn + "</a>"
                }
                render " - <br>"
                displayCount++
            }*/
        }
        render "</ul>"
        render "---<br>"
        render "<a href='?from=" + (from+pageSize) + "'>next</a>"
    }

    private List getMatches(String str) {
        def detached = new DetachedCriteria(Term)
        def c = detached.build {
            or {
                eq('word', str)
                eq('normalizedWord', StringTools.normalize(str))
                eq('normalizedWord2', StringTools.normalize2(str))
            }
            synset {
                eq('isVisible', true)
            }
            order('word', 'asc')
        }
        def result = c.list(offset: 0, max: 20)
        result
    }

}
