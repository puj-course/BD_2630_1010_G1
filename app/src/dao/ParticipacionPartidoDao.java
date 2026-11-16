package dao;

import entidades.ParticipacionPartido;
import java.util.List;

public interface ParticipacionPartidoDao {
    void registrar(ParticipacionPartido participacion);
    List<ParticipacionPartido> obtenerPorPartido(int idPartido);
}

