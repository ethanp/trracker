# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  recordButtonPressed = ->
    startingToRecord = recordButton.html() is "Record"
    recordButton
      .html (if startingToRecord then "Stop" else "Record")
      .toggleClass "btn-success"
      .toggleClass "btn-danger"

    if Storage?
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
    else
      recordButton.html "DISABLED"
    return

  # TODO this counterID variable must be global. not sure how to do that in coffeescript
  beginIncrementer = ->
    counterID = window.setInterval(updateReading, 1000)


  updateReading = ->
    startTime = localStorage.getItem(currentUrl)
    startVal = Number.parseInt(startTime)
    return unless startTime?
    reading.text (($.now() - startVal) / 1000)

  initialize = ->
    if Storage?
      if localStorage.getItem(currentUrl)?
        recordButton
          .html "Stop"
          .addClass "btn-danger"
          .removeClass "btn-success"
        beginIncrementer()
      else
        cancelRecording()
    else
      recordButton.html "DISABLED"
    return

  cancelRecording = ->
    localStorage.removeItem currentUrl
    recordButton
      .html "Record"
      .addClass "btn-success"
      .removeClass "btn-danger"
    reading.text ""
#    clearInterval(counterID) # TODO get this working via global var
    return

  # initializations
  currentUrl = window.location.pathname
  recordButton = $("#record")
  reading = $("#timer-reading")
  initialize()

  # click handlers
  recordButton.click -> recordButtonPressed()
  $("#cancel").click -> cancelRecording()
  $("#toggle-intervals").click -> $("#intervals").slideToggle("slow")
  $("#toggle-subtasks").click -> $("#subtasks").slideToggle("slow")

  # enable DataTable
  $("#tasks-list").dataTable sPaginationType: "bootstrap"

$(document).ready(ready)
$(document).on 'page:load', ready
