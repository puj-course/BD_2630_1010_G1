package dao;

import entidades.Partido;
import java.util.List;

public interface PartidoDao {
    void registrar(Partido partido);
    List<Partido> obtenerTodos();
    Partido obtenerPorId(int idPartido);
}

