import com.vionto.vithesaurus.SynsetLink
import com.vionto.vithesaurus.LinkType

/**
 * vithesaurus - web-based thesaurus management tool
 * Copyright (C) 2011 Daniel Naber, www.danielnaber.de
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
class AssociationController extends BaseController {
    
    def list = {
        if(!params.offset) params.offset = 0
        else params.offset = Integer.parseInt(params.offset)
        LinkType associationType = LinkType.findByLinkName("Assoziation")
        def synsetCountResult = SynsetLink.withCriteria {
            eq('linkType', associationType)
            projections {
                countDistinct('synset')
            }
        }
        def synsetCount = synsetCountResult.get(0)
        def synsets = SynsetLink.withCriteria {
            eq('linkType', associationType)
            firstResult(params.offset)
            maxResults(10)
            projections {
                distinct('synset')
            }
        }
        [synsetCount: synsetCount, synsets: synsets, desiredLinkType: associationType]
    }
    
}
