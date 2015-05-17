ready = ->

  recordButtonPressed = ->
    startingToRecord = $recordButton.html() is "Record"
    $recordButton
      .html (if startingToRecord then "Stop" else "Record")
      .toggleClass "btn-success"
      .toggleClass "btn-danger"
    return unless Storage?
    if startingToRecord
      localStorage.setItem currentUrl, $.now()
      $timerReading.text "0:00"
      beginIncrementer()
    else
      # pressed "Stop", send interval and render response
      timeSpan = interval: localStorage.getItem(currentUrl) + " " + $.now()

      $.post currentUrl + "/intervals-ajax.json", timeSpan, (data) ->

        # add row to interval table
        $("#interval-table").append(
          $("<tr>").addClass("interval").attr("id", data.id).append(
            $('<td>').text(data.start),
            $('<td>').text(data.end),
            $('<td>').text(data.time),
            $('<td>').text(data.date),
            $('<td>').html(data.button.replace(/'/g,'"'))))

        # update states on time spent today this is where I use them
        $("#tt").html(data.tt) # [updated] time today
        $("#iw").html(data.iw) # [updated] total time in words
        $("#ih").html(data.ih) # [updated] total time in hours

        cancelRecording()
        # one is supposed to have this "empty return" so that you
        # don't unnecessarily waste memory (and confuse yourself)
        # by returning the result of your last statement
        return

      localStorage.removeItem currentUrl
    return

  beginIncrementer = ->
    $cancelButton.show()
    $plusAndMinus.show()
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

    $timerReading.text time
    return

  initialize = ->
    return unless Storage?
    if localStorage.getItem(currentUrl)?
      $recordButton
        .html "Stop"
        .addClass "btn-danger"
        .removeClass "btn-success"
      beginIncrementer()
    else
      cancelRecording()
    return

  cancelRecording = ->
    localStorage.removeItem currentUrl
    $recordButton
      .html "Record"
      .addClass "btn-success"
      .removeClass "btn-danger"
    $timerReading.text ""
    clearInterval(root.counterID)
    $cancelButton.hide()
    $plusAndMinus.hide()
    return

  startMinute = (earlier) ->
    startTime = localStorage.getItem currentUrl
    return unless startTime?

    time = Number.parseInt startTime
    minute = 1000 * 60 # it's in milliseconds
    oneMinuteChanged = if earlier then time + minute else time - minute
    localStorage.setItem(currentUrl, oneMinuteChanged)
    updateReading()
    return

  # initializations
  currentUrl = window.location.pathname
  $recordButton = $("#record")
  $cancelButton = $("#cancel")
  $plusAndMinus = $("#incrementers")
  $timerReading = $("#timer-reading")
  root = exports ? this # finagling to create "global(ish)" variable
  root.counterID = null
  $tableTitle = $("#tasks-list-title")
  $(".turned-in").hide()
  initialize()
  # click handlers
  $recordButton.click -> recordButtonPressed()
  $cancelButton.click -> cancelRecording()
  $("#toggle-intervals").click -> $("#interval-table").slideToggle("slow")
  $("#toggle-subtasks").click -> $("#subtasks-list").slideToggle("slow")
  $("#before-decrease").click -> startMinute true
  $("#before-increase").click -> startMinute false

  # switch Turned-In/Not for table on '/tasks'
  $("#switch-hide-turned-in").click ->
      $(".turned-in").toggle()
      $(".not-turned-in").toggle()
      if $tableTitle.text().match /Not/
        $tableTitle.text "Turned In"
      else
        $tableTitle.text "Not Turned In"
      return

  # enable DataTable on '/tasks'
  $("#tasks-list").dataTable
    sPaginationType: "bootstrap"
    iDisplayLength: -1 # default to showing all rows
    bLengthChange: false # hide "records per page selector"
#    aLengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]]

  # create sorting column for tasks/index
  # TODO this doesn't actually add sort functionality
  # probably because the data table is init'd by "datatables before this runs
  addSortValues = (items) ->
    items.each (idx, elem) ->
      $(elem).find('.sort-col').text(idx+1)
  addSortValues $('.turned-in')
  addSortValues $('.not-turned-in')

  return


# These *are* both necessary.
# The first one is for when you reload the page.
# The second is for when you link to the page.
# This guess comes from some "controlled" experiments.
$(ready)
$(document).on 'page:load', ready
