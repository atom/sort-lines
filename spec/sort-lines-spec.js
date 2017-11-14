describe('sorting lines', () => {
  let activationPromise, editor, editorView

  const runCommand = (commandName, callback) => {
    atom.commands.dispatch(editorView, commandName)
    waitsForPromise(() => activationPromise)
    runs(callback)
  }

  const sortLines =
    (callback) => runCommand('sort-lines:sort', callback)

  const sortLinesReversed =
    (callback) => runCommand('sort-lines:reverse-sort', callback)

  const uniqueLines =
    (callback) => runCommand('sort-lines:unique', callback)

  const sortLineCaseInsensitive =
    (callback) => runCommand('sort-lines:case-insensitive-sort', callback)

  const sortLinesNatural =
    (callback) => runCommand('sort-lines:natural', callback)

  const sortLinesByLength =
      (callback) => runCommand('sort-lines:by-length', callback)

  const sortLinesByLengthReversed =
      (callback) => runCommand('sort-lines:by-length-reversed', callback)

  const shuffleLines =
    (callback) => runCommand('sort-lines:shuffle', callback)

  beforeEach(() => {
    waitsForPromise(() => atom.workspace.open())

    runs(() => {
      editor = atom.workspace.getActiveTextEditor()
      editorView = atom.views.getView(editor)
      activationPromise = atom.packages.activatePackage('sort-lines')
    })
  })

  describe('when no lines are selected', () => {
    it('sorts all lines', () => {
      editor.setText(
        'Hydrogen \n' +
        'Helium   \n' +
        'Lithium    '
      )
      editor.setCursorBufferPosition([0, 0])

      sortLines(() =>
        expect(editor.getText()).toBe(
          'Helium   \n' +
          'Hydrogen \n' +
          'Lithium    '
        )
      )
    })

    it('sorts all lines, ignoring the trailing new line', () => {
      editor.setText(
        'Hydrogen \n' +
        'Helium   \n' +
        'Lithium  \n'
      )
      editor.setCursorBufferPosition([0, 0])

      sortLines(() =>
        expect(editor.getText()).toBe(
          'Helium   \n' +
          'Hydrogen \n' +
          'Lithium  \n'
        )
      )
    })

    it('gracefully handles attempt to sort an empty editor', () => {
      editor.setText('')
      editor.setCursorBufferPosition([0, 0])

      sortLines(() => expect(editor.getText()).toBe(''))
    })
  })

  describe('when entire lines are selected', () =>
    it('sorts the selected lines', () => {
      editor.setText(
        'Hydrogen  \n' +
        'Helium    \n' +
        'Lithium   \n' +
        'Beryllium \n' +
        'Boron     \n'
      )
      editor.setSelectedBufferRange([[1, 0], [4, 0]])

      sortLines(() =>
        expect(editor.getText()).toBe(
          'Hydrogen  \n' +
          'Beryllium \n' +
          'Helium    \n' +
          'Lithium   \n' +
          'Boron     \n'
        )
      )
    })
  )

  describe('when partial lines are selected', () =>
    it('sorts the selected lines', () => {
      editor.setText(
        'Hydrogen  \n' +
        'Helium    \n' +
        'Lithium   \n' +
        'Beryllium \n' +
        'Boron     \n'
      )
      editor.setSelectedBufferRange([[1, 3], [3, 2]])

      sortLines(() =>
        expect(editor.getText()).toBe(
          'Hydrogen  \n' +
          'Beryllium \n' +
          'Helium    \n' +
          'Lithium   \n' +
          'Boron     \n'
        )
      )
    })
  )

  describe('when there are multiple selection ranges', () =>
    it('sorts the lines in each selection range', () => {
      editor.setText(
        'Hydrogen                \n' +
        'Helium    # selection 1 \n' +
        'Beryllium # selection 1 \n' +
        'Carbon                  \n' +
        'Fluorine  # selection 2 \n' +
        'Aluminum  # selection 2 \n' +
        'Gallium                 \n' +
        'Europium                \n'
      )
      editor.addSelectionForBufferRange([[1, 0], [3, 0]])
      editor.addSelectionForBufferRange([[4, 0], [6, 0]])

      sortLines(() =>
        expect(editor.getText()).toBe(
          'Hydrogen                \n' +
          'Beryllium # selection 1 \n' +
          'Helium    # selection 1 \n' +
          'Carbon                  \n' +
          'Aluminum  # selection 2 \n' +
          'Fluorine  # selection 2 \n' +
          'Gallium                 \n' +
          'Europium                \n'
        )
      )
    })
  )

  describe('reversed sorting', () =>
    it('sorts all lines in reverse order', () => {
      editor.setText(
        'Hydrogen \n' +
        'Helium   \n' +
        'Lithium  \n'
      )

      sortLinesReversed(() =>
        expect(editor.getText()).toBe(
          'Lithium  \n' +
          'Hydrogen \n' +
          'Helium   \n'
        )
      )
    })
  )

  describe('uniqueing', () => {
    it('uniques all lines but does not change order', () => {
      editor.setText(
        'Hydrogen \n' +
        'Hydrogen \n' +
        'Helium   \n' +
        'Lithium  \n' +
        'Hydrogen \n' +
        'Hydrogen \n' +
        'Helium   \n' +
        'Lithium  \n' +
        'Hydrogen \n' +
        'Hydrogen \n' +
        'Helium   \n' +
        'Lithium  \n' +
        'Hydrogen \n' +
        'Hydrogen \n' +
        'Helium   \n' +
        'Lithium  \n'
      )

      uniqueLines(() =>
        expect(editor.getText()).toBe(
          'Hydrogen \n' +
          'Helium   \n' +
          'Lithium  \n'
        )
      )
    })

    it('uniques all lines using CRLF line-endings', () => {
      editor.setText(
        'Hydrogen\r\n' +
        'Hydrogen\r\n' +
        'Helium\r\n' +
        'Lithium\r\n' +
        'Hydrogen\r\n' +
        'Hydrogen\r\n' +
        'Helium\r\n' +
        'Lithium\r\n' +
        'Hydrogen\r\n' +
        'Hydrogen\r\n' +
        'Helium\r\n' +
        'Lithium\r\n' +
        'Hydrogen\r\n' +
        'Hydrogen\r\n' +
        'Helium\r\n' +
        'Lithium\r\n'
      )

      uniqueLines(() =>
        expect(editor.getText()).toBe(
          'Hydrogen\r\n' +
          'Helium\r\n' +
          'Lithium\r\n'
        )
      )
    })
  })

  describe('case-sensitive sorting (the default)', () =>
    it('sorts all lines, case sensitive', () => {
      editor.setText(
        'helium   \n' +
        'Helium   \n' +
        'helium   \n'
      )

      sortLines(() =>
        expect(editor.getText()).toBe(
          'helium   \n' +
          'helium   \n' +
          'Helium   \n'
        )
      )
    })
  )

  describe('case-insensitive sorting', () =>
    it('sorts all lines, ignoring case', () => {
      editor.setText(
        'Hydrogen \n' +
        'lithium  \n' +
        'helium   \n' +
        'Helium   \n' +
        'helium   \n' +
        'Lithium  \n'
      )

      sortLineCaseInsensitive(() =>
        expect(editor.getText()).toBe(
          'helium   \n' +
          'Helium   \n' +
          'helium   \n' +
          'Hydrogen \n' +
          'lithium  \n' +
          'Lithium  \n'
        )
      )
    })
  )

  describe('natural sorting', () => {
    it('orders by leading numerals', () => {
      editor.setText(
        '4a  \n' +
        '1a  \n' +
        '2a  \n' +
        '12a \n' +
        '3a  \n' +
        '0a  \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '0a  \n' +
          '1a  \n' +
          '2a  \n' +
          '3a  \n' +
          '4a  \n' +
          '12a \n'
        )
      )
    })

    it('orders by word', () => {
      editor.setText(
        '1Hydrogen1  \n' +
        '1Beryllium1 \n' +
        '1Carbon1    \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '1Beryllium1 \n' +
          '1Carbon1    \n' +
          '1Hydrogen1  \n'
        )
      )
    })

    it('orders by trailing numeral', () => {
      editor.setText(
        'a4  \n' +
        'a0  \n' +
        'a12 \n' +
        'a1  \n' +
        'a2  \n' +
        'a3  \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          'a0  \n' +
          'a1  \n' +
          'a2  \n' +
          'a3  \n' +
          'a4  \n' +
          'a12 \n'
        )
      )
    })

    it('orders by leading numeral before word', () => {
      editor.setText(
        '4b \n' +
        '3a \n' +
        '2b \n' +
        '1a \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '1a \n' +
          '2b \n' +
          '3a \n' +
          '4b \n'
        )
      )
    })

    it('orders by word before trailing number', () => {
      editor.setText(
        'c2 \n' +
        'a4 \n' +
        'd1 \n' +
        'b3 \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          'a4 \n' +
          'b3 \n' +
          'c2 \n' +
          'd1 \n'
        )
      )
    })

    it('properly handles leading zeros', () => {
      editor.setText(
        'a01  \n' +
        'a001 \n' +
        'a003 \n' +
        'a002 \n' +
        'a02  \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          'a001 \n' +
          'a002 \n' +
          'a003 \n' +
          'a01  \n' +
          'a02  \n'
        )
      )
    })

    it('properly handles simple numerics', () => {
      editor.setText(
        '10 \n' +
        '9  \n' +
        '2  \n' +
        '1  \n' +
        '4  \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '1  \n' +
          '2  \n' +
          '4  \n' +
          '9  \n' +
          '10 \n'
        )
      )
    })

    it('properly handles floats', () => {
      editor.setText(
        '10.0401   \n' +
        '10.022    \n' +
        '10.042    \n' +
        '10.021999 \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '10.021999 \n' +
          '10.022    \n' +
          '10.0401   \n' +
          '10.042    \n'
        )
      )
    })

    it('properly handles float & decimal notation', () => {
      editor.setText(
        '10.04f  \n' +
        '10.039F \n' +
        '10.038d \n' +
        '10.037D \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
        '10.037D \n' +
        '10.038d \n' +
        '10.039F \n' +
        '10.04f  \n'
        )
      )
    })

    it('properly handles scientific notation', () => {
      editor.setText(
        '1.528535048e5 \n' +
        '1.528535047e7 \n' +
        '1.528535049e3 \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '1.528535049e3 \n' +
          '1.528535048e5 \n' +
          '1.528535047e7 \n'
        )
      )
    })

    it('properly handles ip addresses', () => {
      editor.setText(
        '192.168.0.100 \n' +
        '192.168.0.1   \n' +
        '192.168.1.1   \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '192.168.0.1   \n' +
          '192.168.0.100 \n' +
          '192.168.1.1   \n'
        )
      )
    })

    it('properly handles filenames', () => {
      editor.setText(
        'car.mov             \n' +
        '01alpha.sgi         \n' +
        '001alpha.sgi        \n' +
        'my.string_41299.tif \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '001alpha.sgi        \n' +
          '01alpha.sgi         \n' +
          'car.mov             \n' +
          'my.string_41299.tif \n'
        )
      )
    })

    it('properly handles dates', () => {
      editor.setText(
        '10/12/2008 \n' +
        '10/11/2008 \n' +
        '10/11/2007 \n' +
        '10/12/2007 \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '10/11/2007 \n' +
          '10/12/2007 \n' +
          '10/11/2008 \n' +
          '10/12/2008 \n'
        )
      )
    })

    it('properly handles money', () => {
      editor.setText(
        '$10002.00 \n' +
        '$10001.02 \n' +
        '$10001.01 \n'
      )

      sortLinesNatural(() =>
        expect(editor.getText()).toBe(
          '$10001.01 \n' +
          '$10001.02 \n' +
          '$10002.00 \n'
        )
      )
    })
  })

  describe('sorting by length', () => {
    it('sorts the lines by length', () => {
      editor.setText(
        'Hydrogen\n' +
        'Helium\n' +
        'Lithium\n' +
        'Beryllium\n' +
        'Boron\n'
      )

      sortLinesByLength(() =>
        expect(editor.getText()).toBe(
          'Boron\n' +
          'Helium\n' +
          'Lithium\n' +
          'Hydrogen\n' +
          'Beryllium\n'
        )
      )
    })
  })

  describe('sorting by length reverse', () => {
    it('sorts the lines by length in reverse order', () => {
      editor.setText(
        'Hydrogen\n' +
        'Helium\n' +
        'Lithium\n' +
        'Beryllium\n' +
        'Boron\n'
      )

      sortLinesByLengthReversed(() =>
        expect(editor.getText()).toBe(
          'Beryllium\n' +
          'Hydrogen\n' +
          'Lithium\n' +
          'Helium\n' +
          'Boron\n'
        )
      )
    })
  })

  describe('shuffling', () => {
    it('shuffle lines', () => {
      const originalText =
        'Beryllium \n' +
        'Boron     \n' +
        'Helium    \n' +
        'Hydrogen  \n' +
        'Lithium   \n'

      editor.setText(originalText)

      shuffleLines(() => {
        const shuffledText = editor.getText()
        console.log(originalText);
        console.log(shuffledText);
        expect(shuffledText.split('\n').length).toEqual(originalText.split('\n').length)
        expect(shuffledText).toNotBe(originalText)
      })
    })
  })
})
