
class CursorPositionView extends HTMLElement

   initialize: ->
      @classList.add('cursor-position', 'inline-block')
      @innerSpan = @ownerDocument.createElement('span')
      @appendChild(@innerSpan)

      @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem (activeItem) =>
         @subscribeToActiveTextEditor()
      @subscribeToActiveTextEditor()

   subscribeToActiveTextEditor: ->
      editor = atom.workspace.getActiveTextEditor()
      @updatePoint(editor)

      @cursorSubscription?.dispose()
      @cursorSubscription = editor?.onDidChangeCursorPosition ({cursor}) =>
         return unless cursor is editor?.getLastCursor()
         @updatePoint(editor)

   updatePoint: (editor) ->
      if editor
         @pointToPosition editor.getCursorBufferPosition(), editor.getBuffer().getText()
      else
         @innerSpan.textContent = ''

   pointToPosition: (point, text) ->
      bufferLine  = point.row
      desiredLine = 0
      position    = 0
      infinity = text.length
      while desiredLine != bufferLine && position < infinity
         if text[position] == '\n'
            desiredLine++
         position++
      @innerSpan.textContent = position + point.column

   destroy: ->
     @activeItemSubscription?.dispose()
     @cursorSubscription?.dispose()
     @updateSubscription?.dispose()

module.exports = document.registerElement('cursor-position',
                                          prototype: CursorPositionView.prototype,
                                          extends: 'div')
