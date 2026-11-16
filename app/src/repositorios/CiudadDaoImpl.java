package repositorios;
import configuracion.ConexionBD;
import dao.CiudadDao;
import entidades.Ciudad;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CiudadDaoImpl implements CiudadDao {

    @Override
    public List<Ciudad>  obtenerTodasCiudad() {
        List<Ciudad> lista = new ArrayList<>();
        String sql = "SELECT id_ciudad, id_sede, nombre FROM CIUDAD";

        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()){

            while (rs.next()) {
                Ciudad c = new Ciudad(
                        rs.getInt("id_ciudad"),
                        rs.getInt("id_sede"),
                        rs.getString("nombre")

                );
                lista.add(c);
            }

        }catch(SQLException e) {
            throw new RuntimeException("Error al consultar ciudades", e);
        }
        return lista;
    }

    @Override
    public Ciudad obtenerPorIdCiudad(int idCiudad) {
        String sql = "SELECT id_ciudad, id_sede, nombre FROM ciudad WHERE id_ciudad = ?";
        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, idCiudad);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Ciudad(
                            rs.getInt("id_ciudad"),
                            rs.getInt("id_sede"),
                            rs.getString("nombre")
                    );
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al consultar Ciudad por id", e);}
    }

    @Override
    public void guardarCiudad(Ciudad c) {

        String sql = "INSERT INTO CIUDAD (id_ciudad, id_sede, nombre) VALUES (?, ?, ?)";

        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){

            ps.setInt(1, c.getIdCiudad());
            ps.setInt(2, c.getIdSede());
            ps.setString(3, c.getNombre());
            ps.executeUpdate();

        }catch(SQLException e) {
            throw new RuntimeException("Error al guardar Ciudad", e);
        }
    }

    @Override
    public int actualizarCiudad(Ciudad c){
        String sql = "UPDATE CIUDAD SET id_sede = ?, nombre = ? WHERE id_ciudad = ?";
        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){

            ps.setInt(1, c.getIdSede());
            ps.setString(2, c.getNombre());
            ps.setInt(3, c.getIdCiudad());
            int n = ps.executeUpdate();
            return n;

        }catch(SQLException e) {
            throw new RuntimeException("Error al actualizar Ciudad", e);
        }
    }

    @Override
    public int eliminarCiudad(int idCiudad){
        String sql = "DELETE FROM CIUDAD WHERE id_ciudad = ?";

        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){

            ps.setInt(1, idCiudad);
            int n = ps.executeUpdate();
            return n;

        }catch(SQLException e) {
            throw new RuntimeException("Error al eliminar Ciudad", e);
        }
    }

}
