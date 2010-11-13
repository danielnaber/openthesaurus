<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Category List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Category</g:link></span>
        </div>
        <div class="body">

            <hr/>

            <h2>Category List</h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <div class="colspanlist">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="categoryName" title="Category Name" />
                        
                            <g:sortableColumn property="uri" title="Uri" />

                            <g:sortableColumn property="isDisabled" title="isDisabled" />

                            <g:sortableColumn property="isOriginal" title="fromLargeCategorySet" />

                            <g:sortableColumn property="categoryType" title="Category Type" />

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${categoryList}" status="i" var="category">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${category.id}">${category.id?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td><g:link action="show" id="${category.id}">${category.categoryName?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td>${category.uri?.toString()?.encodeAsHTML()}</td>

                            <td>${category.isDisabled || category.isDisabled == null ? "yes" : "no"}</td>

                            <td>${category.isOriginal || category.isOriginal == null ? "yes" : "no"}</td>

                            <td>${category.categoryType}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Category.count()}" />
            </div>
        </div>
    </body>
</html>
