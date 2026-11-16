package repositorios;

import configuracion.ConexionBD;
import dao.EventoPartidoDao;
import entidades.EventoPartido;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventoPartidoDaoImpl implements EventoPartidoDao {

    @Override
    public void registrar(EventoPartido ev) {
        String sql = "INSERT INTO EVENTO_PARTIDO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ev.getIdEvento());
            ps.setInt(2, ev.getIdPartido());

            if (ev.getIdPersona() != null) ps.setInt(3, ev.getIdPersona());
            else ps.setNull(3, Types.INTEGER);

            if (ev.getIdPersonaRelacionada() != null) ps.setInt(4, ev.getIdPersonaRelacionada());
            else ps.setNull(4, Types.INTEGER);

            ps.setString(5, ev.getTipoEvento());

            if (ev.getMinuto() != null) ps.setInt(6, ev.getMinuto());
            else ps.setNull(6, Types.SMALLINT);

            if (ev.getValorNumerico() != null) ps.setInt(7, ev.getValorNumerico());
            else ps.setNull(7, Types.SMALLINT);

            if (ev.getDescripcion() != null) ps.setString(8, ev.getDescripcion());
            else ps.setNull(8, Types.VARCHAR);

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al registrar evento del partido", e);
        }
    }

    @Override
    public List<EventoPartido> obtenerPorPartido(int idPartido) {
        List<EventoPartido> lista = new ArrayList<>();
        String sql = "SELECT id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion " +
                "FROM EVENTO_PARTIDO WHERE id_partido = ? ORDER BY minuto";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPartido);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new EventoPartido(
                            rs.getInt("id_evento"),
                            rs.getInt("id_partido"),
                            rs.getObject("id_persona", Integer.class),
                            rs.getObject("id_persona_relacionada", Integer.class),
                            rs.getString("tipo_evento"),
                            rs.getObject("minuto", Integer.class),
                            rs.getObject("valor_numerico", Integer.class),
                            rs.getString("descripcion")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al consultar eventos del partido", e);
        }
        return lista;
    }
}
