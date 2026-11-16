package entidades;

public class EventoPartido {
    private int idEvento;
    private int idPartido;
    private Integer idPersona; // Puede ser null
    private Integer idPersonaRelacionada; // Puede ser null (ej. quien entra en sustitución)
    private String tipoEvento; // 'GOL', 'ASISTENCIA', 'TARJETA_AMARILLA', 'TARJETA_ROJA', 'SUSTITUCION', 'MINUTOS_JUGADOS'
    private Integer minuto; // SMALLINT, puede ser null
    private Integer valorNumerico; // SMALLINT, puede ser null
    private String descripcion; // Puede ser null

    public EventoPartido() {}

    public EventoPartido(int idEvento, int idPartido, Integer idPersona, Integer idPersonaRelacionada,
                         String tipoEvento, Integer minuto, Integer valorNumerico, String descripcion) {
        this.idEvento = idEvento;
        this.idPartido = idPartido;
        this.idPersona = idPersona;
        this.idPersonaRelacionada = idPersonaRelacionada;
        this.tipoEvento = tipoEvento;
        this.minuto = minuto;
        this.valorNumerico = valorNumerico;
        this.descripcion = descripcion;
    }

    public int getIdEvento() { return idEvento; }
    public void setIdEvento(int idEvento) { this.idEvento = idEvento; }

    public int getIdPartido() { return idPartido; }
    public void setIdPartido(int idPartido) { this.idPartido = idPartido; }

    public Integer getIdPersona() { return idPersona; }
    public void setIdPersona(Integer idPersona) { this.idPersona = idPersona; }

    public Integer getIdPersonaRelacionada() { return idPersonaRelacionada; }
    public void setIdPersonaRelacionada(Integer idPersonaRelacionada) { this.idPersonaRelacionada = idPersonaRelacionada; }

    public String getTipoEvento() { return tipoEvento; }
    public void setTipoEvento(String tipoEvento) { this.tipoEvento = tipoEvento; }

    public Integer getMinuto() { return minuto; }
    public void setMinuto(Integer minuto) { this.minuto = minuto; }

    public Integer getValorNumerico() { return valorNumerico; }
    public void setValorNumerico(Integer valorNumerico) { this.valorNumerico = valorNumerico; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}

