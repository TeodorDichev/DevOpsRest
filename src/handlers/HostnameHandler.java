package handlers;

import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.OutputStream;
import java.net.InetAddress;

public class HostnameHandler implements HttpHandler {
    public void handle(HttpExchange exchange) {
        try {
            String hostname = InetAddress.getLocalHost().getHostName();
            exchange.sendResponseHeaders(200, hostname.getBytes().length);
            OutputStream os = exchange.getResponseBody();
            os.write(hostname.getBytes());
            os.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
