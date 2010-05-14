/**
 * vithesaurus - web-based thesaurus management tool
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

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

public class BaseformFinder {

    private final Connection connection;

    public BaseformFinder(Connection connection) {
        this.connection = connection;
    }

    public String getBaseForm(final String term) throws SQLException {
        String baseform = null;
        final String sql = "SELECT word FROM word_forms WHERE id = (SELECT word_mapping.base_id" +
                "   FROM word_forms, word_mapping" +
                "   WHERE" +
                "       word_forms.word = ? AND" +
                "       word_mapping.derived_id = word_forms.id LIMIT 1)";
        final PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, term);
        final ResultSet resultSet = statement.executeQuery();
        if (resultSet.next()) {
            baseform = resultSet.getString("word");
        }
        resultSet.close();
        statement.close();
        return baseform;
    }

}
