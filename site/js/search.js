(function() {
  var search;
  search = function(str) {
    return $.ajax({
      url: "/js/blog_index.json",
      dataType: 'json',
      cache: false,
      success: function(data) {
        return $.each(data(function(key, value) {
          if (value.content.indexOf(str) !== -1) {
            return $('#search').html("{% include blog_post.html %}");
          }
        }));
      }
    });
  };
}).call(this);
