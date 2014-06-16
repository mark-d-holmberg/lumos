jQuery ->
  # Enable datepicker input fields
  $(".datepicker").datepicker({format: 'yyyy-mm-dd'})

  # Allow linking to specific Bootstrap Tabs
  # Javascript to enable link to tab
  url = document.location.toString()
  $(".nav-tabs a[href=#" + url.split("#")[1] + "]").tab "show"  if url.match("#")

  # Change hash for page-reload
  $("a[data-toggle=\"tab\"]").on "show.bs.tab", (e) ->
    window.location.hash = e.target.hash
