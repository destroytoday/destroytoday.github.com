---
---
search = (str) -> 
  $.ajax
    url: "/js/blog_index.json"
    dataType: 'json'
    cache: false
    success: (data) ->
        alert 'search'