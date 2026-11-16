package repositorios;

import configuracion.ConexionBD;
import dao.EstadioDao;
import entidades.Estadio;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EstadioDaoImpl implements EstadioDao {

    @Override
    public List<Estadio> obtenerTodosEstadio() {
        List<Estadio> lista = new ArrayList<>();
        String sql = "SELECT id_estadio, id_ciudad, nombre, capacidad FROM ESTADIO";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearEstadio(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener todos los estadios", e);
        }
        return lista;
    }

    @Override
    public Estadio obtenerPorIdEstadio(int idEstadio) {
        String sql = "SELECT id_estadio, id_ciudad, nombre, capacidad FROM ESTADIO WHERE id_estadio = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idEstadio);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearEstadio(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener estadio por ID", e);
        }
    }

    @Override
    public void guardarEstadio(Estadio estadio) {
        String sql = "INSERT INTO ESTADIO (id_estadio, id_ciudad, nombre, capacidad) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, estadio.getIdEstadio());
            ps.setInt(2, estadio.getIdCiudad());
            ps.setString(3, estadio.getNombre());
            ps.setInt(4, estadio.getCapacidad());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al guardar estadio", e);
        }
    }

    @Override
    public int actualizarEstadio(Estadio estadio) {
        String sql = "UPDATE ESTADIO SET id_ciudad = ?, nombre = ?, capacidad = ? WHERE id_estadio = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, estadio.getIdCiudad());
            ps.setString(2, estadio.getNombre());
            ps.setInt(3, estadio.getCapacidad());
            ps.setInt(4, estadio.getIdEstadio());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar estadio", e);
        }
    }

    @Override
    public int eliminarEstadio(int idEstadio) {
        String sql = "DELETE FROM ESTADIO WHERE id_estadio = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idEstadio);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al eliminar estadio", e);
        }
    }

    private Estadio mapearEstadio(ResultSet rs) throws SQLException {
        return new Estadio(
                rs.getInt("id_estadio"),
                rs.getInt("id_ciudad"),
                rs.getString("nombre"),
                rs.getInt("capacidad")
        );
    }
}
