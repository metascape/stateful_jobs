$.fn.extend
  statefulJobs: (url, options = {}) ->
    settings =
      interval: 5000
      final: 'done'
      ajax: true
      callback: null
      action: null

    settings = $.extend settings, options

    return @each () ->
      new StatefulJobs url, settings, $(this)

class @StatefulJobs

  @spinners = {}

  constructor: (@url, @options, @element) ->
    @currentJob   = @element.data('current-job')
    @currentState = @element.data('current-state')
    @element.removeData('current-job')
    @element.removeData('current-state')
    @options = $.extend @element.data(), @options

    @timer = null

    StatefulJobs.spinners[@options.id] = @

    @start() unless @current == @options.final

  getState: () =>
    $.getJSON("#{@url}/#{@options.id}/state", @gotState)

  gotState: (s) =>
    if @currentJob != s.current_job or @currentState != s.current_state
      @currentJob = s.current_job
      @currentState = s.current_state
      @element.removeClass('active')

      if @options.callback
        @options.callback(@)
      else
        if @options.action
          url = "#{@url}/#{@options.id}/#{@options.action}?current_job=#{@currentJob}&current_state=#{@currentState}"
        else
          url = "#{@url}/#{@options.id}/#{@currentJob}?current_state=#{@currentState}"

        if @options.ajax
          $.getScript url
        else
          location.href = url
    else
      setTimeout @getState, @options.interval

  start: ->
    @element.addClass('active')
    @timer = setTimeout @getState, @options.interval

  stop: ->
    @element.removeClass('active')
    clearTimeout @timer

  @get: (id) ->
    StatefulJobs.spinners[id]