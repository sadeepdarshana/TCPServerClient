# TCPServerClient
A GUI TCP server and a client built into a single application. 

You can pass text messages between 2 machines using the application.

Created using Gtk+3.0 and Vala. Utilizes `SocketClient` and `SocketService` in `GIO`.

![screenshots](http://darshanasadeep.com/tcpss.png)

## Installation

#### Prerequisites :-

valac

libgtk-3-dev

#### Building and running

      git clone https://github.com/sadeepdarshana/TCPServerClient.git
      cd TCPServerClient
      valac ./tcpserverclient.vala --pkg gtk+-3.0
      ./tcpserverclient

## Usage

For sending messages or listen on the default port (5046) run the application using,

      ./tcpserverclient
The application will by default listen on port 5046. If you want to change the port to listen enter it as a command line parameter

      ./tcpserverclient 2514
      
will start the application with its server listening on port 2514.

#### Sending Messages

Enter remote IP or Domain name, enter remote port, message. Then send.

#### Listening for Messages

You don't have to do anything. The application will from the start be listening (and displaying) to the messages received on the chosen (or default=5046) port.

You could send messages to the localhost at the listening port to see the same message captured by the application.
