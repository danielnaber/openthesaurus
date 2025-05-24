<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Category List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="/">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Category</g:link></span>
        </div>
        <div class="body">

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
                        
                            <g:sortableColumn property="isDisabled" title="isDisabled" />

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${categoryList}" status="i" var="category">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${category.id}">${category.id?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td><g:link action="show" id="${category.id}">${category.categoryName?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td>${category.isDisabled || category.isDisabled == null ? "yes" : "no"}</td>

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
