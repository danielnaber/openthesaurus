/**
 * vithesaurus - web-based thesaurus management tool
 * Copyright (C) 2009 vionto GmbH, www.vionto.com
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

import com.vionto.vithesaurus.*

/**
 * Displays a synset hierarchie for nouns and verbs which can be expanded.
 */
class TreeController extends BaseController {

    def index = {
        Synset topNounSynset = Synset.get(grailsApplication.config.thesaurus.tree.topSynsetId.noun)
        Synset topVerbSynset = Synset.get(grailsApplication.config.thesaurus.tree.topSynsetId.verb)
        
        List synsetIdsToOpen = []
        Synset synsetToOpen
        if (params.id) {
          synsetToOpen = Synset.get(params.id) 
          getSuperordinateSynsetIds(synsetToOpen, synsetIdsToOpen)
        }
        
        StringBuilder nounTree = new StringBuilder()
        getSubordinateSynsetsHtml(topNounSynset, synsetIdsToOpen, nounTree)

        StringBuilder verbTree = new StringBuilder()
        getSubordinateSynsetsHtml(topVerbSynset, synsetIdsToOpen, verbTree)

        [topNounSynset: topNounSynset, nounTree: nounTree,
         topVerbSynset: topVerbSynset, verbTree: verbTree,
         synsetToOpen: synsetToOpen]
    }

 	private void getSuperordinateSynsetIds(Synset synset, List topSynsetIds) {
        for (link in synset.synsetLinks) {
          if (link.linkType.linkName == grailsApplication.config.thesaurus.tree.superordinateName) {
            topSynsetIds.add(link.targetSynset.id)
            getSuperordinateSynsetIds(link.targetSynset, topSynsetIds)
            break
          }
        }
 	}

   	private List getSubordinateSynsetIds(Synset synset) {
        def subSynsets = Synset.withCriteria {
          synsetLinks {
            linkType {
              eq('linkName', grailsApplication.config.thesaurus.tree.superordinateName)
            }
            eq('targetSynset', synset)
          }
        }
        return subSynsets
   	}
   	
    private void getSubordinateSynsetsHtml(Synset synset, List synsetIdsToOpen, StringBuilder sb) {
      List subSynsets = getSubordinateSynsetIds(synset)
      for (subSynset in subSynsets) {
        if (!subSynset.isVisible) {
          continue
        }
        if (synsetIdsToOpen.contains(subSynset.id) || subSynset.id + "" == params.id) {
          StringBuilder subContent = new StringBuilder()
          subContent.append("<li>\n")
          if (subSynset.id + "" == params.id) {
            subContent.append("<a name='target'></a>")
          }
          subContent.append("<tt><a href=\"${createLink(controller:'tree', id:synset.id)}#target\">[-]</a></tt> ")
          subContent.append("<a href=\"${createLink(controller:'synset', action:'edit', id:subSynset.id)}\"><b>" 
              + subSynset.toShortString() + "</b></a>\n")
          subContent.append("<ul class='tree'>\n")
          getSubordinateSynsetsHtml(subSynset, synsetIdsToOpen, subContent)
          subContent.append("</ul>\n")
          subContent.append("</li>\n")
          sb.append(subContent.toString())
        } else {
          List tmpSubSynsets = getSubordinateSynsetIds(subSynset)
          sb.append("<li>")
          if (tmpSubSynsets.size() == 0) {
            sb.append("<tt>[ ]</tt> ")
          } else {
            sb.append("<tt><a href=\"${createLink(controller:'tree', id:subSynset.id)}#target\">[+]</a></tt> ")
          }
          sb.append("<a href=\"${createLink(controller:'synset', action:'edit', id:subSynset.id)}\">"
              + subSynset.toShortString() + "</a>")
          sb.append("</li>\n")
        }
      }
    }

}
