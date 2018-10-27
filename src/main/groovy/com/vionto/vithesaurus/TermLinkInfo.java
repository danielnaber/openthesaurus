/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2011 Daniel Naber (www.danielnaber.de)
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
package com.vionto.vithesaurus;

/**
 * A link between two terms. Like TermLink but used to have one common type for links
 * in both directions so users only need to iterate over a list of TermLinkInfos.
 */
public class TermLinkInfo implements Comparable<TermLinkInfo> {

    private final long id;
    private final Term term1;
    private final Term term2;
    private final String linkName;
    private final boolean outgoingLink;

    public TermLinkInfo(long id, Term term1, Term term2, String linkName, boolean outgoingLink) {
        this.id = id;
        this.term1 = term1;
        this.term2 = term2;
        this.linkName = linkName;
        this.outgoingLink = outgoingLink;
    }

    public long getId() {
        return id;
    }

    public Term getTerm1() {
        return term1;
    }

    public Term getTerm2() {
        return term2;
    }

    public String getLinkName() {
        return linkName;
    }

    public boolean isOutgoingLink() {
        return outgoingLink;
    }

    @Override
    public String toString() {
        return term1 + "<--" + linkName +"-->" + term2;
    }

    // just get some stable sort order
    @Override
    public int compareTo(TermLinkInfo o) {
        if (o.id < id) {
            return 1;
        } else if (o.id > id) {
            return -1;
        } else {
            return 0;
        }
    }
}
