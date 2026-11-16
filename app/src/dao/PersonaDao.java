package dao;

import entidades.Persona;
import java.util.List;

public interface PersonaDao {
    List<Persona> obtenerTodas();
    List<Persona> buscarPorNombre(String nombre);
    Persona obtenerPorId(int idPersona);
    void guardar(Persona persona);
    int actualizar(Persona persona);
    int eliminar(int idPersona);
}
