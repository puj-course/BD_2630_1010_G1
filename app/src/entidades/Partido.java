package entidades;

import java.sql.Timestamp;

public class Partido {
    private int idPartido;
    private int idEtapa;
    private int idEstadio;
    private Integer idPartidoOrigen1; // Puede ser null
    private Integer idPartidoOrigen2; // Puede ser null
    private Timestamp fechaHora;
    private int asistenciaRegistrada;
    private String estado;
    private String resultadoOrigen1; // 'GANADOR' o 'PERDEDOR', puede ser null
    private String resultadoOrigen2; // 'GANADOR' o 'PERDEDOR', puede ser null

    public Partido() {}

    public Partido(int idPartido, int idEtapa, int idEstadio, Integer idPartidoOrigen1, Integer idPartidoOrigen2,
                   Timestamp fechaHora, int asistenciaRegistrada, String estado, String resultadoOrigen1, String resultadoOrigen2) {
        this.idPartido = idPartido;
        this.idEtapa = idEtapa;
        this.idEstadio = idEstadio;
        this.idPartidoOrigen1 = idPartidoOrigen1;
        this.idPartidoOrigen2 = idPartidoOrigen2;
        this.fechaHora = fechaHora;
        this.asistenciaRegistrada = asistenciaRegistrada;
        this.estado = estado;
        this.resultadoOrigen1 = resultadoOrigen1;
        this.resultadoOrigen2 = resultadoOrigen2;
    }

    public int getIdPartido() { return idPartido; }
    public void setIdPartido(int idPartido) { this.idPartido = idPartido; }

    public int getIdEtapa() { return idEtapa; }
    public void setIdEtapa(int idEtapa) { this.idEtapa = idEtapa; }

    public int getIdEstadio() { return idEstadio; }
    public void setIdEstadio(int idEstadio) { this.idEstadio = idEstadio; }

    public Integer getIdPartidoOrigen1() { return idPartidoOrigen1; }
    public void setIdPartidoOrigen1(Integer idPartidoOrigen1) { this.idPartidoOrigen1 = idPartidoOrigen1; }

    public Integer getIdPartidoOrigen2() { return idPartidoOrigen2; }
    public void setIdPartidoOrigen2(Integer idPartidoOrigen2) { this.idPartidoOrigen2 = idPartidoOrigen2; }

    public Timestamp getFechaHora() { return fechaHora; }
    public void setFechaHora(Timestamp fechaHora) { this.fechaHora = fechaHora; }

    public int getAsistenciaRegistrada() { return asistenciaRegistrada; }
    public void setAsistenciaRegistrada(int asistenciaRegistrada) { this.asistenciaRegistrada = asistenciaRegistrada; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getResultadoOrigen1() { return resultadoOrigen1; }
    public void setResultadoOrigen1(String resultadoOrigen1) { this.resultadoOrigen1 = resultadoOrigen1; }

    public String getResultadoOrigen2() { return resultadoOrigen2; }
    public void setResultadoOrigen2(String resultadoOrigen2) { this.resultadoOrigen2 = resultadoOrigen2; }
}


