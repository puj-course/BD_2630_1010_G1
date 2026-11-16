package entidades;

public class Ciudad {
    private int idCiudad;
    private int idSede;
    private String nombre;

    public Ciudad() {}

    public Ciudad(int idCiudad, int idSede, String nombre) {
        this.idCiudad = idCiudad;
        this.idSede = idSede;
        this.nombre = nombre;
    }

    public int getIdCiudad() { return idCiudad; }
    public void setIdCiudad(int idCiudad) { this.idCiudad = idCiudad; }

    public int getIdSede() { return idSede; }
    public void setIdSede(int idSede) { this.idSede = idSede; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
}