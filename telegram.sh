#!/usr/bin/expect



set TO "<Destination>"
set MSG [lrange $argv 1 end]
set timeout 20
set PATTERN "<Pattern>"

puts PATTERN


proc TryConnection { } {
        expect {
                { -nocase $PATTERN { return true;} }
                timeout { return false }
         }
}


spawn telegram -W -k /opt/tg/tg-server.pub -c /etc/telegram-cli/config

if {[TryConnection] == true} {
        send "msg $TO $MSG\r"
        sleep 5

} else {
        set ANSWER false
        while { $ANSWER == false } {
                send "dialog_list\r"
                sleep 10
                expect PATTERN { set ANSWER true }
}
        send "msg $TO $MSG\r"

}


expect {
        timeout {send "safe_quit"; exit}

}


