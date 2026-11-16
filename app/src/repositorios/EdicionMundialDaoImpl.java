package repositorios;

import configuracion.ConexionBD;
import dao.EdicionMundialDao;
import entidades.EdicionMundial;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EdicionMundialDaoImpl implements EdicionMundialDao {

    @Override
    public List<EdicionMundial> obtenerTodasEdiciones() {
        List<EdicionMundial> lista = new ArrayList<>();
        String sql = "SELECT id_edicion, anio, nombre, fecha_inicio, fecha_fin FROM EDICION_MUNDIAL";

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                EdicionMundial e = new EdicionMundial(
                        rs.getInt("id_edicion"),
                        rs.getInt("anio"),
                        rs.getString("nombre"),
                        rs.getDate("fecha_inicio"),
                        rs.getDate("fecha_fin")
                );
                lista.add(e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al consultar ediciones del mundial", e);
        }
        return lista;
    }

    @Override
    public void guardarEdicion(EdicionMundial edicion) {
        StringBuilder sql = new StringBuilder("INSERT INTO EDICION_MUNDIAL (id_edicion, anio, nombre, fecha_inicio, fecha_fin) VALUES (?, ?, ?, ?, ?)");
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, edicion.getIdEdicion());
            ps.setInt(2, edicion.getAnio());
            ps.setString(3, edicion.getNombre());
            ps.setDate(4, edicion.getFechaInicio());
            ps.setDate(5, edicion.getFechaFin());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al guardarEdicion edición del mundial", e);
        }
    }

    // Implementar obtenerPorIdEdicion, actualizarEdicion y eliminarEdicion siguiendo la misma estructura
    @Override
    public EdicionMundial obtenerPorIdEdicion(int idEdicion) {
        String sql = "SELECT id_edicion, anio, nombre, fecha_inicio, fecha_fin FROM EDICION_MUNDIAL WHERE id_edicion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
             ps.setInt(1,idEdicion);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new EdicionMundial(
                            rs.getInt("id_edicion"),
                            rs.getInt("anio"),
                            rs.getString("nombre"),
                            rs.getDate("fecha_inicio"),
                            rs.getDate("fecha_fin")
                    );
                } else {
                    return null;
                }
            }
        }catch (SQLException e){
            throw new RuntimeException("Error de conexion", e);
        }
    }


    @Override
    public int actualizarEdicion(EdicionMundial edicion) {
        String sql = "UPDATE EDICION_MUNDIAL SET anio = ?, nombre = ?, fecha_inicio = ?, fecha_fin = ? WHERE id_edicion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
             ps.setInt(1, edicion.getAnio());
             ps.setString(2, edicion.getNombre());
             ps.setDate(3, edicion.getFechaInicio());
             ps.setDate(4, edicion.getFechaFin());
             ps.setInt(5, edicion.getIdEdicion());
             int n = ps.executeUpdate();
             return n;
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizarEdicion", e);
        }
    }

    @Override public int eliminarEdicion(int idEdicion) {
        String sql = "DELETE FROM EDICION_MUNDIAL where id_edicion = ?";
        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, idEdicion);
            int n = ps.executeUpdate();
            return n;
        }catch (SQLException e){
           throw new RuntimeException("Error al eliminarEdicion", e);
        }
    }

}

