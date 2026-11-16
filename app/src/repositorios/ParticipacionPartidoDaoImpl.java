package repositorios;

import configuracion.ConexionBD;
import dao.ParticipacionPartidoDao;
import entidades.ParticipacionPartido;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParticipacionPartidoDaoImpl implements ParticipacionPartidoDao {

    @Override
    public void registrar(ParticipacionPartido pp) {
        String sql = "INSERT INTO PARTICIPACION_PARTIDO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pp.getIdParticipacionPartido());
            ps.setInt(2, pp.getIdPartido());
            ps.setInt(3, pp.getIdSeleccion());
            ps.setString(4, pp.getCondicion());
            ps.setInt(5, pp.getGoles());
            ps.setInt(6, pp.getGolesPenales());

            if (pp.getResultado() != null) ps.setString(7, pp.getResultado());
            else ps.setNull(7, Types.VARCHAR);

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al registrar participación en partido", e);
        }
    }

    @Override
    public List<ParticipacionPartido> obtenerPorPartido(int idPartido) {
        List<ParticipacionPartido> lista = new ArrayList<>();
        String sql = "SELECT id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado " +
                "FROM PARTICIPACION_PARTIDO WHERE id_partido = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPartido);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new ParticipacionPartido(
                            rs.getInt("id_participacion_partido"),
                            rs.getInt("id_partido"),
                            rs.getInt("id_seleccion"),
                            rs.getString("condicion"),
                            rs.getInt("goles"),
                            rs.getInt("goles_penales"),
                            rs.getString("resultado")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener participaciones del partido", e);
        }
        return lista;
    }
}

