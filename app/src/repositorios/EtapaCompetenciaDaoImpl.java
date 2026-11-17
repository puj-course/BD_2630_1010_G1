package repositorios;

import configuracion.ConexionBD;
import dao.EtapaCompetenciaDao;
import entidades.EtapaCompetencia;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EtapaCompetenciaDaoImpl implements EtapaCompetenciaDao {

    @Override
    public EtapaCompetencia obtenerPorIdEtapa(int idEtapa) {
        StringBuilder sql = new StringBuilder("SELECT id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden");
        sql.append(" FROM ETAPA_COMPETENCIA WHERE id_etapa = ?");
        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString())){

            ps.setInt(1, idEtapa);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new EtapaCompetencia(
                            rs.getInt("id_etapa"),
                            rs.getInt("id_edicion"),
                            rs.getObject("id_etapa_padre", Integer.class),
                            rs.getString("nombre"),
                            rs.getString("tipo_etapa"),
                            rs.getInt("orden")
                    );
                }
            }
        }catch(SQLException e){
            throw new RuntimeException("Error al obtener EtapaCompetencia", e);
        }
        return null;
    }

    @Override
    public int actualizarEtapaCompetencia(EtapaCompetencia etapa) {
        StringBuilder sql = new StringBuilder("UPDATE ETAPA_COMPETENCIA SET id_edicion = ?, id_etapa_padre = ?, ");
        sql.append("nombre = ?, tipo_etapa = ?, orden = ? WHERE id_etapa = ?");

        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString())){

            ps.setInt(1, etapa.getIdEdicion());
            ps.setObject(2, etapa.getIdEtapaPadre());
            ps.setString(3, etapa.getNombre());
            ps.setString(4, etapa.getTipoEtapa());
            ps.setInt(5, etapa.getOrden());
            ps.setInt(6, etapa.getIdEtapa());

            return ps.executeUpdate();

        }catch (SQLException e){
            throw new RuntimeException("Error al actualizar EtapaCompetencia", e);
        }
    }

    @Override
    public int eliminarEtapa(int id_etapa){
        String sql = "DELETE FROM ETAPA_COMPETENCIA WHERE id_etapa = ?";
        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){

            ps.setInt(1, id_etapa);
            return ps.executeUpdate();

        }catch (SQLException e){
            throw new RuntimeException("Error al eliminar EtapaCompetencia", e);
        }
    }

    @Override
    public void guardarEtapa(EtapaCompetencia etapa) {
        StringBuilder sql = new StringBuilder("INSERT INTO ETAPA_COMPETENCIA (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden)");
        sql.append(" VALUES (?, ?, ?, ?, ?, ?)");
        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString())){

            ps.setInt(1, etapa.getIdEtapa());
            ps.setInt(2, etapa.getIdEdicion());
            ps.setObject(3, etapa.getIdEtapaPadre());
            ps.setString(4, etapa.getNombre());
            ps.setString(5, etapa.getTipoEtapa());
            ps.setInt(6, etapa.getOrden());
            ps.executeUpdate();

        }catch (SQLException e){
            throw new RuntimeException("Error al guardar EtapaCompetencia", e);
        }
    }

    @Override
    public List obtenerTodasEtapaCompetencia(){
        List<EtapaCompetencia> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden");
        sql.append(" FROM ETAPA_COMPETENCIA");

        try(Connection conn = ConexionBD.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            ResultSet rs = ps.executeQuery()){

            while (rs.next()) {
                lista.add(new EtapaCompetencia(
                        rs.getInt("id_etapa"),
                        rs.getInt("id_edicion"),
                        rs.getObject("id_etapa_padre", Integer.class),
                        rs.getString("nombre"),
                        rs.getString("tipo_etapa"),
                        rs.getInt("orden")
                ));
            }

            return lista;

        }catch (SQLException e){
            throw new RuntimeException("Error al obtener todas las EtapaCompetencia", e);
        }
    }


}
