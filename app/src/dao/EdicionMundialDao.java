package dao;

import entidades.EdicionMundial;
import java.util.List;

public interface EdicionMundialDao {
    List<EdicionMundial> obtenerTodasEdiciones();
    EdicionMundial obtenerPorIdEdicion(int idEdicion);
    void guardarEdicion(EdicionMundial edicion);
    int actualizarEdicion(EdicionMundial edicion);
    int eliminarEdicion(int idEdicion);
}

