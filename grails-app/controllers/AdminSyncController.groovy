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
        File f = new File("/tmp/formulierung-mit-stil.de/tabkeywords.txt")
        int headWordUnknown = 0  // a headword from the dictionary is not known at all
        int synWordUnknown = 0   // a synonym from the dictionary is not known at all
        int synUnknown = 0       // an entry has a synonym that's not known as a synonym in OT
        Scanner sc = new Scanner(f)
        boolean stop = false
        int lineCount = 0
        int from = params.from ? Integer.parseInt(params.from) : 0
        int pageSize = 100
        while (sc.hasNextLine()) {
            String line = sc.nextLine()
            if (line.startsWith("#")) {
                continue
            }
            //String[] parts = line.split("=>")
            String[] parts = line.split(": ")
            if (parts.length > 2) {
                parts[1] = parts[1..parts.length-1].join(": ")
                print "joined: " + parts[0] + " -> " + parts[1]
            } else if (parts.length != 2) {
                render "skipping: " + line + "<br>"
                continue
            }
            lineCount++
            if (lineCount < from) {
                continue
            }
            if (lineCount > from + pageSize) {
                continue
            }
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
            for (String syn : synonyms) {
                if (syn.trim().isEmpty()) {
                    continue
                }
                syn = syn.trim().replaceAll("\u202F", "")
                String origSyn = syn
                syn = syn.replace("sich ", "(sich) ")
                syn = syn.replace("jmd. ", "")
                syn = syn.replace("etw. ", "")
                syn = syn.replaceAll("^ein ", "")
                syn = syn.replaceAll("^eine ", "")
                syn = syn.trim()
                List otResult = getMatches(syn)
                if (otResult.size() == 0) {
                    //render "Synonym word unknown: '" + syn + "' (" + line + ")<br>"
                    //render "Synonym word unknown: " + syn + " - " + parts[1] + "<br>"
                    String encQuery = URLEncoder.encode(syn, "utf-8")
                    render lineCount + ". <a target='ot' href='https://www.openthesaurus.de/synonyme/" + URLEncoder.encode(parts[0], "utf-8") + "'>" + parts[0] + "</a>" +
                            " - <a target='ot' href='https://www.openthesaurus.de/synonyme/" + 
                            encQuery + "'>" + origSyn + "</a>" +
                            " (<a href='http://www.google.de/search?hl=de&source=hp&biw=&bih=&q=%22" + encQuery + "%22&btnG=Google-Suche&gbv=1'>G</a>)<br>"
                    /*for (def c in syn) {
                        render "*" + ((int)c)
                    }
                    render "<br>"
                    */
                    synWordUnknown++
                    if (synWordUnknown > 100) {
                        stop = true
                    }
                } else if (headWordFound) {  // if the headword isn't even found we don't need to count more detailed
                    //TODO: buggy, need to work on synsets
                    /*boolean synFound = false
                    for (Term t : otResult) {
                        if (syn == t.word) {
                            render "X: " + syn + " == " + t.word + "<br>"
                            synFound = true
                            break
                        }
                    }
                    render "debug: " + headWord + " ~ " + syn + ": " + headWordFound + " - " + synFound + "<br>"
                    render "debug: " + otResult + "<br>"
                    if (!(headWordFound && synFound)) {
                        render "Synonym relation unknown: '" + headWord + "' ~ '" + syn + "'<br>"
                        synUnknown++
                    }*/
                }
            }
            if (stop) {
                render "STOPPING"
                break
            }             
        }
        render "---<br>"
        render "DONE:<br>"
        render "headWordUnknown: " + headWordUnknown + "<br>"
        render "synWordUnknown: " + synWordUnknown + "<br>"
        render "<a href='?from=" + (from+pageSize) + "'>next</a>"
        //render "synUnknown: " + synUnknown + "<br>"
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
