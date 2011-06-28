var hashTable = new Object();

$(document).ready(function()
{
	jQuery.easing.def = 'easeInOutCubic';
	
	$('.project_thumb').each(function(index)
	{
		$(this).children('.color_blocks').css('top', $(this).children('a').children('img').height());
		$(this).children('.metadata').css('top', $(this).children('a').children('img').height() + 5);
	});
	
	$('.project_thumb').mouseenter(function(event)
	{
		var image = $(event.currentTarget).children('a').children('img');
		var color_blocks = $(event.currentTarget).children('.color_blocks');
		
		color_blocks.stop();
		
		color_blocks.animate(
		{
			'top': 0,
			'height': image.height() + 10
		}, 
		{
			duration: 350
		});
	});

	$('.project_thumb').mouseleave(function(event)
	{
		var image = $(event.currentTarget).children('a').children('img');
		var color_blocks = $(event.currentTarget).children('.color_blocks');
		
		color_blocks.stop();
		
		color_blocks.animate(
		{
			'top': image.height(),
			'height': 10
		}, 
		{
			duration: 350
		});
	});
	
	$("p").each(function() {
         var wordArray = $(this).text().split(" ");
         var finalTitle = "";
         for (i=0;i<=wordArray.length-1;i++) {
            finalTitle += wordArray[i];
            if (i == (wordArray.length-2)) {
                finalTitle += "&nbsp;";
            } else {
                finalTitle += " ";
            }
          }
          $(this).html(finalTitle);
	});
	
	function rgb2hex(rgb)
	{
		rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
		
		return ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
				("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
				("0" + parseInt(rgb[3],10).toString(16)).slice(-2);
	}
	
	$(".twitter-follow-button").attr('data-text-color', rgb2hex($("body").css('color')));
	$(".twitter-follow-button").attr('data-link-color', rgb2hex($(".twitter-follow-button").css('color')));
	
	var twitterWidgets = document.createElement('script');
	twitterWidgets.type = 'text/javascript';
	twitterWidgets.async = true;
	twitterWidgets.src = 'http://platform.twitter.com/widgets.js'
	document.getElementsByTagName('head')[0].appendChild(twitterWidgets);
});
