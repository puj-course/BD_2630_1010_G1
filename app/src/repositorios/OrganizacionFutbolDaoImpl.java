package repositorios;

import configuracion.ConexionBD;
import dao.OrganizacionFutbolDao;
import entidades.OrganizacionFutbol;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrganizacionFutbolDaoImpl implements OrganizacionFutbolDao {

    @Override
    public List<OrganizacionFutbol> obtenerOrganizaciones() {
        List<OrganizacionFutbol> lista = new ArrayList<>();
        String sql = "SELECT id_organizacion, nombre, tipo, pais, id_organizacion_padre FROM ORGANIZACIONES_FUTBOL";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearOrganizacion(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener organizaciones de fútbol", e);
        }
        return lista;
    }



    @Override
    public OrganizacionFutbol obtenerOrganizacionPorId(int idOrganizacion) {
        String sql = "SELECT id_organizacion, nombre, tipo, pais, id_organizacion_padre FROM ORGANIZACIONES_FUTBOL WHERE id_organizacion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idOrganizacion);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearOrganizacion(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener organización por ID", e);
        }
    }

    @Override
    public void guardarOrganizacion(OrganizacionFutbol org) {
        String sql = "INSERT INTO ORGANIZACIONES_FUTBOL (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, org.getIdOrganizacion());
            ps.setString(2, org.getNombre());
            ps.setString(3, org.getTipo());
            ps.setString(4, org.getPais());
            if (org.getIdOrganizacionPadre() != null) {
                ps.setInt(5, org.getIdOrganizacionPadre());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al guardar organización de fútbol", e);
        }
    }

    @Override
    public int actualizarOrganizacion(OrganizacionFutbol org) {
        String sql = "UPDATE ORGANIZACIONES_FUTBOL SET nombre = ?, tipo = ?, pais = ?, id_organizacion_padre = ? WHERE id_organizacion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, org.getNombre());
            ps.setString(2, org.getTipo());
            ps.setString(3, org.getPais());
            if (org.getIdOrganizacionPadre() != null) {
                ps.setInt(4, org.getIdOrganizacionPadre());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setInt(5, org.getIdOrganizacion());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar organización de fútbol", e);
        }
    }

    @Override
    public int eliminarOrganizacion(int idOrganizacion) {
        String sql = "DELETE FROM ORGANIZACIONES_FUTBOL WHERE id_organizacion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idOrganizacion);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al eliminar organización de fútbol", e);
        }
    }

    private OrganizacionFutbol mapearOrganizacion(ResultSet rs) throws SQLException {
        return new OrganizacionFutbol(
                rs.getInt("id_organizacion"),
                rs.getString("nombre"),
                rs.getString("tipo"),
                rs.getString("pais"),
                rs.getObject("id_organizacion_padre", Integer.class)
        );
    }
}

