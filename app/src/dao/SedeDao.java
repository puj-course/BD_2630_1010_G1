package dao;

import entidades.Sede;

import java.sql.ResultSet;
import java.util.List;

public interface SedeDao {
    List<Sede> obtenerTodasSedes();
    void guardarSede(Sede sede);
    Sede obtenerPorIdSede(int idSede);
    int actualizarSede(Sede sede);
    int eliminarSede(int idSede);
}
