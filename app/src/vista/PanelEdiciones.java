package vista;

import dao.EdicionMundialDao;
import entidades.EdicionMundial;
import repositorios.EdicionMundialDaoImpl;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.Date;
import java.util.List;

public class PanelEdiciones extends JPanel {

    private final EdicionMundialDao edicionDao = new EdicionMundialDaoImpl();
    private JTextField txtId, txtAnio, txtNombre, txtFechaInicio, txtFechaFin;
    private DefaultTableModel modeloTabla;
    private JTable tabla;

    public PanelEdiciones() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // --- Formulario superior ---
        JPanel panelForm = new JPanel(new GridLayout(3, 4, 8, 8));
        panelForm.setBorder(BorderFactory.createTitledBorder("Datos de Edición Mundial"));

        txtId = new JTextField();
        txtAnio = new JTextField();
        txtNombre = new JTextField();
        txtFechaInicio = new JTextField("2026-06-11");
        txtFechaFin = new JTextField("2026-07-19");

        panelForm.add(new JLabel("ID Edición:"));
        panelForm.add(txtId);
        panelForm.add(new JLabel("Año:"));
        panelForm.add(txtAnio);

        panelForm.add(new JLabel("Nombre:"));
        panelForm.add(txtNombre);
        panelForm.add(new JLabel("Fecha Inicio (AAAA-MM-DD):"));
        panelForm.add(txtFechaInicio);

        panelForm.add(new JLabel("Fecha Fin (AAAA-MM-DD):"));
        panelForm.add(txtFechaFin);

        // --- Botones de acción ---
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JButton btnGuardar = new JButton("Guardar");
        JButton btnActualizar = new JButton("Actualizar");
        JButton btnEliminar = new JButton("Eliminar");
        JButton btnRefrescar = new JButton("Refrescar Tabla");

        panelBotones.add(btnGuardar);
        panelBotones.add(btnActualizar);
        panelBotones.add(btnEliminar);
        panelBotones.add(btnRefrescar);

        JPanel panelNorte = new JPanel(new BorderLayout());
        panelNorte.add(panelForm, BorderLayout.CENTER);
        panelNorte.add(panelBotones, BorderLayout.SOUTH);
        add(panelNorte, BorderLayout.NORTH);

        // --- Tabla central ---
        modeloTabla = new DefaultTableModel(new String[]{"ID", "Año", "Nombre", "Inicio", "Fin"}, 0) {
            @Override
            public boolean isCellEditable(int row, int column) { return false; }
        };
        tabla = new JTable(modeloTabla);
        add(new JScrollPane(tabla), BorderLayout.CENTER);

        // --- Eventos ---
        btnGuardar.addActionListener(e -> guardarEdicion());
        btnActualizar.addActionListener(e -> actualizarEdicion());
        btnEliminar.addActionListener(e -> eliminarEdicion());
        btnRefrescar.addActionListener(e -> cargarTabla());

        // Cargar datos al abrir
        cargarTabla();
    }

    private void cargarTabla() {
        modeloTabla.setRowCount(0);
        try {
            List<EdicionMundial> lista = edicionDao.obtenerTodasEdiciones();
            for (EdicionMundial ed : lista) {
                modeloTabla.addRow(new Object[]{
                        ed.getIdEdicion(), ed.getAnio(), ed.getNombre(), ed.getFechaInicio(), ed.getFechaFin()
                });
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error al cargar: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void guardarEdicion() {
        try {
            EdicionMundial ed = new EdicionMundial(
                    Integer.parseInt(txtId.getText().trim()),
                    Integer.parseInt(txtAnio.getText().trim()),
                    txtNombre.getText().trim(),
                    Date.valueOf(txtFechaInicio.getText().trim()),
                    Date.valueOf(txtFechaFin.getText().trim())
            );
            edicionDao.guardarEdicion(ed);
            JOptionPane.showMessageDialog(this, "Edición guardada con éxito.");
            cargarTabla();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error al guardar: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void actualizarEdicion() {
        try {
            EdicionMundial ed = new EdicionMundial(
                    Integer.parseInt(txtId.getText().trim()),
                    Integer.parseInt(txtAnio.getText().trim()),
                    txtNombre.getText().trim(),
                    Date.valueOf(txtFechaInicio.getText().trim()),
                    Date.valueOf(txtFechaFin.getText().trim())
            );
            int filas = edicionDao.actualizarEdicion(ed);
            if (filas > 0) {
                JOptionPane.showMessageDialog(this, "Edición actualizada.");
                cargarTabla();
            } else {
                JOptionPane.showMessageDialog(this, "No existe una edición con ese ID.");
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error al actualizar: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void eliminarEdicion() {
        try {
            int id = Integer.parseInt(txtId.getText().trim());
            int filas = edicionDao.eliminarEdicion(id);
            if (filas > 0) {
                JOptionPane.showMessageDialog(this, "Edición eliminada.");
                cargarTabla();
            } else {
                JOptionPane.showMessageDialog(this, "No se encontró el ID.");
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error al eliminar: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }
}

