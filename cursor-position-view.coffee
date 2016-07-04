
class CursorPositionView extends HTMLElement

   initialize: ->
      @classList.add('cursor-position', 'inline-block')
      @subscribeToActiveTextEditor()
      @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem (activeItem) =>
         @subscribeToActiveTextEditor()

   subscribeToActiveTextEditor: ->
      if editor = atom.workspace.getActiveTextEditor()
         @update editor
         @cursorSubscription = editor.onDidChangeCursorPosition () =>
            @update editor
      else
         @cursorSubscription?.dispose()
         @textContent = ''

   update: (editor) ->
      point = editor.getCursorBufferPosition()
      @textContent = @pointToPosition point, editor.getText()

   pointToPosition: ({row, column}, text) ->
      line = 0
      position = 0
      infinity = text.length
      while line != row && position < infinity
         if text[position] == '\n'
            line++
         position++
      return position + column

   destroy: ->
     @activeItemSubscription?.dispose()
     @cursorSubscription?.dispose()

module.exports = document.registerElement('cursor-position', prototype: CursorPositionView.prototype, extends: 'div')
