package configuracion;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class Constantes {
    public static final String user;
    public static final String password;
    public static final String url_driver;

    static {
        Properties prop = new Properties();

        try (FileInputStream input = new FileInputStream("configuracion.properties")) {
            prop.load(input);

            user = prop.getProperty("db.user");
            password = prop.getProperty("db.password");
            url_driver = prop.getProperty("db.url");

        } catch (IOException e) {
            throw new RuntimeException("Error al cargar configuracion.properties", e);
        }
    }
}