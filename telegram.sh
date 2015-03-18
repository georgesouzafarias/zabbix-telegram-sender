#!/usr/bin/expect


#variable for destination.
#Tip, replace "spaces" for "_" on the names.
set TO "<Destination>"
#variable for message, from 3rd argument to latest argument.
set MSG [lrange $argv 2 end]
#variable for timeout
set timeout 20
#variable for pattern - it isn't working.
set PATTERN "<Pattern>"


proc TryConnection { } {
        expect {
                { -nocase $PATTERN { return true;} }
                timeout { return false }
         }
}

#Here's where the expect active the process
spawn telegram -W -k /opt/tg/tg-server.pub -c /etc/telegram-cli/config


#This is the conditional for test the telegram's connection.
if {[TryConnection] == true} {
        #Here the command that send the message.
        send "msg $TO $MSG\r"
        sleep 5

} else {
        set ANSWER false
        #Here, start the loop that is going to try the connection again.
        while { $ANSWER == false } {
                send "dialog_list\r"
                sleep 10
                expect PATTERN { set ANSWER true }
}
        #Here the command that send the message.
        send "msg $TO $MSG\r"

}


expect {
        timeout {send "safe_quit"; exit}

}
