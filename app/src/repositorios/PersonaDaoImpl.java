package repositorios;

import configuracion.ConexionBD;
import dao.PersonaDao;
import entidades.Persona;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PersonaDaoImpl implements PersonaDao {

    @Override
    public List<Persona> obtenerTodas() {
        List<Persona> lista = new ArrayList<>();
        String sql = "SELECT id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento FROM PERSONA";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearPersona(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener todas las personas", e);
        }
        return lista;
    }

    @Override
    public List<Persona> buscarPorNombre(String nombre) {
        List<Persona> lista = new ArrayList<>();
        String sql = "SELECT id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento FROM PERSONA WHERE UPPER(nombre_completo) LIKE UPPER(?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + nombre + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearPersona(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar personas por nombre", e);
        }
        return lista;
    }

    @Override
    public Persona obtenerPorId(int idPersona) {
        String sql = "SELECT id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento FROM PERSONA WHERE id_persona = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPersona);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearPersona(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener persona por ID", e);
        }
    }

    @Override
    public void guardar(Persona persona) {
        String sql = "INSERT INTO PERSONA (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, persona.getIdPersona());
            ps.setString(2, persona.getNombreCompleto());

            if (persona.getNacionalidad() != null) {
                ps.setString(3, persona.getNacionalidad());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }

            if (persona.getFechaDeNacimiento() != null) {
                ps.setDate(4, persona.getFechaDeNacimiento());
            } else {
                ps.setNull(4, Types.DATE);
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al guardar persona", e);
        }
    }

    @Override
    public int actualizar(Persona persona) {
        String sql = "UPDATE PERSONA SET nombre_completo = ?, nacionalidad = ?, fecha_de_nacimiento = ? WHERE id_persona = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, persona.getNombreCompleto());

            if (persona.getNacionalidad() != null) {
                ps.setString(2, persona.getNacionalidad());
            } else {
                ps.setNull(2, Types.VARCHAR);
            }

            if (persona.getFechaDeNacimiento() != null) {
                ps.setDate(3, persona.getFechaDeNacimiento());
            } else {
                ps.setNull(3, Types.DATE);
            }

            ps.setInt(4, persona.getIdPersona());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar persona", e);
        }
    }

    @Override
    public int eliminar(int idPersona) {
        String sql = "DELETE FROM PERSONA WHERE id_persona = ?";
        try (Connection conn = ConexionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPersona);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al eliminar persona", e);
        }
    }

    private Persona mapearPersona(ResultSet rs) throws SQLException {
        return new Persona(
                rs.getInt("id_persona"),
                rs.getString("nombre_completo"),
                rs.getString("nacionalidad"),
                rs.getDate("fecha_de_nacimiento")
        );
    }
}

