package vista;

import dao.*;
import entidades.*;
import repositorios.*;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.Timestamp;

public class PanelPartidos extends JPanel {

    private final PartidoDao partidoDao = new PartidoDaoImpl();
    private final ParticipacionPartidoDao partDao = new ParticipacionPartidoDaoImpl();
    private final EventoPartidoDao eventoDao = new EventoPartidoDaoImpl();

    public PanelPartidos() {
        setLayout(new BorderLayout());
        JTabbedPane tabs = new JTabbedPane();
        tabs.addTab("1. Registrar Partido", crearPanelPartido());
        tabs.addTab("2. Participaciones (Local / Visitante)", crearPanelParticipacion());
        tabs.addTab("3. Eventos y Estadísticas", crearPanelEventos());
        add(tabs, BorderLayout.CENTER);
    }

    private JPanel crearPanelPartido() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(5, 4, 5, 5));
        JTextField txtId = new JTextField(), txtEtapa = new JTextField(), txtEstadio = new JTextField(),
                txtFecha = new JTextField("2026-06-15 15:00:00"), txtAsistencia = new JTextField("0"),
                txtOrig1 = new JTextField(), txtOrig2 = new JTextField();
        JComboBox<String> cmbEstado = new JComboBox<>(new String[]{"PROGRAMADO", "EN_JUEGO", "FINALIZADO"});
        JComboBox<String> cmbRes1 = new JComboBox<>(new String[]{"", "GANADOR", "PERDEDOR"});
        JComboBox<String> cmbRes2 = new JComboBox<>(new String[]{"", "GANADOR", "PERDEDOR"});

        form.add(new JLabel("ID Partido:")); form.add(txtId);
        form.add(new JLabel("ID Etapa:")); form.add(txtEtapa);
        form.add(new JLabel("ID Estadio:")); form.add(txtEstadio);
        form.add(new JLabel("Fecha (AAAA-MM-DD HH:MM:SS):")); form.add(txtFecha);
        form.add(new JLabel("Asistencia:")); form.add(txtAsistencia);
        form.add(new JLabel("Estado:")); form.add(cmbEstado);
        form.add(new JLabel("ID Origen 1 (Opc):")); form.add(txtOrig1);
        form.add(new JLabel("Res Origen 1:")); form.add(cmbRes1);
        form.add(new JLabel("ID Origen 2 (Opc):")); form.add(txtOrig2);
        form.add(new JLabel("Res Origen 2:")); form.add(cmbRes2);

        DefaultTableModel modelo = new DefaultTableModel(new String[]{"ID", "Etapa", "Estadio", "Fecha", "Asistencia", "Estado"}, 0);
        JTable tabla = new JTable(modelo);

        JButton btnGuardar = new JButton("Registrar Partido");
        JButton btnListar = new JButton("Refrescar");
        JPanel botones = new JPanel(); botones.add(btnGuardar); botones.add(btnListar);

        Runnable cargar = () -> {
            modelo.setRowCount(0);
            partidoDao.obtenerTodos().forEach(pa -> modelo.addRow(new Object[]{pa.getIdPartido(), pa.getIdEtapa(), pa.getIdEstadio(), pa.getFechaHora(), pa.getAsistenciaRegistrada(), pa.getEstado()}));
        };

        btnGuardar.addActionListener(e -> {
            try {
                Integer o1 = txtOrig1.getText().trim().isEmpty() ? null : Integer.parseInt(txtOrig1.getText().trim());
                Integer o2 = txtOrig2.getText().trim().isEmpty() ? null : Integer.parseInt(txtOrig2.getText().trim());
                String r1 = cmbRes1.getSelectedItem().toString().isEmpty() ? null : cmbRes1.getSelectedItem().toString();
                String r2 = cmbRes2.getSelectedItem().toString().isEmpty() ? null : cmbRes2.getSelectedItem().toString();

                partidoDao.registrar(new Partido(
                        Integer.parseInt(txtId.getText()), Integer.parseInt(txtEtapa.getText()), Integer.parseInt(txtEstadio.getText()),
                        o1, o2, Timestamp.valueOf(txtFecha.getText().trim()), Integer.parseInt(txtAsistencia.getText()),
                        (String) cmbEstado.getSelectedItem(), r1, r2
                ));
                JOptionPane.showMessageDialog(this, "Partido registrado.");
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

    private JPanel crearPanelParticipacion() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(4, 4, 5, 5));
        JTextField txtId = new JTextField(), txtPartido = new JTextField(), txtSel = new JTextField(),
                txtGoles = new JTextField("0"), txtPenales = new JTextField("0");
        JComboBox<String> cmbCond = new JComboBox<>(new String[]{"LOCAL", "VISITANTE"});
        JComboBox<String> cmbRes = new JComboBox<>(new String[]{"", "GANO", "PERDIO", "EMPATO"});

        form.add(new JLabel("ID Participación:")); form.add(txtId);
        form.add(new JLabel("ID Partido:")); form.add(txtPartido);
        form.add(new JLabel("ID Selección:")); form.add(txtSel);
        form.add(new JLabel("Condición:")); form.add(cmbCond);
        form.add(new JLabel("Goles:")); form.add(txtGoles);
        form.add(new JLabel("Goles Penales:")); form.add(txtPenales);
        form.add(new JLabel("Resultado:")); form.add(cmbRes);

        JButton btnGuardar = new JButton("Registrar Participación");
        btnGuardar.addActionListener(e -> {
            try {
                String res = cmbRes.getSelectedItem().toString().isEmpty() ? null : cmbRes.getSelectedItem().toString();
                partDao.registrar(new ParticipacionPartido(
                        Integer.parseInt(txtId.getText()), Integer.parseInt(txtPartido.getText()), Integer.parseInt(txtSel.getText()),
                        (String) cmbCond.getSelectedItem(), Integer.parseInt(txtGoles.getText()), Integer.parseInt(txtPenales.getText()), res
                ));
                JOptionPane.showMessageDialog(this, "Participación registrada con éxito.");
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });

        p.add(form, BorderLayout.NORTH);
        p.add(btnGuardar, BorderLayout.SOUTH);
        return p;
    }

    private JPanel crearPanelEventos() {
        JPanel p = new JPanel(new BorderLayout(8, 8));
        JPanel form = new JPanel(new GridLayout(4, 4, 5, 5));
        JTextField txtId = new JTextField(), txtPartido = new JTextField(), txtPersona = new JTextField(),
                txtRel = new JTextField(), txtMinuto = new JTextField(), txtValor = new JTextField(), txtDesc = new JTextField();
        JComboBox<String> cmbTipo = new JComboBox<>(new String[]{"GOL", "ASISTENCIA", "TARJETA_AMARILLA", "TARJETA_ROJA", "SUSTITUCION", "MINUTOS_JUGADOS"});

        form.add(new JLabel("ID Evento:")); form.add(txtId);
        form.add(new JLabel("ID Partido:")); form.add(txtPartido);
        form.add(new JLabel("ID Persona (Opc):")); form.add(txtPersona);
        form.add(new JLabel("ID Persona Rel (Opc):")); form.add(txtRel);
        form.add(new JLabel("Tipo Evento:")); form.add(cmbTipo);
        form.add(new JLabel("Minuto (Opc):")); form.add(txtMinuto);
        form.add(new JLabel("Valor Numérico (Opc):")); form.add(txtValor);
        form.add(new JLabel("Descripción:")); form.add(txtDesc);

        JButton btnGuardar = new JButton("Registrar Evento / Estadística");
        btnGuardar.addActionListener(e -> {
            try {
                Integer per = txtPersona.getText().trim().isEmpty() ? null : Integer.parseInt(txtPersona.getText().trim());
                Integer rel = txtRel.getText().trim().isEmpty() ? null : Integer.parseInt(txtRel.getText().trim());
                Integer min = txtMinuto.getText().trim().isEmpty() ? null : Integer.parseInt(txtMinuto.getText().trim());
                Integer val = txtValor.getText().trim().isEmpty() ? null : Integer.parseInt(txtValor.getText().trim());

                eventoDao.registrar(new EventoPartido(
                        Integer.parseInt(txtId.getText()), Integer.parseInt(txtPartido.getText()), per, rel,
                        (String) cmbTipo.getSelectedItem(), min, val, txtDesc.getText()
                ));
                JOptionPane.showMessageDialog(this, "Evento registrado correctamente.");
            } catch (Exception ex) { JOptionPane.showMessageDialog(this, ex.getMessage()); }
        });

        p.add(form, BorderLayout.NORTH);
        p.add(btnGuardar, BorderLayout.SOUTH);
        return p;
    }
}

