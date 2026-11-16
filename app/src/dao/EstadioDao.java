package dao;

import entidades.Estadio;

import java.util.List;

public interface EstadioDao {
    List<Estadio> obtenerTodosEstadio();
    Estadio obtenerPorIdEstadio(int idEdicion);
    void guardarEstadio(Estadio estadio);
    int actualizarEstadio(Estadio estadio);
    int eliminarEstadio(int idEstadio);
}
