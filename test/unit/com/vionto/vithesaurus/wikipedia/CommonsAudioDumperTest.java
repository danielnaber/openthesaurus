/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2015 Daniel Naber (www.danielnaber.de)
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
package com.vionto.vithesaurus.wikipedia;

import org.junit.Test;

import static org.hamcrest.CoreMatchers.is;
import static org.springframework.test.util.MatcherAssertionErrors.assertThat;

public class CommonsAudioDumperTest {
  
  @Test
  public void testLicense() {
    assertLicense("|Permission={{Cc-by-2.0-de}}", "https://creativecommons.org/licenses/by/2.0/de/deed.en");
    assertLicense("|Permission={{Cc-by-2.0-de|a name}}", "https://creativecommons.org/licenses/by/2.0/de/deed.en", "a name");
    assertLicense("|Permission={{Cc-by-2.5-de|a name}}", "https://creativecommons.org/licenses/by/2.5/de/deed.en", "a name");
    assertLicense("|Permission={{Cc-by-3.0-de}}", "https://creativecommons.org/licenses/by/3.0/de/deed.en");
    assertLicense("|Permission={{Cc-by-3.0-de|a name}}", "https://creativecommons.org/licenses/by/3.0/de/deed.en", "a name");
    assertLicense("|Permission={{Cc-by-3.0}}", "https://creativecommons.org/licenses/by/3.0/deed.en");
    assertLicense("|Permission={{Cc-by-3.0|a name}}", "https://creativecommons.org/licenses/by/3.0/deed.en", "a name");
    assertLicense("|Permission={{Cc-by-sa-3.0}}", "https://creativecommons.org/licenses/by-sa/3.0/deed.en");
    assertLicense("|Permission={{Cc-by-sa-3.0|a name}}", "https://creativecommons.org/licenses/by-sa/3.0/deed.en", "a name");
    assertLicense("{{self|Cc-by-sa-3.0}}", "https://creativecommons.org/licenses/by-sa/3.0/deed.en");
    assertLicense("{{Cc-by-sa-3.0}}", "https://creativecommons.org/licenses/by-sa/3.0/deed.en");
    assertLicense("{{Cc-by-sa-3.0|a name}}", "https://creativecommons.org/licenses/by-sa/3.0/deed.en", "a name");
    assertLicense("migration=relicense", "https://creativecommons.org/licenses/by-sa/3.0/deed.en");
    assertLicense("Cc-by-sa-3.0-migrated", "https://creativecommons.org/licenses/by-sa/3.0/deed.en");
    assertLicense("Cc-zero", "https://creativecommons.org/publicdomain/zero/1.0/deed.en");
    assertLicense("{{PD-self}}", "https://en.wikipedia.org/wiki/Public_domain");
    assertLicense("{{self|Cc-zero}}", "https://en.wikipedia.org/wiki/Public_domain");
    //assertLicense("", "");
  }

  private void assertLicense(String input, String expectedUrl) {
    assertLicense(input, expectedUrl, null);
  }

  private void assertLicense(String input, String expectedUrl, String expectedAttribution) {
    CommonsAudioDumper audioDumper = new CommonsAudioDumper();
    assertThat(audioDumper.getLicenseOrNull("x", input).getUrl(), is(expectedUrl));
    assertThat(audioDumper.getLicenseOrNull("x", input).getAttribution(), is(expectedAttribution));
  }

}
