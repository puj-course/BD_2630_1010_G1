package repositorios;

import configuracion.ConexionBD;
import dao.SedeDao;
import entidades.Sede;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SedeDaoImpl implements SedeDao {

    @Override
    public List<Sede> obtenerTodasSedes() {
        List<Sede> lista = new ArrayList<>();
        String sql = "SELECT id_sede, id_edicion, pais FROM SEDE";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearSede(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener todas las sedes", e);
        }
        return lista;
    }


    @Override
    public Sede obtenerPorIdSede(int idSede) {
        String sql = "SELECT id_sede, id_edicion, pais FROM SEDE WHERE id_sede = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSede);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearSede(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener sede por ID", e);
        }
    }

    @Override
    public void guardarSede(Sede sede) {
        String sql = "INSERT INTO SEDE (id_sede, id_edicion, pais) VALUES (?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sede.getIdSede());
            ps.setInt(2, sede.getIdEdicion());
            ps.setString(3, sede.getPais());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al guardar sede", e);
        }
    }

    @Override
    public int actualizarSede(Sede sede) {
        String sql = "UPDATE SEDE SET id_edicion = ?, pais = ? WHERE id_sede = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sede.getIdEdicion());
            ps.setString(2, sede.getPais());
            ps.setInt(3, sede.getIdSede());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar sede", e);
        }
    }

    @Override
    public int eliminarSede(int idSede) {
        String sql = "DELETE FROM SEDE WHERE id_sede = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSede);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al eliminar sede", e);
        }
    }

    private Sede mapearSede(ResultSet rs) throws SQLException {
        return new Sede(
                rs.getInt("id_sede"),
                rs.getInt("id_edicion"),
                rs.getString("pais")
        );
    }
}