---
---
#--------------------------------------------------------------------------
#
#  Config
#
#--------------------------------------------------------------------------

jQuery.easing.def = 'easeInOutCubic'

jQuery.timeago.settings.strings = 
    prefixAgo: null
    prefixFromNow: 'in'
    suffixAgo: 'ago'
    suffixFromNow: null
    seconds: 'several seconds'
    minute: 'a minute'
    minutes: '%d minutes'
    hour: 'an hour'
    hours: '%d hours'
    day: 'a day'
    days: '%d days'
    month: 'a month'
    months: '%d months'
    year: 'a year'
    years: '%d years'


#--------------------------------------------------------------------------
#
#  Global Functions
#
#--------------------------------------------------------------------------

rgb2hex = (rgb) ->
    parse = (c) -> ("0" + parseInt(c, 10).toString(16)).slice(-2)
    
    rgb = rgb.match /^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/
    r = parse rgb[1]
    g = parse rgb[2]
    b = parse rgb[3]

    r + g + b
    
linkify = (text) ->
    exp = /((?:ftp|http|https):\/\/)((\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?)/gi
    text = text.replace exp, "<a href=\"$1$2\">$2</a>"
    text = text.replace /@([a-z0-9_]+)/gi, "<a href=\"http://twitter.com/$1\">@$1</a>"
    
getLatestTweet = ->
    latest_tweet = $.cookie('destroytoday-latest-tweet')
    latest_tweet_timestamp = $.cookie('destroytoday-latest-tweet-timestamp')

    if latest_tweet && latest_tweet_timestamp
        setLatestTweet(latest_tweet, latest_tweet_timestamp)
    else
        $.ajax
          url: "http://twitter.com/statuses/user_timeline/destroytoday.json?count=30"
          dataType: 'jsonp'
          success: (data) ->
              $.each data, (key, value) ->
                  if value.text.substring(0, 1) != "@"
                      tweet = linkify(value.text)
                      timestamp = value.created_at
                        # +
                        #" <a class=\"timestamp\" href=\"http://twitter.com/destroytoday/status/" + value.id_str + "\">" + 
                        #jQuery.timeago(value.created_at).replace(/[\s]+/ig, '&nbsp;') +
                        #"</a>"
                    
                      $.cookie 'destroytoday-latest-tweet', tweet
                      $.cookie 'destroytoday-latest-tweet-timestamp', timestamp
      
                      setLatestTweet tweet, timestamp
   
                      false
                  
setLatestTweet = (tweet, timestamp) ->
    $('#latest-tweet p.tweet').html tweet
    $('#latest-tweet .timestamp').html jQuery.timeago(timestamp)
    $('#latest-tweet').css 'height', $('#latest-tweet p').height() + 20 + $('#latest-tweet img#bubble-arrow').height() + 8 + $('#latest-tweet #avatar img').height() + 37

#--------------------------------------------------------------------------
#
#  Ready
#
#--------------------------------------------------------------------------
    
$(document).ready ->
    # chosen
    #$(".chzn-select").chosen()
    
    # inject email
    $('.email').html '<a href="mailto:jonnie@destroytoday.com">jonnie@destroytoday.com</a>'
    
    #--------------------------------------
    #  paging
    #--------------------------------------
    
    $(window).resize ->
        display = if $(window).width() < 1030 then display = 'none' else display = 'block'
        
        $('.direction').css('display', display)
    
    # next/prev arrow over
    $('.direction').mouseenter (event) ->
        title_wrapper = $(event.currentTarget).children('.title_wrapper')
        title = title_wrapper.children('.title')
        arrow_wrapper = $(event.currentTarget).children('.arrow_wrapper')
        
        if ($('body').width() - $('#page').width()) / 2 >= title.width() + arrow_wrapper.width() + 30
            title_wrapper.stop()
            title_wrapper.css 'visibility', 'visible'
            title_wrapper.animate { width: title.width() }, { duration: 350 }
        
    # next/prev arrow out
    $('.direction').mouseleave (event) ->
        title_wrapper = $(event.currentTarget).children('.title_wrapper')
        title = title_wrapper.children('.title')
        
        title_wrapper.stop()
        title_wrapper.animate { width: 1 }, { duration: 350, complete: -> title_wrapper.css 'visibility', 'hidden' }
        
    # next/prev arrow click
    $('.direction').click (event) ->
        window.location = $(event.currentTarget).children('a').attr('href')

    #--------------------------------------
    #  flash
    #--------------------------------------

    # inject flash
    $('.flash').each ->
        $(this).html """
                        <div class="swf"></div>
                        <div class="play"></div>
                        <div class="stop"></div>
                        <div class="placeholder">#{$(this).html()}</div>
                     """
    # mouse over flash
    $('.flash').mouseenter (event) ->
        play = $(this).children('.play')
        stop = $(this).children('.stop')
        
        if $(this).children('.swf').css('display') == 'none'
            play.css 'opacity', 1
            stop.css 'opacity', 0
        else
            play.css 'opacity', 0
            stop.css 'opacity', 1
        
    # mouse out flash
    $('.flash').mouseleave (event) ->
        $(this).children('.play').css 'opacity', 0
        $(this).children('.stop').css 'opacity', 0

    # click to play flash
    $('.flash').click (event) ->
        if $(this).children('.swf').css('display') == 'none'
            event.preventDefault()
        
            $('.flash .swf').html ''
            $('.flash .swf').css 'display', 'none'
            $('.flash .stop').css 'opacity', 0
            $('.flash .play').css 'opacity', 0
    
            swf = $(this).children('.swf')
            $(this).children('.stop').css 'opacity', 1
    
            swf.css 'display', 'block'
            swf.flash {
                swf: $(this).children('.placeholder').children('img').attr('src').replace /\.(gif|jpg|jpeg|png)/i, '.swf'
                width: swf.width()
                height: swf.height()
                bgcolor: rgb2hex $('body').css('background-color')
                scale: 'noscale'
            }
            
    # click to stop flash
    $('.flash .stop').click (event) ->
        if $(this).siblings('.swf').css('display') != 'none'
            event.stopPropagation()
        
            $(this).css 'opacity', 0
            $(this).siblings('.swf').html ''
            $(this).siblings('.swf').css 'display', 'none'
            $(this).siblings('.play').css 'opacity', 1

    if $('#latest-tweet').length > 0
        t = setTimeout getLatestTweet, 2000
    
    ###
    if ($("#latest-flickr"))
    {
        $.ajax({
            url: "http://api.flickr.com/services/feeds/photos_public.gne?id=13185812@N03&lang=en-us&format=json",
            dataType: "jsonp",
            jsonpCallback: "jsonFlickrFeed",
            success: (data) ->
                $('#latest-flickr').html('<img src="' + data.items[0].media.m + '" />');
        });
    }
    ###
    
    #--------------------------------------
    #  Disqus
    #--------------------------------------
    if $('#disqus_thread').length > 0
        ds_loaded = false
        top = $('.tags').offset().top
 
        lazyLoadDisqus = ->
            if !ds_loaded && $(window).scrollTop() + $(window).height() > top
                ds_loaded = true
                dsq = document.createElement('script')
                dsq.type = 'text/javascript'
                dsq.async = true
                dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js'
                (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq)
        
        $(window).scroll lazyLoadDisqus
        lazyLoadDisqus()
    #--------------------------------------
    #  Twitter Follow Button
    #--------------------------------------

    # $('.twitter-follow-button').length || 
    if $('.twitter-share-button').length
        #$(".twitter-follow-button").attr('data-text-color', rgb2hex($("body").css('color')))
        #$(".twitter-follow-button").attr('data-link-color', rgb2hex($(".twitter-follow-button").css('color')))
        twitterWidgets = document.createElement 'script'
        twitterWidgets.type = 'text/javascript'
        twitterWidgets.async = true
        twitterWidgets.src = 'http://platform.twitter.com/widgets.js'
        document.getElementsByTagName('head')[0].appendChild(twitterWidgets)