package dao;

import entidades.EventoPartido;
import java.util.List;

public interface EventoPartidoDao {
    void registrar(EventoPartido evento);
    List<EventoPartido> obtenerPorPartido(int idPartido);
}
