package vista;

import dao.ReporteDao;
import repositorios.ReporteDaoImpl;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class PanelReportes extends JPanel {

    private final ReporteDao reporteDao = new ReporteDaoImpl();
    private JTextField txtEdicion, txtEtapaGrupo, txtSeleccion, txtTopGoleadores;
    private DefaultTableModel modeloTabla;
    private JTextArea areaGoleadores;

    public PanelReportes() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // --- Panel superior de filtros ---
        JPanel panelFiltros = new JPanel(new GridLayout(2, 4, 8, 8));
        panelFiltros.setBorder(BorderFactory.createTitledBorder("Filtros de Consulta y Reportes"));

        txtEdicion = new JTextField("1");
        txtEtapaGrupo = new JTextField();
        txtSeleccion = new JTextField();
        txtTopGoleadores = new JTextField("5");

        panelFiltros.add(new JLabel("ID Edición (Obligatorio):"));
        panelFiltros.add(txtEdicion);
        panelFiltros.add(new JLabel("ID Grupo / Fase (Opcional en Res/Inc):"));
        panelFiltros.add(txtEtapaGrupo);
        panelFiltros.add(new JLabel("ID Selección (Opcional en Res):"));
        panelFiltros.add(txtSeleccion);
        panelFiltros.add(new JLabel("Top Goleadores:"));
        panelFiltros.add(txtTopGoleadores);

        // --- Botones de acción ---
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JButton btnPosiciones = new JButton("Tabla de Posiciones");
        JButton btnResultados = new JButton("Resultados Consolidados");
        JButton btnIncidencias = new JButton("Incidencias");
        JButton btnGoleadores = new JButton("Ranking Goleadores");

        panelBotones.add(btnPosiciones);
        panelBotones.add(btnResultados);
        panelBotones.add(btnIncidencias);
        panelBotones.add(btnGoleadores);

        JPanel panelNorte = new JPanel(new BorderLayout());
        panelNorte.add(panelFiltros, BorderLayout.CENTER);
        panelNorte.add(panelBotones, BorderLayout.SOUTH);
        add(panelNorte, BorderLayout.NORTH);

        // --- Centro: Tabla para reportes tabulares ---
        modeloTabla = new DefaultTableModel();
        JTable tabla = new JTable(modeloTabla);
        add(new JScrollPane(tabla), BorderLayout.CENTER);

        // --- Derecha: Área de texto para la salida de fn_ranking_goleadores ---
        areaGoleadores = new JTextArea(15, 28);
        areaGoleadores.setEditable(false);
        areaGoleadores.setBorder(BorderFactory.createTitledBorder("Goleadores (fn_ranking_goleadores)"));
        add(new JScrollPane(areaGoleadores), BorderLayout.EAST);

        // --- Eventos ---
        btnPosiciones.addActionListener(e -> cargarPosiciones());
        btnResultados.addActionListener(e -> cargarResultados());
        btnIncidencias.addActionListener(e -> cargarIncidencias());
        btnGoleadores.addActionListener(e -> cargarGoleadores());
    }

    private Integer leerEnteroOpcional(JTextField campo) {
        String texto = campo.getText().trim();
        return texto.isEmpty() ? null : Integer.parseInt(texto);
    }

    private void cargarPosiciones() {
        try {
            int idGrupo = Integer.parseInt(txtEtapaGrupo.getText().trim());
            modeloTabla.setColumnIdentifiers(new String[]{"Pos", "FIFA", "PJ", "PG", "PE", "PP", "GF", "GC", "DG", "Pts"});
            modeloTabla.setRowCount(0);

            List<Object[]> filas = reporteDao.actualizarYConsultarPosiciones(idGrupo);
            for (Object[] f : filas) modeloTabla.addRow(f);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Ingresa un ID de Grupo válido.\nDetalle: " + ex.getMessage(), "Aviso", JOptionPane.WARNING_MESSAGE);
        }
    }

    private void cargarResultados() {
        try {
            int idEdicion = Integer.parseInt(txtEdicion.getText().trim());
            Integer idEtapa = leerEnteroOpcional(txtEtapaGrupo);
            Integer idSel = leerEnteroOpcional(txtSeleccion);

            modeloTabla.setColumnIdentifiers(new String[]{"Partido", "Fecha", "Etapa", "Estadio", "Local", "Goles L", "Visitante", "Goles V", "Estado"});
            modeloTabla.setRowCount(0);

            List<Object[]> filas = reporteDao.obtenerResultadosConsolidados(idEdicion, idSel, idEtapa);
            for (Object[] f : filas) modeloTabla.addRow(f);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void cargarIncidencias() {
        try {
            int idEdicion = Integer.parseInt(txtEdicion.getText().trim());
            Integer idEtapa = leerEnteroOpcional(txtEtapaGrupo);

            modeloTabla.setColumnIdentifiers(new String[]{"Partido", "Etapa", "Tipo Evento", "Minuto", "Jugador", "Descripción"});
            modeloTabla.setRowCount(0);

            List<Object[]> filas = reporteDao.obtenerIncidencias(idEdicion, idEtapa);
            for (Object[] f : filas) modeloTabla.addRow(f);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void cargarGoleadores() {
        try {
            int idEdicion = Integer.parseInt(txtEdicion.getText().trim());
            int top = Integer.parseInt(txtTopGoleadores.getText().trim());
            String ranking = reporteDao.obtenerRankingGoleadoresTexto(idEdicion, top);
            areaGoleadores.setText(ranking);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }
}
