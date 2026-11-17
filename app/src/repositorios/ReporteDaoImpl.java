package repositorios;

import configuracion.ConexionBD;
import dao.ReporteDao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReporteDaoImpl implements ReporteDao {

    @Override
    public List<Object[]> actualizarYConsultarPosiciones(int idEtapaGrupo) {
        List<Object[]> filas = new ArrayList<>();
        String callPrc = "{ call prc_actualizar_tabla_posiciones(?) }";
        StringBuilder sqlSelect = new StringBuilder();

        sqlSelect.append("SELECT ROW_NUMBER() OVER (ORDER BY ")
                .append("       SUM(CASE WHEN p.estado = 'FINALIZADO' THEN CASE pp.resultado WHEN 'GANO' THEN 3 WHEN 'EMPATO' THEN 1 ELSE 0 END ELSE 0 END) DESC, ")
                .append("       fn_diferencia_gol(s.id_seleccion) DESC, ")
                .append("       SUM(CASE WHEN p.estado = 'FINALIZADO' THEN pp.goles ELSE 0 END) DESC) AS pos, ")
                .append("       s.codigo_fifa, ")
                .append("       COUNT(CASE WHEN p.estado = 'FINALIZADO' THEN 1 END) AS pj, ")
                .append("       SUM(CASE WHEN p.estado = 'FINALIZADO' AND pp.resultado = 'GANO' THEN 1 ELSE 0 END) AS pg, ")
                .append("       SUM(CASE WHEN p.estado = 'FINALIZADO' AND pp.resultado = 'EMPATO' THEN 1 ELSE 0 END) AS pe, ")
                .append("       SUM(CASE WHEN p.estado = 'FINALIZADO' AND pp.resultado = 'PERDIO' THEN 1 ELSE 0 END) AS pp, ")
                .append("       SUM(CASE WHEN p.estado = 'FINALIZADO' THEN pp.goles ELSE 0 END) AS gf, ")
                .append("       SUM(CASE WHEN p.estado = 'FINALIZADO' THEN pp_rival.goles ELSE 0 END) AS gc, ")
                .append("       fn_diferencia_gol(s.id_seleccion) AS dg, ")
                .append("       SUM(CASE WHEN p.estado = 'FINALIZADO' THEN CASE pp.resultado WHEN 'GANO' THEN 3 WHEN 'EMPATO' THEN 1 ELSE 0 END ELSE 0 END) AS pts ")
                .append("FROM SELECCION s ")
                .append("LEFT JOIN PARTICIPACION_PARTIDO pp ON s.id_seleccion = pp.id_seleccion ")
                .append("LEFT JOIN PARTIDO p ON pp.id_partido = p.id_partido AND p.id_etapa = ? ")
                .append("LEFT JOIN PARTICIPACION_PARTIDO pp_rival ON p.id_partido = pp_rival.id_partido AND pp_rival.id_seleccion <> s.id_seleccion ")
                .append("WHERE s.id_etapa_grupo = ? ")
                .append("GROUP BY s.id_seleccion, s.codigo_fifa ")
                .append("ORDER BY pos");

        try (Connection conn = ConexionBD.getConnection()) {
            // 1. Ejecutar tu procedimiento almacenado
            try (CallableStatement cs = conn.prepareCall(callPrc)) {
                cs.setInt(1, idEtapaGrupo);
                cs.execute();
            }
            // 2. Consultar los datos resultantes usando tu función fn_diferencia_gol
            try (PreparedStatement ps = conn.prepareStatement(sqlSelect.toString())) {
                ps.setInt(1, idEtapaGrupo);
                ps.setInt(2, idEtapaGrupo);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        filas.add(new Object[]{
                                rs.getInt("pos"), rs.getString("codigo_fifa"), rs.getInt("pj"),
                                rs.getInt("pg"), rs.getInt("pe"), rs.getInt("pp"),
                                rs.getInt("gf"), rs.getInt("gc"), rs.getInt("dg"), rs.getInt("pts")
                        });
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error en tabla de posiciones: " + e.getMessage(), e);
        }
        return filas;
    }

    @Override
    public String obtenerRankingGoleadoresTexto(int idEdicion, int top) {
        String sql = "{ ? = call fn_ranking_goleadores(?, ?) }";
        try (Connection conn = ConexionBD.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.registerOutParameter(1, Types.VARCHAR);
            cs.setInt(2, idEdicion);
            cs.setInt(3, top);
            cs.execute();
            return cs.getString(1);
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener goleadores: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Object[]> obtenerResultadosConsolidados(int idEdicion, Integer idSeleccion, Integer idEtapa) {
        List<Object[]> filas = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.id_partido, p.fecha_hora, ec.nombre AS etapa, est.nombre AS estadio, ")
                .append("       s_loc.codigo_fifa AS local, pp_loc.goles AS g_loc, ")
                .append("       s_vis.codigo_fifa AS visitante, pp_vis.goles AS g_vis, p.estado ")
                .append("FROM PARTIDO p ")
                .append("JOIN ETAPA_COMPETENCIA ec ON p.id_etapa = ec.id_etapa ")
                .append("JOIN ESTADIO est ON p.id_estadio = est.id_estadio ")
                .append("JOIN PARTICIPACION_PARTIDO pp_loc ON p.id_partido = pp_loc.id_partido AND pp_loc.condicion = 'LOCAL' ")
                .append("JOIN SELECCION s_loc ON pp_loc.id_seleccion = s_loc.id_seleccion ")
                .append("JOIN PARTICIPACION_PARTIDO pp_vis ON p.id_partido = pp_vis.id_partido AND pp_vis.condicion = 'VISITANTE' ")
                .append("JOIN SELECCION s_vis ON pp_vis.id_seleccion = s_vis.id_seleccion ")
                .append("WHERE ec.id_edicion = ? ")
                .append("  AND (? IS NULL OR p.id_etapa = ?) ")
                .append("  AND (? IS NULL OR s_loc.id_seleccion = ? OR s_vis.id_seleccion = ?) ")
                .append("ORDER BY p.fecha_hora");

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, idEdicion);

            if (idEtapa != null) { ps.setInt(2, idEtapa); ps.setInt(3, idEtapa); }
            else { ps.setNull(2, Types.INTEGER); ps.setNull(3, Types.INTEGER); }

            if (idSeleccion != null) { ps.setInt(4, idSeleccion); ps.setInt(5, idSeleccion); ps.setInt(6, idSeleccion); }
            else { ps.setNull(4, Types.INTEGER); ps.setNull(5, Types.INTEGER); ps.setNull(6, Types.INTEGER); }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    filas.add(new Object[]{
                            rs.getInt("id_partido"), rs.getTimestamp("fecha_hora"), rs.getString("etapa"),
                            rs.getString("estadio"), rs.getString("local"), rs.getInt("g_loc"),
                            rs.getString("visitante"), rs.getInt("g_vis"), rs.getString("estado")
                    });
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al consultar resultados consolidados", e);
        }
        return filas;
    }

    @Override
    public List<Object[]> obtenerIncidencias(int idEdicion, Integer idEtapa) {
        List<Object[]> filas = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.id_partido, ec.nombre AS etapa, ev.tipo_evento, ev.minuto, per.nombre_completo, ev.descripcion ")
                .append("FROM EVENTO_PARTIDO ev ")
                .append("JOIN PARTIDO p ON ev.id_partido = p.id_partido ")
                .append("JOIN ETAPA_COMPETENCIA ec ON p.id_etapa = ec.id_etapa ")
                .append("LEFT JOIN PERSONA per ON ev.id_persona = per.id_persona ")
                .append("WHERE ec.id_edicion = ? ")
                .append("  AND (? IS NULL OR p.id_etapa = ?) ")
                .append("  AND ev.tipo_evento IN ('TARJETA_AMARILLA', 'TARJETA_ROJA') ")
                .append("ORDER BY p.id_partido, ev.minuto");

        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, idEdicion);
            if (idEtapa != null) { ps.setInt(2, idEtapa); ps.setInt(3, idEtapa); }
            else { ps.setNull(2, Types.INTEGER); ps.setNull(3, Types.INTEGER); }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    filas.add(new Object[]{
                            rs.getInt("id_partido"), rs.getString("etapa"), rs.getString("tipo_evento"),
                            rs.getObject("minuto"), rs.getString("nombre_completo"), rs.getString("descripcion")
                    });
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al consultar incidencias", e);
        }
        return filas;
    }
}

