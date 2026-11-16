package repositorios;

import configuracion.ConexionBD;
import dao.VinculacionSeleccionDao;
import entidades.VinculacionSeleccion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VinculacionSeleccionDaoImpl implements VinculacionSeleccionDao {

    @Override
    public List<VinculacionSeleccion> obtenerTodas() {
        List<VinculacionSeleccion> lista = new ArrayList<>();
        String sql = "SELECT id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club FROM VINCULACION_SELECCION";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearVinculacion(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener todas las vinculaciones", e);
        }
        return lista;
    }

    @Override
    public List<VinculacionSeleccion> obtenerPorSeleccion(int idSeleccion) {
        List<VinculacionSeleccion> lista = new ArrayList<>();
        String sql = "SELECT id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club FROM VINCULACION_SELECCION WHERE id_seleccion = ? ORDER BY dorsal";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSeleccion);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearVinculacion(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener plantel por selección", e);
        }
        return lista;
    }

    @Override
    public VinculacionSeleccion obtenerPorId(int idVinculacion) {
        String sql = "SELECT id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club FROM VINCULACION_SELECCION WHERE id_vinculacion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVinculacion);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearVinculacion(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener vinculación por ID", e);
        }
    }

    @Override
    public void guardar(VinculacionSeleccion v) {
        String sql = "INSERT INTO VINCULACION_SELECCION (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, v.getIdVinculacion());
            ps.setInt(2, v.getIdPersona());
            ps.setInt(3, v.getIdSeleccion());

            if (v.getCapitan() != null) ps.setString(4, v.getCapitan());
            else ps.setNull(4, Types.CHAR);

            if (v.getDorsal() != null) ps.setInt(5, v.getDorsal());
            else ps.setNull(5, Types.SMALLINT);

            if (v.getPosicion() != null) ps.setString(6, v.getPosicion());
            else ps.setNull(6, Types.VARCHAR);

            ps.setString(7, v.getRol());

            if (v.getClub() != null) ps.setString(8, v.getClub());
            else ps.setNull(8, Types.VARCHAR);

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al guardar vinculación de selección", e);
        }
    }

    @Override
    public int actualizar(VinculacionSeleccion v) {
        String sql = "UPDATE VINCULACION_SELECCION SET id_persona = ?, id_seleccion = ?, capitan = ?, dorsal = ?, posicion = ?, rol = ?, club = ? WHERE id_vinculacion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, v.getIdPersona());
            ps.setInt(2, v.getIdSeleccion());

            if (v.getCapitan() != null) ps.setString(3, v.getCapitan());
            else ps.setNull(3, Types.CHAR);

            if (v.getDorsal() != null) ps.setInt(4, v.getDorsal());
            else ps.setNull(4, Types.SMALLINT);

            if (v.getPosicion() != null) ps.setString(5, v.getPosicion());
            else ps.setNull(5, Types.VARCHAR);

            ps.setString(6, v.getRol());

            if (v.getClub() != null) ps.setString(7, v.getClub());
            else ps.setNull(7, Types.VARCHAR);

            ps.setInt(8, v.getIdVinculacion());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar vinculación de selección", e);
        }
    }

    @Override
    public int eliminar(int idVinculacion) {
        String sql = "DELETE FROM VINCULACION_SELECCION WHERE id_vinculacion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVinculacion);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al eliminar vinculación de selección", e);
        }
    }

    private VinculacionSeleccion mapearVinculacion(ResultSet rs) throws SQLException {
        return new VinculacionSeleccion(
                rs.getInt("id_vinculacion"),
                rs.getInt("id_persona"),
                rs.getInt("id_seleccion"),
                rs.getString("capitan"),
                rs.getObject("dorsal", Integer.class),
                rs.getString("posicion"),
                rs.getString("rol"),
                rs.getString("club")
        );
    }
}

