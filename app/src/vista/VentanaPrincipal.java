package vista;

import javax.swing.*;
import java.awt.*;

public class VentanaPrincipal extends JFrame {

    public VentanaPrincipal() {
        setTitle("Sistema de Gestión - Copa Mundial de la FIFA");
        setSize(950, 620);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null); // Centrar en pantalla

        JTabbedPane pestanas = new JTabbedPane();

        // Pestaña 1: Administración de Catálogos (puedes agregar sub-pestañas para Sedes, Estadios, etc.)
        // En VentanaPrincipal.java dentro del constructor:
        JTabbedPane pestanasCatalogos = new JTabbedPane();
        pestanasCatalogos.addTab("Edición Mundial", new PanelEdiciones());
        pestanasCatalogos.addTab("Sedes, Ciudades y Estadios", new PanelUbicaciones());
        pestanasCatalogos.addTab("Selecciones y Grupos", new PanelSelecciones());
        pestanasCatalogos.addTab("Jugadores y Cuerpo Técnico", new PanelPlanteles());

        pestanas.addTab("1. Catálogos", pestanasCatalogos);
        pestanas.addTab("2. Registro Partidos y Estadísticas", new PanelPartidos());
        pestanas.addTab("3. Consultas y Reportes", new PanelReportes());


        add(pestanas, BorderLayout.CENTER);
    }

    public static void main(String[] args) {
        // Aplicar estilo visual nativo del sistema operativo (Windows)
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignored) {}

        SwingUtilities.invokeLater(() -> {
            new VentanaPrincipal().setVisible(true);
        });
    }
}
