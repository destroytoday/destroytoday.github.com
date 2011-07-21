search = (str) -> 
  $.ajax
    url: "/js/blog_index.json"
    dataType: 'json'
    cache: false
    success: (data) ->
      $.each data (key, value) ->
         if (value.content.indexOf(str) != -1)
             $('#search').html("{% include blog_post.html %}")
