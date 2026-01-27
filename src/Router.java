import com.sun.net.httpserver.HttpServer;
import handlers.HelloHandler;
import handlers.HostnameHandler;

public class Router {
    public static void setupRoutes(HttpServer server) {
        server.createContext("/", new HelloHandler());
        server.createContext("/hostname", new HostnameHandler());
    }
}
