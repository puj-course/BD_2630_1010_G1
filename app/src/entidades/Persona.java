package entidades;

import java.sql.Date;

public class Persona {
    private int idPersona;
    private String nombreCompleto;
    private String nacionalidad; // Puede ser null
    private Date fechaDeNacimiento; // Puede ser null

    public Persona() {}

    public Persona(int idPersona, String nombreCompleto, String nacionalidad, Date fechaDeNacimiento) {
        this.idPersona = idPersona;
        this.nombreCompleto = nombreCompleto;
        this.nacionalidad = nacionalidad;
        this.fechaDeNacimiento = fechaDeNacimiento;
    }

    public int getIdPersona() { return idPersona; }
    public void setIdPersona(int idPersona) { this.idPersona = idPersona; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getNacionalidad() { return nacionalidad; }
    public void setNacionalidad(String nacionalidad) { this.nacionalidad = nacionalidad; }

    public Date getFechaDeNacimiento() { return fechaDeNacimiento; }
    public void setFechaDeNacimiento(Date fechaDeNacimiento) { this.fechaDeNacimiento = fechaDeNacimiento; }
}

