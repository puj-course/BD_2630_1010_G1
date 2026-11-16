package entidades;

public class Estadio {
    private int idEstadio;
    private int idCiudad;
    private String nombre;
    private int capacidad;

    public Estadio() {}

    public Estadio(int idEstadio, int idCiudad, String nombre, int capacidad) {
        this.idEstadio = idEstadio;
        this.idCiudad = idCiudad;
        this.nombre = nombre;
        this.capacidad = capacidad;
    }

    public int getIdEstadio() { return idEstadio; }
    public void setIdEstadio(int idEstadio) { this.idEstadio = idEstadio; }

    public int getIdCiudad() { return idCiudad; }
    public void setIdCiudad(int idCiudad) { this.idCiudad = idCiudad; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public int getCapacidad() { return capacidad; }
    public void setCapacidad(int capacidad) { this.capacidad = capacidad; }
}
