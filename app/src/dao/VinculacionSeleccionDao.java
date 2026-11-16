package dao;

import entidades.VinculacionSeleccion;
import java.util.List;

public interface VinculacionSeleccionDao {
    List<VinculacionSeleccion> obtenerTodas();
    List<VinculacionSeleccion> obtenerPorSeleccion(int idSeleccion);
    VinculacionSeleccion obtenerPorId(int idVinculacion);
    void guardar(VinculacionSeleccion vinculacion);
    int actualizar(VinculacionSeleccion vinculacion);
    int eliminar(int idVinculacion);
}
