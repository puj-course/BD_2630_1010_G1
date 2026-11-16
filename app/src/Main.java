import dao.EdicionMundialDao;
import entidades.EdicionMundial;
import repositorios.EdicionMundialDaoImpl;


public class Main {
  public static void main(String[] args) {

    // menu



    EdicionMundialDao edicionDao = new EdicionMundialDaoImpl();
    for(EdicionMundial e : edicionDao.obtenerTodasEdiciones()){
      System.out.println(e.getNombre());
    };


  }
}