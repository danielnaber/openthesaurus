/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2010 Daniel Naber (www.danielnaber.de)
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

import de.abelssoft.wordtools.jWordSplitter.AbstractWordSplitter;
import de.abelssoft.wordtools.jWordSplitter.impl.GermanWordSplitter;
import org.apache.commons.lang.StringUtils;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Finds a German word's baseform. Also supports compounds words. 
 */
public class BaseformFinder {

    private final AbstractWordSplitter splitter;

    public BaseformFinder() throws IOException {
        this.splitter = new GermanWordSplitter(false);
        this.splitter.setStrictMode(true);
    }

    public Set<String> getBaseForms(Connection connection, String term) throws SQLException {
        final List<String> parts = new ArrayList<String>(splitter.splitWord(term));
        final String searchTerm;
        if (parts.size() > 0) {
            searchTerm = parts.get(parts.size() - 1);
        } else {
            searchTerm = term;
        }
        final Set<String> baseForms = new HashSet<String>();
        final String sql = "SELECT baseform FROM word_mapping WHERE fullform = ?";
        final PreparedStatement statement = connection.prepareStatement(sql);
        try {
            statement.setString(1, searchTerm);
            final ResultSet resultSet = statement.executeQuery();
            try {
                while (resultSet.next()) {
                    final String baseform;
                    if (parts.size() > 1) {
                        baseform = joinAllButLast(parts, resultSet.getString("baseform"));
                    } else {
                        baseform = resultSet.getString("baseform");
                    }
                    baseForms.add(baseform);
                }
            } finally {
                resultSet.close();
            }
        } finally {
            statement.close();
        }
        return baseForms;
    }

    private String joinAllButLast(List<String> parts, String lastPartBaseForm) {
        final StringBuilder sb = new StringBuilder();
        for (int i = 0; i < parts.size() - 1; i++) {
            final String part = parts.get(i);
            if (i == 0) {
                sb.append(StringUtils.capitalize(part));
            } else {
                sb.append(part);
            }
        }
        sb.append(lastPartBaseForm.toLowerCase());
        return sb.toString();
    }

}
