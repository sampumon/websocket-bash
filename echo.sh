#!/bin/bash
# A websocket echo server for "BASH"
# Usage: ncat -l[k] -p 1337 -e echo.sh

# rfc 6455 websocket version
our_ver=13

echoerr() {
	echo "$@" >&2
}

debug_input() {
	while read; do
		echo -n $REPLY | tr -d \\r | hexdump -C >&2
	done
}

# note the removal of HTTP-specified \r from CRLF
# well, can't do it inside tr pipe before while, because that breaks break
while read ; do
	# echo $REPLY | tr -d \\r | hexdump -C >&2
	# read the UN-CR-FIED stuff again
	read a b crap <<< $(echo $REPLY | tr -d \\r)
	case $a in
		"GET")
			echoerr "GET $b"
			reg_get=$b
			;;
		"Upgrade:")
			echoerr GOT UPGRADED: $b
			[ "$b" == "websocket" ] && ws=true
			;;
		"Sec-WebSocket-Key:")
			echoerr GOT KEY: $b
			ws_key=$b
			;;
		"Sec-WebSocket-Version:")
			echoerr GOT VERSION: $b
			ws_ver=$b
			[[ $ws_ver < $our_ver ]] && echoerr Warning: dealing with lesser version than ours: $ws_ver \< $our_ver
			;;
		# end-of-headers
		"") break 2;;
	esac
done

# echoerr WE GOT: ws $ws, key $ws_key, ver $ws_ver

ws_accept=$(echo -n ${ws_key}258EAFA5-E914-47DA-95CA-C5AB0DC85B11 | shasum | cut -d " " -f 1 | xxd -p -r | base64)

# REQUEST TEMPLATE:
# GET / HTTP/1.1
# Upgrade: websocket
# Connection: Upgrade
# Host: localhost:1337
# Origin: null
# Sec-WebSocket-Key: Li/PfiIT1PY/KxRB/z5K2Q==
# Sec-WebSocket-Version: 13

# notice the LF -> CRLF conversion here
sed $(echo -e 's/$/\r/') <<TAC
HTTP/1.1 101 Web Socket Protocol Handshake
Upgrade: websocket
Connection: Upgrade
Server: Sampumon MEGABASH
Sec-WebSocket-Accept: $ws_accept
Sec-WebSocket-Version: 13

TAC
# TODO: are these necessary?
# Access-Control-Allow-Origin: null
# Access-Control-Allow-Credentials: true
# Access-Control-Allow-Headers: content-type

# echo back everything
cat
