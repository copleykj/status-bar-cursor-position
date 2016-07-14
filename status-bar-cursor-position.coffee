
module.exports = CursorPosition =

   activate: () ->
      @div = document.createElement('div')
      @div.style.display = 'inline-block'
      @subscribeToActiveTextEditor()
      @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem (activeItem) =>
         @subscribeToActiveTextEditor()

   subscribeToActiveTextEditor: ->
      if editor = atom.workspace.getActiveTextEditor()
         @lines = editor.buffer.lines
         @lineEndings = editor.buffer.lineEndings
         @update editor
         @cursorSubscription = editor.onDidChangeCursorPosition () =>
            @update editor
      else
         @cursorSubscription?.dispose()
         @div.textContent = ''

   update: (editor) ->
      {row, column} = editor.getCursorBufferPosition()
      @div.textContent = @lines.slice(0, row).join('').length +
                         @lineEndings.slice(0, row).join('').length +
                         column

   deactivate: ->
      @activeItemSubscription?.dispose()
      @cursorSubscription?.dispose()
      @statusBarTile?.destroy()

   consumeStatusBar: (statusBar) ->
      @statusBarTile = statusBar.addLeftTile item: @div, priority: 50