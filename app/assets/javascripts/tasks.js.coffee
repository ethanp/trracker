ready = ->

  recordButtonPressed = ->
    startingToRecord = recordButton.html() is "Record"
    recordButton
      .html (if startingToRecord then "Stop" else "Record")
      .toggleClass "btn-success"
      .toggleClass "btn-danger"
    return unless Storage?
    if startingToRecord
      localStorage.setItem currentUrl, $.now()
      reading.text "0:00"
      beginIncrementer()
    else
      timeSpan = interval: localStorage.getItem(currentUrl) + " " + $.now()
      $.post currentUrl + "/intervals-ajax.json", timeSpan, (data) ->

        $("#interval-table").append(
          $("<tr>").attr("id", data.id).append(
            $('<td>').text(data.start),
            $('<td>').text(data.end),
            $('<td>').text(data.time),
            $('<td>').text(data.date),
            $('<td>').html(data.button.replace(/'/g,'"'))))

        cancelRecording()
        # one is supposed to have this "empty return" so that you
        # don't unnecessarily waste memory (and confuse yourself)
        # by returning the result of your last statement
        return

      localStorage.removeItem currentUrl
    return

  beginIncrementer = ->
    root.counterID = window.setInterval updateReading, 1000


  updateReading = ->
    startTime = localStorage.getItem currentUrl
    return unless startTime?

    # figure out time to display
    startVal = Number.parseInt startTime
    total_seconds = Math.floor ($.now() - startVal) / 1000
    total_minutes = Math.floor total_seconds / 60
    hours = Math.floor total_minutes / 60
    minutes = total_minutes % 60
    seconds = total_seconds % 60

    # pad with zeros if need-be
    seconds = '0'+seconds if seconds < 10
    minutes = '0'+minutes if minutes < 10 and hours > 0
    time = minutes+":"+seconds
    time = hours+":"+time if hours > 0

    reading.text time
    return

  initialize = ->
    return unless Storage?
    if localStorage.getItem(currentUrl)?
      recordButton
        .html "Stop"
        .addClass "btn-danger"
        .removeClass "btn-success"
      beginIncrementer()
    else
      cancelRecording()
    return

  cancelRecording = ->
    localStorage.removeItem currentUrl
    recordButton
      .html "Record"
      .addClass "btn-success"
      .removeClass "btn-danger"
    reading.text ""
    clearInterval(root.counterID)
    return

  startMinute = (earlier) ->
    startTime = localStorage.getItem currentUrl
    return unless startTime?

    timeValue = Number.parseInt startTime
    oneMinute = 1000 * 60 # it's in milliseconds
    oneMinuteChanged = if earlier then timeValue + oneMinute else timeValue - oneMinute
    localStorage.setItem(currentUrl, oneMinuteChanged)
    updateReading()
    return

  # initializations
  currentUrl = window.location.pathname
  recordButton = $("#record")
  reading = $("#timer-reading")
  root = exports ? this # finagling to create "global(ish)" variable
  root.counterID = null
  initialize()

  # click handlers
  recordButton.click -> recordButtonPressed()
  $("#cancel").click -> cancelRecording()
  $("#toggle-intervals").click -> $("#interval-table").slideToggle("slow")
  $("#toggle-subtasks").click  -> $("#subtasks-list").slideToggle("slow")
  $("#before-decrease").click  -> startMinute true
  $("#before-increase").click  -> startMinute false

  # enable DataTable
  $("#tasks-list").dataTable sPaginationType: "bootstrap"

# These *are* both necessary.
# The first one is for when you reload the page.
# The second is for when you link to the page.
# This guess comes from some "controlled" experiments.
$(ready)
$(document).on 'page:load', ready
