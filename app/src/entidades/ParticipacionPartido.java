package entidades;

public class ParticipacionPartido {
    private int idParticipacionPartido;
    private int idPartido;
    private int idSeleccion;
    private String condicion; // 'LOCAL' o 'VISITANTE'
    private int goles;
    private int golesPenales;
    private String resultado; // 'GANO', 'PERDIO', 'EMPATO' o null

    public ParticipacionPartido() {}

    public ParticipacionPartido(int idParticipacionPartido, int idPartido, int idSeleccion, String condicion,
                                int goles, int golesPenales, String resultado) {
        this.idParticipacionPartido = idParticipacionPartido;
        this.idPartido = idPartido;
        this.idSeleccion = idSeleccion;
        this.condicion = condicion;
        this.goles = goles;
        this.golesPenales = golesPenales;
        this.resultado = resultado;
    }

    public int getIdParticipacionPartido() { return idParticipacionPartido; }
    public void setIdParticipacionPartido(int idParticipacionPartido) { this.idParticipacionPartido = idParticipacionPartido; }

    public int getIdPartido() { return idPartido; }
    public void setIdPartido(int idPartido) { this.idPartido = idPartido; }

    public int getIdSeleccion() { return idSeleccion; }
    public void setIdSeleccion(int idSeleccion) { this.idSeleccion = idSeleccion; }

    public String getCondicion() { return condicion; }
    public void setCondicion(String condicion) { this.condicion = condicion; }

    public int getGoles() { return goles; }
    public void setGoles(int goles) { this.goles = goles; }

    public int getGolesPenales() { return golesPenales; }
    public void setGolesPenales(int golesPenales) { this.golesPenales = golesPenales; }

    public String getResultado() { return resultado; }
    public void setResultado(String resultado) { this.resultado = resultado; }
}

