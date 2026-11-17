package vista;

import dao.*;
import entidades.*;
import repositorios.*;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;

public class PanelUbicaciones extends JPanel {

    private final SedeDao sedeDao = new SedeDaoImpl();
    private final CiudadDao ciudadDao = new CiudadDaoImpl();
    private final EstadioDao estadioDao = new EstadioDaoImpl();

    public PanelUbicaciones() {
        setLayout(new BorderLayout());
        JTabbedPane tabs = new JTabbedPane();
        tabs.addTab("Sedes", crearPanelSedes());
        tabs.addTab("Ciudades", crearPanelCiudades());
        tabs.addTab("Estadios", crearPanelEstadios());
        add(tabs, BorderLayout.CENTER);
    }

    private JPanel crearPanelSedes() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(1, 6, 5, 5));
        JTextField txtId = new JTextField(), txtEdicion = new JTextField(), txtPais = new JTextField();
        form.add(new JLabel("ID Sede:")); form.add(txtId);
        form.add(new JLabel("ID Edición:")); form.add(txtEdicion);
        form.add(new JLabel("País:")); form.add(txtPais);

        DefaultTableModel modelo = new DefaultTableModel(new String[]{"ID Sede", "ID Edición", "País"}, 0);
        JTable tabla = new JTable(modelo);

        JPanel botones = new JPanel();
        JButton btnGuardar = new JButton("Guardar"), btnActualizar = new JButton("Actualizar"), btnEliminar = new JButton("Eliminar"), btnListar = new JButton("Refrescar");
        botones.add(btnGuardar); botones.add(btnActualizar); botones.add(btnEliminar); botones.add(btnListar);

        Runnable cargar = () -> {
            modelo.setRowCount(0);
            sedeDao.obtenerTodasSedes().forEach(s -> modelo.addRow(new Object[]{s.getIdSede(), s.getIdEdicion(), s.getPais()}));
        };

        btnGuardar.addActionListener(e -> {
            try {
                sedeDao.guardarSede(new Sede(Integer.parseInt(txtId.getText()), Integer.parseInt(txtEdicion.getText()), txtPais.getText()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnActualizar.addActionListener(e -> {
            try {
                sedeDao.actualizarSede(new Sede(Integer.parseInt(txtId.getText()), Integer.parseInt(txtEdicion.getText()), txtPais.getText()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnEliminar.addActionListener(e -> {
            try {
                sedeDao.eliminarSede(Integer.parseInt(txtId.getText()));
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

    private JPanel crearPanelCiudades() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(1, 6, 5, 5));
        JTextField txtId = new JTextField(), txtSede = new JTextField(), txtNombre = new JTextField();
        form.add(new JLabel("ID Ciudad:")); form.add(txtId);
        form.add(new JLabel("ID Sede:")); form.add(txtSede);
        form.add(new JLabel("Nombre:")); form.add(txtNombre);

        DefaultTableModel modelo = new DefaultTableModel(new String[]{"ID Ciudad", "ID Sede", "Nombre"}, 0);
        JTable tabla = new JTable(modelo);

        JPanel botones = new JPanel();
        JButton btnGuardar = new JButton("Guardar"), btnActualizar = new JButton("Actualizar"), btnEliminar = new JButton("Eliminar"), btnListar = new JButton("Refrescar");
        botones.add(btnGuardar); botones.add(btnActualizar); botones.add(btnEliminar); botones.add(btnListar);

        Runnable cargar = () -> {
            modelo.setRowCount(0);
            ciudadDao.obtenerTodasCiudad().forEach(c -> modelo.addRow(new Object[]{c.getIdCiudad(), c.getIdSede(), c.getNombre()}));
        };

        btnGuardar.addActionListener(e -> {
            try {
                ciudadDao.guardarCiudad(new Ciudad(Integer.parseInt(txtId.getText()), Integer.parseInt(txtSede.getText()), txtNombre.getText()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnActualizar.addActionListener(e -> {
            try {
                ciudadDao.actualizarCiudad(new Ciudad(Integer.parseInt(txtId.getText()), Integer.parseInt(txtSede.getText()), txtNombre.getText()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnEliminar.addActionListener(e -> {
            try {
                ciudadDao.eliminarCiudad(Integer.parseInt(txtId.getText()));
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

    private JPanel crearPanelEstadios() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(2, 4, 5, 5));
        JTextField txtId = new JTextField(), txtCiudad = new JTextField(), txtNombre = new JTextField(), txtCap = new JTextField();
        form.add(new JLabel("ID Estadio:")); form.add(txtId);
        form.add(new JLabel("ID Ciudad:")); form.add(txtCiudad);
        form.add(new JLabel("Nombre:")); form.add(txtNombre);
        form.add(new JLabel("Capacidad:")); form.add(txtCap);

        DefaultTableModel modelo = new DefaultTableModel(new String[]{"ID Estadio", "ID Ciudad", "Nombre", "Capacidad"}, 0);
        JTable tabla = new JTable(modelo);

        JPanel botones = new JPanel();
        JButton btnGuardar = new JButton("Guardar"), btnActualizar = new JButton("Actualizar"), btnEliminar = new JButton("Eliminar"), btnListar = new JButton("Refrescar");
        botones.add(btnGuardar); botones.add(btnActualizar); botones.add(btnEliminar); botones.add(btnListar);

        Runnable cargar = () -> {
            modelo.setRowCount(0);
            estadioDao.obtenerTodosEstadio().forEach(es -> modelo.addRow(new Object[]{es.getIdEstadio(), es.getIdCiudad(), es.getNombre(), es.getCapacidad()}));
        };

        btnGuardar.addActionListener(e -> {
            try {
                estadioDao.guardarEstadio(new Estadio(Integer.parseInt(txtId.getText()), Integer.parseInt(txtCiudad.getText()), txtNombre.getText(), Integer.parseInt(txtCap.getText())));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnActualizar.addActionListener(e -> {
            try {
                estadioDao.actualizarEstadio(new Estadio(Integer.parseInt(txtId.getText()), Integer.parseInt(txtCiudad.getText()), txtNombre.getText(), Integer.parseInt(txtCap.getText())));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnEliminar.addActionListener(e -> {
            try {
                estadioDao.eliminarEstadio(Integer.parseInt(txtId.getText()));
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
