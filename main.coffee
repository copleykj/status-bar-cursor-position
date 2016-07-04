
module.exports = CursorPosition =

   activate: () ->
      @div = document.createElement('div')
      @div.style.display = 'inline-block'
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
         @div.textContent = ''

   update: (editor) ->
      point = editor.getCursorBufferPosition()
      @div.textContent = @pointToPosition point, editor.getText()

   pointToPosition: ({row, column}, text) ->
      line = 0
      position = 0
      infinity = text.length
      while line != row && position < infinity
         if text[position] == '\n'
            line++
         position++
      return position + column

   deacticate: ->
      @activeItemSubscription?.dispose()
      @cursorSubscription?.dispose()
      @statusBarTile?.destroy()

   consumeStatusBar: (statusBar) ->
      @statusBarTile = statusBar.addLeftTile item: @div, priority: 50