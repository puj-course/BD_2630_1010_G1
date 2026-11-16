package dao;

import entidades.Seleccion;
import java.util.List;

public interface SeleccionDao {
    List<Seleccion> obtenerTodasSeleccion();
    Seleccion obtenerPorIdSeleccion(int idSeleccion);
    void guardarSeleccion(Seleccion seleccion);
    int actualizarSeleccion(Seleccion seleccion);
    int eliminarSeleccion(int idSeleccion);
}
