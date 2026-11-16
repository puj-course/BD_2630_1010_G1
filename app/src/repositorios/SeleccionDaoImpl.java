package repositorios;


import configuracion.ConexionBD;
import dao.SeleccionDao;
import entidades.Seleccion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SeleccionDaoImpl implements SeleccionDao {

    @Override
    public List<Seleccion> obtenerTodasSeleccion() {
        List<Seleccion> lista = new ArrayList<>();
        String sql = "SELECT id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa FROM SELECCION";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearSeleccion(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener todas las selecciones", e);
        }
        return lista;
    }

    @Override
    public Seleccion obtenerPorIdSeleccion(int idSeleccion) {
        String sql = "SELECT id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa FROM SELECCION WHERE id_seleccion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSeleccion);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearSeleccion(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener selección por ID", e);
        }
    }

    @Override
    public void guardarSeleccion(Seleccion seleccion) {
        String sql = "INSERT INTO SELECCION (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seleccion.getIdSeleccion());
            ps.setInt(2, seleccion.getIdOrganizacion());
            ps.setInt(3, seleccion.getIdEtapaGrupo());
            ps.setString(4, seleccion.getCodigoFifa());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al guardar selección", e);
        }
    }

    @Override
    public int actualizarSeleccion(Seleccion seleccion) {
        String sql = "UPDATE SELECCION SET id_organizacion = ?, id_etapa_grupo = ?, codigo_fifa = ? WHERE id_seleccion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seleccion.getIdOrganizacion());
            ps.setInt(2, seleccion.getIdEtapaGrupo());
            ps.setString(3, seleccion.getCodigoFifa());
            ps.setInt(4, seleccion.getIdSeleccion());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar selección", e);
        }
    }

    @Override
    public int eliminarSeleccion(int idSeleccion) {
        String sql = "DELETE FROM SELECCION WHERE id_seleccion = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSeleccion);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al eliminar selección", e);
        }
    }

    private Seleccion mapearSeleccion(ResultSet rs) throws SQLException {
        return new Seleccion(
                rs.getInt("id_seleccion"),
                rs.getInt("id_organizacion"),
                rs.getInt("id_etapa_grupo"),
                rs.getString("codigo_fifa")
        );
    }
}

