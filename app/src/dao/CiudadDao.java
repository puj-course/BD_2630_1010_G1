package dao;

import entidades.Ciudad;

import java.util.List;

public interface CiudadDao {
    List<Ciudad> obtenerTodasCiudad();
    Ciudad obtenerPorIdCiudad(int idCiudad);
    void guardarCiudad(Ciudad c);
    int actualizarCiudad(Ciudad c);
    int eliminarCiudad(int idCiudad);
}
