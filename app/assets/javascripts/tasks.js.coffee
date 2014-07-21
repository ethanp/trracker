# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  recordButtonPressed = ->
    startingToRecord = recordButton.html() is "Record"
    recordButton.html((if startingToRecord then "Stop" else "Record")).toggleClass("btn-success").toggleClass "btn-danger"
    if typeof (Storage) isnt "undefined"
      if startingToRecord
        localStorage.setItem currentUrl, $.now()
      else
        timeSpan = interval: localStorage.getItem(currentUrl) + " " + $.now()
        $.post currentUrl + "/intervals-ajax", timeSpan, (data) ->

          # TODO this does what it says, but does nothing useful
          $("#intervals").appendChild $("p").html("Success!")
          return

        localStorage.removeItem currentUrl
    else
      recordButton.html "DISABLED"
    return

  initializeRecordButton = ->
    if typeof (Storage) isnt "undefined"
      if localStorage.getItem(currentUrl) isnt null
        recordButton.html("Stop").addClass("btn-danger").removeClass "btn-success"
      else
        cancelRecording()
    else
      recordButton.html "DISABLED"
    return

  cancelRecording = ->
    if typeof (Storage) isnt "undefined"
      localStorage.removeItem currentUrl
      recordButton.html("Record").addClass("btn-success").removeClass "btn-danger"
    else
      recordButton.html "DISABLED"
    return

  # initializations
  currentUrl = window.location.pathname
  recordButton = $("#record")
  initializeRecordButton()

  # click handlers
  recordButton.click -> recordButtonPressed()
  $("#cancel").click -> cancelRecording()
  $("#toggle-intervals").click -> $("#intervals").slideToggle "slow"
  $("#toggle-subtasks").click -> $("#subtasks").slideToggle "slow"

$(document).ready(ready)
$(document).on('page:load', ready)
