package entidades;

public class Seleccion {
    private int idSeleccion;
    private int idOrganizacion;
    private int idEtapaGrupo;
    private String codigoFifa;

    public Seleccion() {}

    public Seleccion(int idSeleccion, int idOrganizacion, int idEtapaGrupo, String codigoFifa) {
        this.idSeleccion = idSeleccion;
        this.idOrganizacion = idOrganizacion;
        this.idEtapaGrupo = idEtapaGrupo;
        this.codigoFifa = codigoFifa;
    }

    public int getIdSeleccion() { return idSeleccion; }
    public void setIdSeleccion(int idSeleccion) { this.idSeleccion = idSeleccion; }

    public int getIdOrganizacion() { return idOrganizacion; }
    public void setIdOrganizacion(int idOrganizacion) { this.idOrganizacion = idOrganizacion; }

    public int getIdEtapaGrupo() { return idEtapaGrupo; }
    public void setIdEtapaGrupo(int idEtapaGrupo) { this.idEtapaGrupo = idEtapaGrupo; }

    public String getCodigoFifa() { return codigoFifa; }
    public void setCodigoFifa(String codigoFifa) { this.codigoFifa = codigoFifa; }
}