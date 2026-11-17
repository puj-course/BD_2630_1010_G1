package vista;

import dao.*;
import entidades.*;
import repositorios.*;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;

public class PanelSelecciones extends JPanel {

    private final OrganizacionFutbolDao orgDao = new OrganizacionFutbolDaoImpl();
    private final EtapaCompetenciaDao etapaDao = new EtapaCompetenciaDaoImpl();
    private final SeleccionDao seleccionDao = new SeleccionDaoImpl();

    public PanelSelecciones() {
        setLayout(new BorderLayout());
        JTabbedPane tabs = new JTabbedPane();
        tabs.addTab("Organizaciones (Conf/Fed)", crearPanelOrganizaciones());
        tabs.addTab("Etapas y Grupos", crearPanelEtapas());
        tabs.addTab("Selecciones", crearPanelSelecciones());
        add(tabs, BorderLayout.CENTER);
    }

    private JPanel crearPanelOrganizaciones() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(3, 4, 5, 5));
        JTextField txtId = new JTextField(), txtNombre = new JTextField(), txtPais = new JTextField(), txtPadre = new JTextField();
        JComboBox<String> cmbTipo = new JComboBox<>(new String[]{"CONFEDERACION", "FEDERACION_NACIONAL"});

        form.add(new JLabel("ID Org:")); form.add(txtId);
        form.add(new JLabel("Nombre:")); form.add(txtNombre);
        form.add(new JLabel("Tipo:")); form.add(cmbTipo);
        form.add(new JLabel("País:")); form.add(txtPais);
        form.add(new JLabel("ID Org Padre (Opcional):")); form.add(txtPadre);

        DefaultTableModel modelo = new DefaultTableModel(new String[]{"ID", "Nombre", "Tipo", "País", "ID Padre"}, 0);
        JTable tabla = new JTable(modelo);

        JPanel botones = new JPanel();
        JButton btnGuardar = new JButton("Guardar"), btnActualizar = new JButton("Actualizar"), btnEliminar = new JButton("Eliminar"), btnListar = new JButton("Refrescar");
        botones.add(btnGuardar); botones.add(btnActualizar); botones.add(btnEliminar); botones.add(btnListar);

        Runnable cargar = () -> {
            modelo.setRowCount(0);
            orgDao.obtenerOrganizaciones().forEach(o -> modelo.addRow(new Object[]{o.getIdOrganizacion(), o.getNombre(), o.getTipo(), o.getPais(), o.getIdOrganizacionPadre()}));
        };

        btnGuardar.addActionListener(e -> {
            try {
                Integer padre = txtPadre.getText().trim().isEmpty() ? null : Integer.parseInt(txtPadre.getText().trim());
                orgDao.guardarOrganizacion(new OrganizacionFutbol(Integer.parseInt(txtId.getText()), txtNombre.getText(), (String) cmbTipo.getSelectedItem(), txtPais.getText(), padre));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnActualizar.addActionListener(e -> {
            try {
                Integer padre = txtPadre.getText().trim().isEmpty() ? null : Integer.parseInt(txtPadre.getText().trim());
                orgDao.actualizarOrganizacion(new OrganizacionFutbol(Integer.parseInt(txtId.getText()), txtNombre.getText(), (String) cmbTipo.getSelectedItem(), txtPais.getText(), padre));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnEliminar.addActionListener(e -> {
            try {
                orgDao.eliminarOrganizacion(Integer.parseInt(txtId.getText()));
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

    private JPanel crearPanelEtapas() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(3, 4, 5, 5));
        JTextField txtId = new JTextField(), txtEdicion = new JTextField(), txtPadre = new JTextField(), txtNombre = new JTextField(), txtOrden = new JTextField();
        JComboBox<String> cmbTipo = new JComboBox<>(new String[]{"FASE", "GRUPO", "INSTANCIA_ELIMINATORIA"});

        form.add(new JLabel("ID Etapa:")); form.add(txtId);
        form.add(new JLabel("ID Edición:")); form.add(txtEdicion);
        form.add(new JLabel("ID Etapa Padre (Opcional):")); form.add(txtPadre);
        form.add(new JLabel("Nombre:")); form.add(txtNombre);
        form.add(new JLabel("Tipo Etapa:")); form.add(cmbTipo);
        form.add(new JLabel("Orden:")); form.add(txtOrden);

        DefaultTableModel modelo = new DefaultTableModel(new String[]{"ID", "Edición", "Padre", "Nombre", "Tipo", "Orden"}, 0);
        JTable tabla = new JTable(modelo);

        JPanel botones = new JPanel();
        JButton btnGuardar = new JButton("Guardar"), btnActualizar = new JButton("Actualizar"), btnEliminar = new JButton("Eliminar"), btnListar = new JButton("Refrescar");
        botones.add(btnGuardar); botones.add(btnActualizar); botones.add(btnEliminar); botones.add(btnListar);

        Runnable cargar = () -> {
            modelo.setRowCount(0);
            etapaDao.obtenerTodasEtapaCompetencia().forEach(et -> modelo.addRow(new Object[]{et.getIdEtapa(), et.getIdEdicion(), et.getIdEtapaPadre(), et.getNombre(), et.getTipoEtapa(), et.getOrden()}));
        };

        btnGuardar.addActionListener(e -> {
            try {
                Integer padre = txtPadre.getText().trim().isEmpty() ? null : Integer.parseInt(txtPadre.getText().trim());
                etapaDao.guardarEtapa(new EtapaCompetencia(Integer.parseInt(txtId.getText()), Integer.parseInt(txtEdicion.getText()), padre, txtNombre.getText(), (String) cmbTipo.getSelectedItem(), Integer.parseInt(txtOrden.getText())));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnActualizar.addActionListener(e -> {
            try {
                Integer padre = txtPadre.getText().trim().isEmpty() ? null : Integer.parseInt(txtPadre.getText().trim());
                etapaDao.actualizarEtapaCompetencia(new EtapaCompetencia(Integer.parseInt(txtId.getText()), Integer.parseInt(txtEdicion.getText()), padre, txtNombre.getText(), (String) cmbTipo.getSelectedItem(), Integer.parseInt(txtOrden.getText())));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnEliminar.addActionListener(e -> {
            try {
                etapaDao.eliminarEtapa(Integer.parseInt(txtId.getText()));
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

    private JPanel crearPanelSelecciones() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(2, 4, 5, 5));
        JTextField txtId = new JTextField(), txtOrg = new JTextField(), txtGrupo = new JTextField(), txtFifa = new JTextField();
        form.add(new JLabel("ID Selección:")); form.add(txtId);
        form.add(new JLabel("ID Organización:")); form.add(txtOrg);
        form.add(new JLabel("ID Etapa Grupo:")); form.add(txtGrupo);
        form.add(new JLabel("Código FIFA (3 letras):")); form.add(txtFifa);

        DefaultTableModel modelo = new DefaultTableModel(new String[]{"ID Selección", "ID Org", "ID Grupo", "Código FIFA"}, 0);
        JTable tabla = new JTable(modelo);

        JPanel botones = new JPanel();
        JButton btnGuardar = new JButton("Guardar"), btnActualizar = new JButton("Actualizar"), btnEliminar = new JButton("Eliminar"), btnListar = new JButton("Refrescar");
        botones.add(btnGuardar); botones.add(btnActualizar); botones.add(btnEliminar); botones.add(btnListar);

        Runnable cargar = () -> {
            modelo.setRowCount(0);
            seleccionDao.obtenerTodasSeleccion().forEach(s -> modelo.addRow(new Object[]{s.getIdSeleccion(), s.getIdOrganizacion(), s.getIdEtapaGrupo(), s.getCodigoFifa()}));
        };

        btnGuardar.addActionListener(e -> {
            try {
                seleccionDao.guardarSeleccion(new Seleccion(Integer.parseInt(txtId.getText()), Integer.parseInt(txtOrg.getText()), Integer.parseInt(txtGrupo.getText()), txtFifa.getText().toUpperCase()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnActualizar.addActionListener(e -> {
            try {
                seleccionDao.actualizarSeleccion(new Seleccion(Integer.parseInt(txtId.getText()), Integer.parseInt(txtOrg.getText()), Integer.parseInt(txtGrupo.getText()), txtFifa.getText().toUpperCase()));
                cargar.run();
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });
        btnEliminar.addActionListener(e -> {
            try {
                seleccionDao.eliminarSeleccion(Integer.parseInt(txtId.getText()));
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

