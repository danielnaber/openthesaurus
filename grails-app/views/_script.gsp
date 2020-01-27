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
</script>