# OpenThesaurus

OpenThesaurus (www.openthesaurus.de), a web-based thesaurus management tool

Copyright (C) 2009 vionto GmbH, Berlin  
Copyright (C) 2011-2025 Daniel Naber, www.danielnaber.de

OpenThesaurus is a web-based tool for the development and maintenance of
thesauri and ontologies. It requires a Java application server or
servlet container (e.g. [Apache Tomcat](http://tomcat.apache.org)) and is
typically used with MySQL as a stand-alone database (other databases may
work but have not been tested).

See https://github.com/OpenTaal/opentaal-openthesaurus/blob/master/README.md
for more detailed installation instructions.

## Building

If you want to build OpenThesaurus on your own you will need
[Grails](http://www.grails.org) 3.3.1.

For development, your database needs to be configured in
`grails-app/conf/application.yml`. Use `grails run-app`
to directly start the web-application in development mode. It is
then available at `http://localhost:8080/`.

Use `grails war` to build a web application which can be deployed to a Java
servlet container like Tomcat.

## Setup for users who install the `.war` file

**Note: this section hasn't been updated for some time, we suggest building as documented above**

The `openthesaurus.war` file needs to be deployed to your servlet container.
Please refer to the container's documentation on how to do that.

1. Copy your JDBC database connector `*.jar` file to the `WEB-INF/lib` directory.
   If you use MySQL, you can get the database connector at
   https://dev.mysql.com/downloads/connector/j/

2. Configure your database access in `WEB-INF/classes/datasource.properties`.  
   A typical MySQL-based configuration for `datasource.properties` looks like this:

         dataSource.url=jdbc:mysql://127.0.0.1:3306/openthesaurus?useUnicode=true&characterEncoding=utf-8
         dataSource.driverClassName=com.mysql.jdbc.Driver
         dataSource.username=dbuser
         dataSource.password=xyz
         dataSource.dbCreate=update

   With these settings, the database `openthesaurus` needs to be created first manually
   using the database's tools. The tables will be automatically created by OpenThesaurus
   on its first startup.

3. For now, an in-memory database needs to be set up and updated regularly by
   accessing the page `synset/createMemoryDatabase` before OpenThesaurus can be used.
   This can be done by calling a command like this:

        curl -I http://localhost:8080/openthesaurus/synset/createMemoryDatabase

   Since the size of in-memory tables is 16M by default, after a while the above operation
   might start to fail (you will get `500 Internal Server Error` as response at the above URL 
   and you will see `memWordsTmp is full` in your server logs. In this case what you need to
   do is increase max_heap_table_size in MySQL. You can use `SHOW VARIABLES` to see the current
   value of this variable in your installation.

4. Set the values in `WEB-INF/classes/openthesaurus.properties`

5. For bigger data sets it might be necessary to create indexes manually in
   your database:
   
        ALTER TABLE `term` ADD INDEX ( `word` ) 
        ALTER TABLE `term` ADD INDEX ( `normalized_word` ) 
        ALTER TABLE `synset` ADD INDEX ( `is_visible` ) 

6. In case you run into problems with searching for special characters, it might be
   required to modify all tables whose collation is `latin1_swedish_ci` to
   `utf8_general_ci`, like this:
   
        ALTER TABLE `term` CHANGE `word` `word` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
        ALTER TABLE `term` CHANGE `normalized_word` `normalized_word` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
        ALTER TABLE `term` CHANGE `user_comment` `user_comment` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
        ALTER TABLE `wikipedia_links` CHANGE `link` `link` VARCHAR( 100 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
        ALTER TABLE `wikipedia_pages` CHANGE `title` `title` VARCHAR( 100 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;  
        ALTER TABLE `wiktionary` CHANGE `headword` `headword` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
           CHANGE `meanings` `meanings` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
           CHANGE `synonyms` `synonyms` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
        ALTER TABLE `user_event` CHANGE `old_value` `old_value` LONGTEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
        ALTER TABLE `user_event` CHANGE `new_value` `new_value` LONGTEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
        ALTER TABLE `user_event` CHANGE `class` `class` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
        ALTER TABLE `user_event` CHANGE `change_desc` `change_desc` LONGTEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
        ALTER TABLE `user_event` CHANGE `ip_address` `ip_address` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
        ALTER TABLE `user_event` CHANGE `word` `word` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;    

7. The default administration account is `admin` with the password `admin` - make
   sure this is changed after your first login. If you are logged in as admin, the
   OpenThesaurus homepage will show a link to the administration page.


## Data Import

Data from the old PHP-based version of OpenThesaurus can be imported by
calling `http://localhost:8080/openthesaurus/import/index`. Please check
the result carefully as it has only been tested with the German data
so far.

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
