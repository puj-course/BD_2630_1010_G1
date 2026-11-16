package dao;

import entidades.EtapaCompetencia;

import java.util.List;

public interface EtapaCompetenciaDao {
    List<EtapaCompetencia> obtenerTodasEtapaCompetencia();
    EtapaCompetencia obtenerPorIdEtapa(int idEtapa);
    void guardarEtapa(EtapaCompetencia etapa);
    int actualizarEtapaCompetencia(EtapaCompetencia etapa);
    int eliminarEtapa(int idEtapa);
}
