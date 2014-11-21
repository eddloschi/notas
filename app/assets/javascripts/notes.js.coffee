# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@change_color = (color) ->
  $('#note-card').css 'background-color', color
  $('input[name="note[color]"]').val color
