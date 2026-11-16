package dao;

import entidades.OrganizacionFutbol;

import java.util.List;

public interface OrganizacionFutbolDao {
    List<OrganizacionFutbol> obtenerOrganizaciones();
    OrganizacionFutbol obtenerOrganizacionPorId(int idOrganizacion);
    void guardarOrganizacion(OrganizacionFutbol organizacion);
    int actualizarOrganizacion(OrganizacionFutbol organizacion);
    int eliminarOrganizacion(int idOrganizacion);
}
