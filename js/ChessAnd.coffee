---
---

# Ben Scott # 2015-09-21 # coffee & chess #

# const

new_board = ->
	[[0xC,0xD,0xC,0xA,0xB,0xC,0xD,0xC]
	 [0xF,0xF,0xF,0xF,0xF,0xF,0xF,0xF]
	 [0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
	 [0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
	 [0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
	 [0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
	 [0x9,0x9,0x9,0x9,0x9,0x9,0x9,0x9]
	 [0x6,0x7,0x8,0x4,0x5,0x8,0x7,0x6]]

pieces = [
	# white    # black
	"&#9634;", "&#9638;"  # square
	"&#9812;", "&#9818;"  # king
	"&#9813;", "&#9818;"  # queen
	"&#9814;", "&#9820;"  # rook
	"&#9815;", "&#9821;"  # bishop
	"&#9816;", "&#9822;"  # knight
	"&#9817;", "&#9823;"] # pawn


class Board
	constructor: (@grid=new_board()) ->
		@base = [
			[0,1,0,1,0,1,0,1]
			[1,0,1,0,1,0,1,0]
			[0,1,0,1,0,1,0,1]
			[1,0,1,0,1,0,1,0]
			[0,1,0,1,0,1,0,1]
			[1,0,1,0,1,0,1,0]
			[0,1,0,1,0,1,0,1]
			[1,0,1,0,1,0,1,0]]
		for i in @base
			for j in i
				j = new Square(j==1)

	validSquare = (sq) -> sq.search(/^[a-h][1-8]$/)

	# moves e.g, "e2-e4", "f6-d5"
	validMove = (move) ->
		temp = move.split('-')
		return (temp.length==2 && validSquare(temp))

	printTable = -> @printTable(@grid)

	@printTable: (board) ->
		document.write("<br><table style=\"width: 30%\">")
		for i in overlayBoard(board)
			document.write("<tr>")
			for j in i
				document.write("<td> "+j+"</td>")
			document.write("</tr>")
		document.write("</table><br>")

	print: -> @print(@grid)

	@print: (board) ->
		for i in overlayBoard(board)
			document.write("<br>")
			for j in i
				document.write(j)

class Square
	constructor: (@isWhite=true) ->
		@n = if @isWhite then 9634 else 9635

	html: -> "&#"+@n+";"
	piece: null

class Piece
	constructor: (@n=0x9, xy=[0,0], @isWhite=true) ->

	html: -> "&#"+(9808+@n)+";"
	unicode: -> "U+"+(2650+@n)
	move: -> true

class Pawn extends Piece
	constructor: (@xy=[0,0], @isWhite=true) ->
		@n = if @isWhite then 0x9 else 0xF

	move: -> false

class Knight extends Piece
	constructor: (@xy=[0,0], @isWhite=true) ->
		@n = if @isWhite then 0x7 else 0xD

	move: -> true

move =
	n: 0x9 # white pawn default
	captured: false
	html: (n) -> "&#"+(9808+n)+";"
	unicode: (n) -> "U+"+(2650+n)
	print: (n) ->
		if (n==9635)
			return pieces[1]
		else if (n==9634)
			return pieces[0]
		return move.html(n)

overlayBoard = (board) ->
	[w, b] = [pieces[0], pieces[1]]
	base = [
		[b,w,b,w,b,w,b,w]
		[w,b,w,b,w,b,w,b]
		[b,w,b,w,b,w,b,w]
		[w,b,w,b,w,b,w,b]
		[b,w,b,w,b,w,b,w]
		[w,b,w,b,w,b,w,b]
		[b,w,b,w,b,w,b,w]
		[w,b,w,b,w,b,w,b]]
	base_i = 0
	for i in board
		base_j = 0
		for j in i
			if (j!=0x0)
				base[base_i][base_j] = " "+move.html(j)
			base_j++
		base_i++
	return base

Board.printTable(new_board())

entry = document.getElementsByClassName("entry")[0]

sendMove = (event) ->
	entry.appendChild(document.createTextNode(input.value))
	input.value = ""

appendParagraph = (s) ->
	p = document.createElement "P"
	p.appendChild(document.createTextNode(s))
	entry.appendChild(p)

init_ui = ->
	button = document.createElement "BUTTON"
	button.onclick = sendMove
	button.appendChild(document.createTextNode("Input: "))
	entry.appendChild(button)
	input = document.createElement "INPUT"
	input.setAttribute("type","text")
	entry.appendChild(input)

init_ui()

