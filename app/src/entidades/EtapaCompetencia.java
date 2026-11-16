package entidades;

public class EtapaCompetencia {
    private int idEtapa;
    private int idEdicion;
    private Integer idEtapaPadre; // Puede ser null, se usa la clase Integer para envolver null
    private String nombre;
    private String tipoEtapa; // 'FASE', 'GRUPO', 'INSTANCIA_ELIMINATORIA'
    private int orden;

    public EtapaCompetencia() {}

    public EtapaCompetencia(int idEtapa, int idEdicion, Integer idEtapaPadre, String nombre, String tipoEtapa, int orden) {
        this.idEtapa = idEtapa;
        this.idEdicion = idEdicion;
        this.idEtapaPadre = idEtapaPadre;
        this.nombre = nombre;
        this.tipoEtapa = tipoEtapa;
        this.orden = orden;
    }

    public int getIdEtapa() { return idEtapa; }
    public void setIdEtapa(int idEtapa) { this.idEtapa = idEtapa; }

    public int getIdEdicion() { return idEdicion; }
    public void setIdEdicion(int idEdicion) { this.idEdicion = idEdicion; }

    public Integer getIdEtapaPadre() { return idEtapaPadre; }
    public void setIdEtapaPadre(Integer idEtapaPadre) { this.idEtapaPadre = idEtapaPadre; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getTipoEtapa() { return tipoEtapa; }
    public void setTipoEtapa(String tipoEtapa) { this.tipoEtapa = tipoEtapa; }

    public int getOrden() { return orden; }
    public void setOrden(int orden) { this.orden = orden; }
}

