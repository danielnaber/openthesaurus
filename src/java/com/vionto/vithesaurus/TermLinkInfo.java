package com.vionto.vithesaurus;

/**
 * A link between two terms. Like TermLink but used to have one common type for links
 * in both directions so users only need to iterate over a list of TermLinkInfos.
 */
public class TermLinkInfo {

    private final Term term1;
    private final Term term2;
    private final String linkName;
    private final boolean outgoingLink;

    public TermLinkInfo(Term term1, Term term2, String linkName, boolean outgoingLink) {
        this.term1 = term1;
        this.term2 = term2;
        this.linkName = linkName;
        this.outgoingLink = outgoingLink;
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

}
