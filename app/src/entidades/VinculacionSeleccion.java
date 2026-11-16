package entidades;

public class VinculacionSeleccion {
    private int idVinculacion;
    private int idPersona;
    private int idSeleccion;
    private String capitan; // 'S' o 'N' (CHAR(1)), puede ser null
    private Integer dorsal; // SMALLINT, puede ser null
    private String posicion; // Puede ser null
    private String rol; // 'JUGADOR', 'DIRECTOR_TECNICO', 'ASISTENTE', 'PREPARADOR_FISICO'
    private String club; // Puede ser null

    public VinculacionSeleccion() {}

    public VinculacionSeleccion(int idVinculacion, int idPersona, int idSeleccion, String capitan, Integer dorsal, String posicion, String rol, String club) {
        this.idVinculacion = idVinculacion;
        this.idPersona = idPersona;
        this.idSeleccion = idSeleccion;
        this.capitan = capitan;
        this.dorsal = dorsal;
        this.posicion = posicion;
        this.rol = rol;
        this.club = club;
    }

    public int getIdVinculacion() { return idVinculacion; }
    public void setIdVinculacion(int idVinculacion) { this.idVinculacion = idVinculacion; }

    public int getIdPersona() { return idPersona; }
    public void setIdPersona(int idPersona) { this.idPersona = idPersona; }

    public int getIdSeleccion() { return idSeleccion; }
    public void setIdSeleccion(int idSeleccion) { this.idSeleccion = idSeleccion; }

    public String getCapitan() { return capitan; }
    public void setCapitan(String capitan) { this.capitan = capitan; }

    public Integer getDorsal() { return dorsal; }
    public void setDorsal(Integer dorsal) { this.dorsal = dorsal; }

    public String getPosicion() { return posicion; }
    public void setPosicion(String posicion) { this.posicion = posicion; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public String getClub() { return club; }
    public void setClub(String club) { this.club = club; }
}

