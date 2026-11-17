package dao;

import java.util.List;

public interface ReporteDao {
    // Se usa el procedimiento y consultamos la tabla de posiciones actualizada
    List<Object[]> actualizarYConsultarPosiciones(int idEtapaGrupo);

    // Se usa fn_ranking_goleadores
    String obtenerRankingGoleadoresTexto(int idEdicion, int top);

    // Resultados consolidados con filtros opcionales
    List<Object[]> obtenerResultadosConsolidados(int idEdicion, Integer idSeleccion, Integer idEtapa);

    // consulta de incidencias
    List<Object[]> obtenerIncidencias(int idEdicion, Integer idEtapa);

}

