package vista;

import dao.*;
import entidades.*;
import repositorios.*;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.Date;

public class PanelPlanteles extends JPanel {

    private final PersonaDao personaDao = new PersonaDaoImpl();
    private final VinculacionSeleccionDao vinculacionDao = new VinculacionSeleccionDaoImpl();

    public PanelPlanteles() {
        setLayout(new BorderLayout());
        JTabbedPane tabs = new JTabbedPane();
        tabs.addTab("Personas", crearPanelPersonas());
        tabs.addTab("Convocatorias (Jugadores / Cuerpo Técnico)", crearPanelVinculaciones());
        add(tabs, BorderLayout.CENTER);
    }

    private JPanel crearPanelPersonas() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(2, 4, 5, 5));
        JTextField txtId = new JTextField(), txtNombre = new JTextField(), txtNac = new JTextField(), txtFecha = new JTextField("1998-05-15");
        form.add(new JLabel("ID Persona:")); form.add(txtId);
        form.add(new JLabel("Nombre Completo:")); form.add(txtNombre);
        form.add(new JLabel("Nacionalidad:")); form.add(txtNac);
        form.add(new JLabel("Fecha Nac (AAAA-MM-DD):")); form.add(txtFecha);

        DefaultTableModel modelo = new DefaultTableModel(new String[]{"ID", "Nombre Completo", "Nacionalidad", "Fecha Nacimiento"}, 0);
        JTable tabla = new JTable(modelo);

        JPanel botones = new JPanel();
        JButton btnGuardar = new JButton("Guardar"), btnActualizar = new JButton("Actualizar"), btnEliminar = new JButton("Eliminar"), btnListar = new JButton("Refrescar");
        botones.add(btnGuardar); botones.add(btnActualizar); botones.add(btnEliminar); botones.add(btnListar);

        Runnable cargar = () -> {
            modelo.setRowCount(0);
            personaDao.obtenerTodas().forEach(per -> modelo.addRow(new Object[]{per.getIdPersona(), per.getNombreCompleto(), per.getNacionalidad(), per.getFechaDeNacimiento()}));
        };

        btnGuardar.addActionListener(e -> {
            try {
                Date fec = txtFecha.getText().trim().isEmpty() ? null : Date.valueOf(txtFecha.getText().trim());
                personaDao.guardar(new Persona(Integer.parseInt(txtId.getText()), txtNombre.getText(), txtNac.getText(), fec));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnActualizar.addActionListener(e -> {
            try {
                Date fec = txtFecha.getText().trim().isEmpty() ? null : Date.valueOf(txtFecha.getText().trim());
                personaDao.actualizar(new Persona(Integer.parseInt(txtId.getText()), txtNombre.getText(), txtNac.getText(), fec));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnEliminar.addActionListener(e -> {
            try {
                personaDao.eliminar(Integer.parseInt(txtId.getText()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnListar.addActionListener(e -> cargar.run());
        cargar.run();

        JPanel norte = new JPanel(new BorderLayout());
        norte.add(form, BorderLayout.CENTER); norte.add(botones, BorderLayout.SOUTH);
        p.add(norte, BorderLayout.NORTH); p.add(new JScrollPane(tabla), BorderLayout.CENTER);
        return p;
    }

    private JPanel crearPanelVinculaciones() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(4, 4, 5, 5));
        JTextField txtId = new JTextField(), txtPer = new JTextField(), txtSel = new JTextField(), txtDorsal = new JTextField(), txtPos = new JTextField(), txtClub = new JTextField();
        JComboBox<String> cmbCap = new JComboBox<>(new String[]{"N", "S"});
        JComboBox<String> cmbRol = new JComboBox<>(new String[]{"JUGADOR", "DIRECTOR_TECNICO", "ASISTENTE", "PREPARADOR_FISICO"});

        form.add(new JLabel("ID Vinculación:")); form.add(txtId);
        form.add(new JLabel("ID Persona:")); form.add(txtPer);
        form.add(new JLabel("ID Selección:")); form.add(txtSel);
        form.add(new JLabel("Rol:")); form.add(cmbRol);
        form.add(new JLabel("Capitán:")); form.add(cmbCap);
        form.add(new JLabel("Dorsal (Opcional):")); form.add(txtDorsal);
        form.add(new JLabel("Posición (Opcional):")); form.add(txtPos);
        form.add(new JLabel("Club (Opcional):")); form.add(txtClub);

        DefaultTableModel modelo = new DefaultTableModel(new String[]{"ID", "Persona", "Selección", "Rol", "Cap", "Dorsal", "Posición", "Club"}, 0);
        JTable tabla = new JTable(modelo);

        JPanel botones = new JPanel();
        JButton btnGuardar = new JButton("Guardar"), btnActualizar = new JButton("Actualizar"), btnEliminar = new JButton("Eliminar"), btnListar = new JButton("Refrescar");
        botones.add(btnGuardar); botones.add(btnActualizar); botones.add(btnEliminar); botones.add(btnListar);

        Runnable cargar = () -> {
            modelo.setRowCount(0);
            vinculacionDao.obtenerTodas().forEach(v -> modelo.addRow(new Object[]{v.getIdVinculacion(), v.getIdPersona(), v.getIdSeleccion(), v.getRol(), v.getCapitan(), v.getDorsal(), v.getPosicion(), v.getClub()}));
        };

        btnGuardar.addActionListener(e -> {
            try {
                Integer dorsal = txtDorsal.getText().trim().isEmpty() ? null : Integer.parseInt(txtDorsal.getText().trim());
                vinculacionDao.guardar(new VinculacionSeleccion(Integer.parseInt(txtId.getText()), Integer.parseInt(txtPer.getText()), Integer.parseInt(txtSel.getText()), (String) cmbCap.getSelectedItem(), dorsal, txtPos.getText(), (String) cmbRol.getSelectedItem(), txtClub.getText()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnActualizar.addActionListener(e -> {
            try {
                Integer dorsal = txtDorsal.getText().trim().isEmpty() ? null : Integer.parseInt(txtDorsal.getText().trim());
                vinculacionDao.actualizar(new VinculacionSeleccion(Integer.parseInt(txtId.getText()), Integer.parseInt(txtPer.getText()), Integer.parseInt(txtSel.getText()), (String) cmbCap.getSelectedItem(), dorsal, txtPos.getText(), (String) cmbRol.getSelectedItem(), txtClub.getText()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnEliminar.addActionListener(e -> {
            try {
                vinculacionDao.eliminar(Integer.parseInt(txtId.getText()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnListar.addActionListener(e -> cargar.run());
        cargar.run();

        JPanel norte = new JPanel(new BorderLayout());
        norte.add(form, BorderLayout.CENTER); norte.add(botones, BorderLayout.SOUTH);
        p.add(norte, BorderLayout.NORTH); p.add(new JScrollPane(tabla), BorderLayout.CENTER);
        return p;
    }
}

