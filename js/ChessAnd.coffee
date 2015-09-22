# Ben Scott # 2015-09-21 # coffee & chess #

# const
col = ['a','b','c','d','e','f','g']

inc = 9812 # king++ == queen, etc

base_board = [
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0]]

chess_pieces = [
	# white    # black
	"&#9812;", "&#9818;", # king
	"&#9813;", "&#9818;", # queen
	"&#9814;", "&#9820;", # rook
	"&#9815;", "&#9821;", # bishop
	"&#9816;", "&#9822;", # knight
	"&#9817;", "&#9823;"] # pawn

codespot_pieces = [
	# white    # black
	"&#9812;", "&#9818;", # king
	"&#9813;", "&#9818;", # queen
	"&#9814;", "&#9820;", # rook
	"&#9815;", "&#9821;", # bishop
	"&#9816;", "&#9822;", # knight
	"&#9817;", "&#9823;"] # pawn

move =
	n: 9812
	unicode_html: (n) -> "&#"+n+";"


validMove = (move) ->
	temp = move.split('-')
	if (temp.length!==2) return false;
	return validSquare(temp);

validSquare = (sq) -> sq.search(/^[a-h][1-8]$/)


	/[!kqrbnpKQRNBP1-8]/

