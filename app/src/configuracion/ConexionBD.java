package configuracion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                Constantes.url_driver,
                Constantes.user,
                Constantes.password
        );
    }
}

