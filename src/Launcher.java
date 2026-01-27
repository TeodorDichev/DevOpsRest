import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;

public class Launcher {
    /** BUILD
     * * docker build -t devops-demo .
     * * docker run -p 8080:80 devops-demo
     * TEST
     * * In the browser on http://localhost:8080/
     * * In the console with: curl http://localhost:8080/
     * **/
    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", 80), 0);
        Router.setupRoutes(server);
        server.start();
        System.out.println("Server started on port 8080");
    }
}
