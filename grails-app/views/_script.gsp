<script type="text/javascript">
  var isFocused = false;
  function selectSearchField(originalQuery) {
      var isTouchDevice = 'ontouchstart' in document.documentElement;
      if (!isFocused && document.searchform && document.searchform.q && !isTouchDevice) {
          document.searchform.q.select();
          isFocused = true;
      }
      return true;
  }
  function leaveSearchField() {
      isFocused = false;
  }
</script>
