
module.exports = CursorPosition =

   activate: () ->
      @div = document.createElement('div')
      @div.style.display = 'inline-block'
      @subscribeToActiveTextEditor()
      @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem (activeItem) =>
         @subscribeToActiveTextEditor()

   subscribeToActiveTextEditor: ->
      if editor = atom.workspace.getActiveTextEditor()
         buffer = editor.buffer
         @update editor, buffer
         @cursorSubscription = editor.onDidChangeCursorPosition () =>
            @update editor, buffer
      else
         @cursorSubscription?.dispose()
         @div.textContent = ''

   update: (editor, buffer) ->
      @div.textContent = buffer.characterIndexForPosition(editor.getCursorBufferPosition())

   deactivate: ->
      @activeItemSubscription?.dispose()
      @cursorSubscription?.dispose()
      @statusBarTile?.destroy()

   consumeStatusBar: (statusBar) ->
      @statusBarTile = statusBar.addLeftTile item: @div, priority: 50
