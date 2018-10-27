<html>
  <head>
	  <title><g:message code="server.error.title"/></title>
	  <style type="text/css">
	  		.message {
	  			border: 1px solid black;
	  			padding: 5px;
	  			background-color:#E9E9E9;
	  		}
	  		.stack {
	  			border: 1px solid black;
	  			padding: 5px;	  		
	  			overflow:auto;
	  			height: 300px;
	  		}
	  		.snippet {
	  			padding: 5px;
	  			background-color:white;
	  			border:1px solid black;
	  			margin:3px;
	  			font-family:courier,serif;
	  		}
	  </style>
  </head>
  
  <body>

    <h1><g:message code="server.error.headline"/></h1>

    <p><g:message code="server.error.description"/>: ${new Date()}</p>

  <g:if env="development">
	  <g:if test="${Throwable.isInstance(exception)}">
		  <g:renderException exception="${exception}" />
	  </g:if>
	  <g:elseif test="${request.getAttribute('javax.servlet.error.exception')}">
		  <g:renderException exception="${request.getAttribute('javax.servlet.error.exception')}" />
	  </g:elseif>
	  <g:else>
		  <ul class="errors">
			  <li>An error has occurred</li>
			  <li>Exception: ${exception}</li>
			  <li>Message: ${message}</li>
			  <li>Path: ${path}</li>
		  </ul>
	  </g:else>
  </g:if>
  <g:else>
	  <ul class="errors">
		  <li>An error has occurred</li>
	  </ul>
  </g:else>

    <%--
    <h1>xxxGrails Runtime Exception</h1>

    <h2>Error Details</h2>
  	<div class="message">
  		<strong>Message:</strong> ${exception.message?.encodeAsHTML()} <br />
  		<strong>Caused by:</strong> ${exception.cause?.message?.encodeAsHTML()} <br />
  		<strong>Class:</strong> ${exception.className} <br />  		  		
  		<strong>At Line:</strong> [${exception.lineNumber}] <br />  		
  		<strong>Code Snippet:</strong><br />   		
  		<div class="snippet">
  			<g:each var="cs" in="${exception.codeSnippet}"> 
  				${cs?.encodeAsHTML()}<br />  			
  			</g:each>  	
  		</div>	  		
  	</div>
    <h2>Stack Trace</h2>
    <div class="stack">
      <pre><g:each in="${exception.stackTraceLines}">${it.encodeAsHTML()}<br/></g:each></pre>
    </div>
    --%>
    
  </body>
</html>