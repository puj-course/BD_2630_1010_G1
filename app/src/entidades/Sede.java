package entidades;

public class Sede {
    private int idSede;
    private int idEdicion;
    private String pais;

    public Sede(){}

    public Sede(int idSede, int idEdicion, String pais) {
        this.idSede = idSede;
        this.idEdicion = idEdicion;
        this.pais = pais;
    }

    public int getIdSede() { return idSede; }
    public void setIdSede(int idSede) { this.idSede = idSede; }

    public int getIdEdicion() { return idEdicion; }
    public void setIdEdicion(int idEdicion) { this.idEdicion = idEdicion; }

    public String getPais() { return pais; }
    public void setPais(String pais) { this.pais = pais; }
}
