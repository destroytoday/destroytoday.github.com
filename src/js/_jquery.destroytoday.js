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
	
	$('.direction').mouseenter(function(event)
	{
		var title_wrapper = $(event.currentTarget).children('a').children('.title_wrapper');
		var title = title_wrapper.children('.title');
		
		title_wrapper.stop();
		title_wrapper.css('visibility', 'visible');
		title_wrapper.animate(
		{
		    'width': title.width()
		}, 
		{
			duration: 350
		});
	});
	
	$('.direction').mouseleave(function(event)
	{
		var title_wrapper = $(event.currentTarget).children('a').children('.title_wrapper');
		var title = title_wrapper.children('.title');
		
		title_wrapper.stop();
		title_wrapper.animate(
		{
		    'width': 1
		},
		{
			duration: 350,
			complete: function()
			{
			    title_wrapper.css('visibility', 'hidden');
		    }
		});
	});
	
	$('.direction').click(function(event)
	{
		window.location = $(event.currentTarget).children('a').attr('href');
	});
	
	function rgb2hex(rgb)
	{
		rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
		
		return ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
				("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
				("0" + parseInt(rgb[3],10).toString(16)).slice(-2);
	}
	
	/*
	//Shaun Inman widon't, still need to figure out links
	function widont(str)
	{
	   return str.replace(/([^\s])\s+([^\s<>]+)\s*$/g, '$1&nbsp;$2');
    }
    
    $('p').each(function()
    {
        var str = $(this).html();
        var matchList = str.match(/<(a|img)[^>]*>(.+)<\/\1>/ig);
        
        if (matchList)
    	{	
    		for (var match in matchList)
    		{
    			str = str.replace(match, widont(match));
    		}
    	}

    	$(this).html(str);
    });*/
    
	$('.email').html("<a href=\"mailto:jonnie@destroytoday.com\">jonnie@destroytoday.com</a>");
	
	$(".twitter-follow-button").attr('data-text-color', rgb2hex($("body").css('color')));
	$(".twitter-follow-button").attr('data-link-color', rgb2hex($(".twitter-follow-button").css('color')));
	
	var twitterWidgets = document.createElement('script');
	twitterWidgets.type = 'text/javascript';
	twitterWidgets.async = true;
	twitterWidgets.src = 'http://platform.twitter.com/widgets.js'
	document.getElementsByTagName('head')[0].appendChild(twitterWidgets);
});
