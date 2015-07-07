<%@page import="com.vionto.vithesaurus.Audio" %>
<%
    List<Audio> audios = Audio.findAllByWord(term.toString())
    if (audios.size() > 0 && session.user) {
        %>
        <audio id="audio${term.id}" src="${audios.get(0).url}"></audio>
        <a href="javascript:document.getElementById('audio${term.id}').play()"><img
                src="${createLinkTo(dir:'images', file:'loudspeaker-12px.png')}"
                title="${message(code:'audio.title')}"></a>
        <!-- TODO: error handling see https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Using_HTML5_audio_and_video -->
        <%
    }
%>
