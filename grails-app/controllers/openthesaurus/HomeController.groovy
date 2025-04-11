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

package openthesaurus

import java.nio.file.Files
import java.util.stream.Collectors

class HomeController {

    def index() {
        [withAd: true]
    }

    def index2() {}

    /*def adstxt() {
        def resource = this.class.classLoader.getResource('ads.txt')
        def lines = Files.lines(new File(resource.file).toPath()).collect(Collectors.toList())
        render(text: String.join("\n", lines), contentType: "text/plain", encoding: "UTF-8")
    }*/

    def google() {
        def resource = this.class.classLoader.getResource('googleTODO.html')
        def lines = Files.lines(new File(resource.file).toPath()).collect(Collectors.toList())
        render(text: String.join("\n", lines), contentType: "text/html", encoding: "UTF-8")
    }
}
