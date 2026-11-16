package repositorios;

import configuracion.ConexionBD;
import dao.PartidoDao;
import entidades.Partido;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PartidoDaoImpl implements PartidoDao {

    @Override
    public void registrar(Partido p) {
        String sql = "INSERT INTO PARTIDO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, " +
                "fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getIdPartido());
            ps.setInt(2, p.getIdEtapa());
            ps.setInt(3, p.getIdEstadio());

            if (p.getIdPartidoOrigen1() != null) ps.setInt(4, p.getIdPartidoOrigen1());
            else ps.setNull(4, Types.INTEGER);

            if (p.getIdPartidoOrigen2() != null) ps.setInt(5, p.getIdPartidoOrigen2());
            else ps.setNull(5, Types.INTEGER);

            ps.setTimestamp(6, p.getFechaHora());
            ps.setInt(7, p.getAsistenciaRegistrada());
            ps.setString(8, p.getEstado());

            if (p.getResultadoOrigen1() != null) ps.setString(9, p.getResultadoOrigen1());
            else ps.setNull(9, Types.VARCHAR);

            if (p.getResultadoOrigen2() != null) ps.setString(10, p.getResultadoOrigen2());
            else ps.setNull(10, Types.VARCHAR);

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al registrar partido", e);
        }
    }

    @Override
    public List<Partido> obtenerTodos() {
        List<Partido> lista = new ArrayList<>();
        String sql = "SELECT id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, " +
                "fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2 FROM PARTIDO ORDER BY fecha_hora";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearPartido(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al listar partidos", e);
        }
        return lista;
    }

    @Override
    public Partido obtenerPorId(int idPartido) {
        String sql = "SELECT id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, " +
                "fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2 FROM PARTIDO WHERE id_partido = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPartido);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearPartido(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al consultar partido por ID", e);
        }
    }

    private Partido mapearPartido(ResultSet rs) throws SQLException {
        return new Partido(
                rs.getInt("id_partido"),
                rs.getInt("id_etapa"),
                rs.getInt("id_estadio"),
                rs.getObject("id_partido_origen_1", Integer.class),
                rs.getObject("id_partido_origen_2", Integer.class),
                rs.getTimestamp("fecha_hora"),
                rs.getInt("asistencia_registrada"),
                rs.getString("estado"),
                rs.getString("resultado_origen_1"),
                rs.getString("resultado_origen_2")
        );
    }
}

