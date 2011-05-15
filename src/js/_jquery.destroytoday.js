var hashTable = new Object();

$(document).ready(function()
{
	jQuery.easing.def = 'easeInOutCubic';
	
	$(window).hashchange(function()
	{
		parseHash();

		if (hashTable.n)
			project_goto_index(hashTable.n);
	});
	
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
	
	// project prev arrow
	
	$('.project .image .prev').mouseenter(project_direction_mouseenterHandler);
	$('.project .image .prev').mouseleave(project_direction_mouseleaveHandler);
	$('.project .image .prev').click(project_prev);
	
	// project next arrow
	
	$('.project .image .next').mouseenter(project_direction_mouseenterHandler);
	$('.project .image .next').mouseleave(project_direction_mouseleaveHandler);
	$('.project .image .next').click(project_next);
	$(document).keyup(project_keyupHandler);
	
	parseHash();
	
	if (hashTable.n)
		project_goto_index(hashTable.n);
});

function parseHash()
{
	var hash = document.location.hash.substring(1).split('&');

	for (var assignment in hash)
	{
		assignment = hash[assignment].split('=');

		if (assignment.length > 1)
			hashTable[assignment[0]] = assignment[1];
	}
}

function project_direction_mouseenterHandler(event)
{
	var numThumbs = $('.project .image .images').children('img').size();
		
	if (numThumbs > 1)
	{
		$('body').css('cursor', 'pointer');
		$('body').css('cursor', 'hand');
		$(this).children('.arrow').css('display', 'block');
	}
}

function project_direction_mouseleaveHandler(event)
{
	$('body').css('cursor', 'auto');
	$(this).children('.arrow').css('display', 'none');
}

function project_keyupHandler(event)
{
	if (event.keyCode == '37')
	{
		project_prev();
	} 
	else if (event.keyCode == '39')
	{
		project_next();
	}
}

function project_prev()
{
	var images = $('.project .image .images');
	var current = images.children('.selected');
	
	if (current.length == 0)
		current = images.children('img').first();
	
	var next = current.prev('img');

	if (next.length == 0)
		next = images.children('img').last();

	project_goto(current, next);
}

function project_next()
{
	var images = $('.project .image .images');
	var current = images.children('.selected');
	
	if (current.length == 0)
		current = images.children('img').first();
	
	var next = current.next('img');

	if (next.length == 0)
		next = images.children('img').first();
	
	project_goto(current, next);
}

function project_goto(current, next)
{
	var images = $('.project .image .images');
	var current_index = images.children('img').index(current) + 1;
	var next_index = images.children('img').index(next) + 1;
	var current_thumb = $('.project .metadata .thumbs .thumb:nth-child(' + current_index + ')');
	var next_thumb = $('.project .metadata .thumbs .thumb:nth-child(' + next_index + ')');
	
	document.location.hash = 'n=' + next_index;
	
	current.removeClass('selected');
	next.addClass('selected');

	current_thumb.removeClass('selected');
	current_thumb.addClass('unselected');

	next_thumb.removeClass('unselected');
	next_thumb.addClass('selected');
}

function project_goto_index(index)
{
	var images = $('.project .image .images');
	var current = images.children('.selected');
	
	if (current.length == 0)
		current = images.children('img').first();
	
	var next = $('.project .image .images img:nth-child(' + index + ')');

	project_goto(current, next);
}