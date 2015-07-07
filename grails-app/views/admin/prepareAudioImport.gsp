<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title>Audio Import - OpenThesaurus</title>
    <meta name="layout" content="main" />
</head>
<body>

<hr/>

<h2>Audio Import</h2>

<g:form action="importAudio" method="post" onsubmit="return confirm('Really import this, deleting ALL existing audio data?')">
    Local path to extracted audio data from Wiktionary: <input type="text" name="path" value=""><br/>
    Expected format example:
<pre style="background-color: #ccc">
De-Mai.ogg|Mai
De-Juni.ogg|Juni
De-Juli.ogg|Juli
De-August.ogg|August
</pre>
    <input type="submit" value="Delete all audio and import file">
</g:form>

</body>
</html>
