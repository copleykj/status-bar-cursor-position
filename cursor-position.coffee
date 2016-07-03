
CursorPositionView = require './cursor-position-view'

module.exports = CursorPosition =

    activate: () ->
        @cursorPositionView = new CursorPositionView()
        @cursorPositionView.initialize()

    deactivate: ->
        @cursorPositionView.destroy()
        @statusBarTile?.destroy()

    consumeStatusBar: (statusBar) ->
        @statusBar = statusBar
        @statusBarTile = @statusBar.addLeftTile
            item: @cursorPositionView, priority: 50
