#!/bin/sh
# dnaber, 2012-09-24
# trigger creation of memory db for substring and similarity search

curl -I http://localhost:8080/openthesaurus/synset/createMemoryDatabase
