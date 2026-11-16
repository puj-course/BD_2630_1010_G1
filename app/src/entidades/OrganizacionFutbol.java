package entidades;

public class OrganizacionFutbol {
    private int idOrganizacion;
    private String nombre;
    private String tipo; // 'CONFEDERACION' o 'FEDERACION_NACIONAL'
    private String pais;
    private Integer idOrganizacionPadre; // Puede ser null, se usa la clase Integer para envolver null

    public OrganizacionFutbol() {}

    public OrganizacionFutbol(int idOrganizacion, String nombre, String tipo, String pais, Integer idOrganizacionPadre) {
        this.idOrganizacion = idOrganizacion;
        this.nombre = nombre;
        this.tipo = tipo;
        this.pais = pais;
        this.idOrganizacionPadre = idOrganizacionPadre;
    }

    public int getIdOrganizacion() { return idOrganizacion; }
    public void setIdOrganizacion(int idOrganizacion) { this.idOrganizacion = idOrganizacion; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getPais() { return pais; }
    public void setPais(String pais) { this.pais = pais; }

    public Integer getIdOrganizacionPadre() { return idOrganizacionPadre; }
    public void setIdOrganizacionPadre(Integer idOrganizacionPadre) { this.idOrganizacionPadre = idOrganizacionPadre; }
}

