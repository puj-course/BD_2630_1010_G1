package entidades;

import java.sql.Date;

public class EdicionMundial {
    private int idEdicion;
    private int anio;
    private String nombre;
    private Date fechaInicio;
    private Date fechaFin;

    public EdicionMundial() {}

    public EdicionMundial(int idEdicion, int anio, String nombre, Date fechaInicio, Date fechaFin) {
        this.idEdicion = idEdicion;
        this.anio = anio;
        this.nombre = nombre;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
    }

    // Getters y Setters
    public int getIdEdicion() { return idEdicion; }
    public void setIdEdicion(int idEdicion) { this.idEdicion = idEdicion; }

    public int getAnio() { return anio; }
    public void setAnio(int anio) { this.anio = anio; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public Date getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(Date fechaInicio) { this.fechaInicio = fechaInicio; }

    public Date getFechaFin() { return fechaFin; }
    public void setFechaFin(Date fechaFin) { this.fechaFin = fechaFin; }
}
