<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Facts</title>
    </head>
    <body>

        <div class="body">
            <h1>Facts</h1>
            
            <p>Please note that this page lists the facts currently in the database.
            The number of facts may differ from the number in the link to this page.</p>
            
            <br />
    
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
    
            <div class="list">
                <table>
                    <thead>
                        <th>Source</th>
                        <th>Text</th>
                    </thead>
                    <tbody>
                    <g:each in="${facts}" status="i" var="fact">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>
                                <g:if test="${fact.repo == 'internet'}">
                                     <a href="${fact.url}">Web</a>
                                </g:if>
                                <g:elseif test="${fact.repo == 'medline'}">
                                     <%
                                     int pos = fact.url.lastIndexOf(":")
                                     String id = fact.url.substring(pos+1)
                                     %>
                                     <a href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&amp;db=pubmed&amp;dopt=Abstract&amp;list_uids=${id}">Medline</a>
                                </g:elseif>
                                <g:elseif test="${fact.repo == 'nlm:clinicaltrial'}">
                                     <a href="${fact.url}">Clinical&nbsp;Trials</a>
                                </g:elseif>
                                <g:else>
                                     ${fact.repo}
                                </g:else>
                            </td>
                            <td>${fact.text}</td>
                                                
                        </tr>
                    </g:each>
                    </tbody>
                </table>
                
                <br />
                <p class="metaInfo">Database: ${dbUrl.encodeAsHTML()}, 
                    User: ${dbUser.encodeAsHTML()}<br />
                    Installation number: ${installationNumber.encodeAsHTML()},
                    Schema ID: ${schemaID.encodeAsHTML()}
                    </p>
                
            </div>
        </div>
    </body>
</html>
