def theme():
    blk = "black"
    bf = "bold"
    #  actions performing in cyan
    performing="cyan"
    #  actions performed in green
    performed="green"
    #  actions taking an unknown time
    untimed="blue"

    return [
        [ "^  [a-zA-Z0-9]+", "white", "bold" ],	# word def. header
        # Example sentences
        [ r'"[^";]+";*' , blk, bf],	# regular
        [ r'"[^"]+$', blk, bf],		# multiline, head
        [ r'^[^";]+";', blk, bf],	# multiline, tail (+more)
        [ r'^[^"]+"(?= \[)', blk, bf],
        [ r'\[syn:[^\]]*\n\s+', "blue" ],	#
        [ r'\[ant: [^\]]+\]', "magenta" ],
        #[ '\[syn:[^\]]+$', "blue" ],
    ]
