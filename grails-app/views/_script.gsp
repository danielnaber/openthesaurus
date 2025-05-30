<script type="text/javascript">
  var isFocused = false;
  function selectSearchField(originalQuery) {
      if (!isFocused && document.searchform && document.searchform.q) {
          document.searchform.q.select();
          isFocused = true;
      }
      return true;
  }
  function leaveSearchField() {
      isFocused = false;
  }
  function doSubmit() {
    window.location = '/synonyme/' + encodeURIComponent(document.searchform.q.value.replace('/', '___'));
    try {
        plausible('search form submitted');
    } catch (e) {
        // plausible not available
    }
    return false;
  }
</script>