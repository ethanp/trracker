# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->

  $showButton = $('#show-all-switch')
  $deadCats = $('.dead')

  showAll = ->
    $showButton.text 'Unshow All'
    $deadCats.show()
    return

  unshowAll = ->
    $showButton.text 'Show All'
    $deadCats.hide()
    return

  unshowAll() # this is the default state of the page (retains no memory of how it was before)

  $showButton.click ->
    $showButton.toggleClass 'showing-all'
    if $showButton.hasClass 'showing-all'
      showAll()
    else
      unshowAll()
    return

$(ready)
$(document).on 'page:load', ready
