OpenThesaurus database structure
Daniel Naber, 2010-11-13

This is a short description of the OpenThesaurus database structure. The most
important thing to understand is that the data is organized as concepts. Like
WordNet, a concept is a set of words and it's called 'synset' (synonym set).

Example query to find all synonyms for "Bank":

SELECT * FROM term, synset, term term2 WHERE synset.is_visible = 1 AND synset.id
   = term.synset_id AND term2.synset_id = synset.id AND term2.word = 'Bank'

Those terms that share the same value in synset_id belong to the same synset.

Description of the important tables:

synset: each concept listed in the thesaurus has a row in this table. Note that
  concepts never get deleted but their is_visible column is set to 0 instead.

synset_link: connections between synsets (e.g. hypernym/hyponym). Also see link_type.

term: a word belonging to a synset. Words with more than one meaning thus have
  as many entries in this table as they have meanings. Words are not deleted in
  this table, so always do a JOIN with the synset table to check the is_visible
  column.

term_level: a term can optionally have a level like 'colloquial', 'vulgar' etc.

term_link: similar to synset_link, but represents a connection between terms
   of different synsets. Use term_link_type to find which kind of relation is
   described.

category: each synset can be in any number of categories. Use category_link for
  connecting 'synset' and 'category' tables.
