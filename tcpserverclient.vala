using Gtk;


delegate void displayMessage (string msg);

private static displayMessage guiAppDisplayMessage;

private int listenPort = 5046;
private Label listenPortLabel;



public class GuiApp : Gtk.Application {


	public string host = "";

	private Entry sendText;
	private Entry receiveText;
	private Entry domainText;
	private Entry portText;
	public GuiApp () {
		Object (application_id: "org.sadeep.tcpserverclient");
		guiAppDisplayMessage = displayMsg;
	}

	public override void activate () {



		Builder builder = new Builder();
		builder.add_from_file ("tcpserverclient.ui");
		var window = builder.get_object ("mainwindow") as ApplicationWindow;
		var sendButton = builder.get_object ("sendbutton") as Button;
		sendText = builder.get_object ("sendtext") as Entry;
		receiveText = builder.get_object ("receivetext") as Entry;
		domainText = builder.get_object ("domaintext") as Entry;
		portText = builder.get_object ("porttext") as Entry;
		listenPortLabel = builder.get_object ("listenportlabel") as Label;


		listenPortLabel.set_label("Listening to port "+listenPort.to_string()+" .....");

		sendButton.clicked.connect(send);

		this.add_window (window);
		window.show ();
	}

	private void send(){
		stdout.printf("initiating...");

		host = domainText.get_text();

		var resolver = Resolver.get_default ();
        var addresses = resolver.lookup_by_name (host, null);
		var address = addresses.nth_data (0);
		

        var client = new SocketClient ();
		var conn = client.connect (new InetSocketAddress (address, 0+int.parse(portText.get_text())));
		

        var message = sendText.text;
        conn.output_stream.write (message.data);
		print ("Wrote request\n");
		
	}


	public void displayMsg(string msg){
		receiveText.set_text (msg);
		return;
	}
}


void server(){

    try {
        var service = new SocketService ();
        service.add_inet_port (0+listenPort, null);
        service.start ();
        while (true) {
            var conn = service.accept (null);
            process_request (conn.input_stream, conn.output_stream);
        }
    } catch (Error e) {
        stderr.printf ("%s\n", e.message);
    }
    return;
}
void process_request (InputStream input, OutputStream output) throws Error {
    var data_in = new DataInputStream (input);
	string line;
	string msg = "";
    while ((line = data_in.read_line (null)) != null) {
		line = line.strip();
		msg += line;
        if (line == "") break;
	}
	print(msg);
	guiAppDisplayMessage(msg);
}


class Main : GLib.Object {

    public static int main(string[] args) {
		
		listenPort = 0;
		try{
			if(args.length>=2)listenPort = int.parse(args[1]);
		}
		catch(Error e){
			listenPort = 0;
		}

		if(listenPort == 0)listenPort = 5046;


		Thread.create<void> (server, true);
        new GuiApp().run();
		
		return 0;
    }
}