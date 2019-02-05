/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2019 Daniel Naber
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

import com.mailjet.client.MailjetClient;
import com.mailjet.client.MailjetRequest;
import com.mailjet.client.ClientOptions;
import com.mailjet.client.resource.Emailv31;
import org.json.JSONObject;
import org.json.JSONArray;

class MailSender {
  
  public static int sendMail(String mailjetId, String mailjetApiKey, String toAddress, String subject, String body, String fromAddress) throws Exception {
    MailjetClient client = new MailjetClient(mailjetId, mailjetApiKey, new ClientOptions("v3.1"));
    JSONObject message = new JSONObject();
    message.put(Emailv31.Message.FROM, new JSONObject()
                  .put(Emailv31.Message.EMAIL, fromAddress)
                )
                .put(Emailv31.Message.SUBJECT, subject)
                .put(Emailv31.Message.TEXTPART, body)
                .put(Emailv31.Message.TO, new JSONArray()
                    .put(new JSONObject()
                    .put(Emailv31.Message.EMAIL, toAddress)
                 ));

    MailjetRequest email = new MailjetRequest(Emailv31.resource).property(Emailv31.MESSAGES, (new JSONArray()).put(message));

    return client.post(email).getStatus();
  }

}