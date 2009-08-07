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
package com.vionto.vithesaurus;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import org.incava.util.diff.Difference;

import com.vionto.vithesaurus.tools.StringTools;

/**
 * Helper tool to build easily-readable diffs to be displayed as HTML.
 */
public class Diff {

    // The strings to be compared will be split by these chars
    // so that the comparison isn't just char-by-char:
    private static final String SPLIT_EXP = " =,";

    // this depends on the implementation of Synset.toString():
    private static final String NEW_SPLIT_EXP = "·|=";

    /** to used to mark start of "added content" sections: */
    private static final String ADD_START = "<span class='add'>";
    /** to used to mark end of "added content" sections: */
    private static final String ADD_END = "</span>";
    /** to used to mark start of "deleted content" sections: */
    private static final String DELETE_START = "<span class='del'>";
    /** to used to mark end of "deleted content" sections: */
    private static final String DELETE_END = "</span>";

    /**
     * Build a HTML-ready diff between two string where removed content is
     * marked with &lt;span class='del'&gt; and added content is marked with
     * &lt;span class='add'&gt;
     *
     * @author dan
     */
    public static String diff(String str1, String str2) {
        if (str1 == null) {
            str1 = "";
        }
        List<String> aList = split(StringTools.replaceHtmlMarkupChars(str1));
        List<String> bList = split(StringTools.replaceHtmlMarkupChars(str2));

        org.incava.util.diff.Diff d =
            new org.incava.util.diff.Diff(aList.toArray(), bList.toArray());
        List<Difference> diffs = d.diff();

        List<String> resultList = new ArrayList<String>(bList);

        for (int i = diffs.size() - 1; i >= 0; i--) {
            Difference diff = diffs.get(i);
            if (diff.getAddedEnd() != -1) {
                resultList.add(diff.getAddedEnd() + 1, ADD_END);
                resultList.add(diff.getAddedStart(), ADD_START);
            }
            if (diff.getDeletedEnd() != -1) {
                List<String> del = aList.subList(diff.getDeletedStart(),
                        diff.getDeletedEnd() + 1);
                resultList.add(diff.getAddedStart(), DELETE_END);
                for (int j = del.size()-1; j >= 0; j--) {
                    resultList.add(diff.getAddedStart(), del.get(j));
                }
                resultList.add(diff.getAddedStart(), DELETE_START);
            }
        }
        StringBuilder sb = new StringBuilder();
        for (String el : resultList) {
            sb.append(el);
        }
        return sb.toString();
    }

    private static List<String> split(String str) {
        StringTokenizer st;
        if (str.contains("|")) {
            st = new StringTokenizer(str, NEW_SPLIT_EXP, true);
        } else {
            st = new StringTokenizer(str, SPLIT_EXP, true);
        }
        List<String> list = new ArrayList<String>();
        while (st.hasMoreElements()) {
            list.add(st.nextToken());
        }
        return list;
    }

}
