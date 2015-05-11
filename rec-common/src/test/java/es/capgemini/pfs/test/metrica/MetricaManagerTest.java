package es.capgemini.pfs.test.metrica;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

import java.io.IOException;

import org.junit.Test;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.metrica.MetricaFileReader;
import es.capgemini.pfs.upload.dto.DtoFileUpload;

/**
 * Prueba las funciones del manager de metricas.
 * @author aesteban
 *
 */

public class MetricaManagerTest extends MetricaCommonTestAbstract {

    /**
     * Test para verificar que se carga una metrica valida.
     */
    @Test
    public void cargarMetricaValida() {
        borrarMetricasCargadas();
        getMetricaManager().cargarMetrica(crearWebFileItem("metricasTest.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS));
        verificarMetricaCargada("metricasTest.csv");
    }

    /**
     * Test para verificar que se cargas consecutivas de metricas valida.
     */
    @Test
    public void cargarMetricaConscutivasValidas() {
        borrarMetricasCargadas();
        getMetricaManager().cargarMetrica(crearWebFileItem("metricasTest.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS));
        getMetricaManager().cargarMetrica(crearWebFileItem("metricasTestValido.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS));
        verificarMetricaCargada("metricasTestValido.csv");
    }

    /**
     * Test para verificar que se carga una metrica incompleta pero que
     * es valida porque existe una default..
     */
    @Test
    public void cargarMetricaInvalidaConMetricaPrevia() {
        borrarMetricasCargadas();
        //cargar metrica por default valida
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS);

        //cargar metrica para 2 tipos de alertas
        DtoFileUpload dto = getMetricaManager().cargarMetrica(crearWebFileItem("metricasRangoSinCobertura.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS));
        assertFalse("Debería haber fallado", dto.isValido());
    }

    /**
     * Test para verificar que se carga una metrica invalida.
     */
    @Test
    public void cargarMetricaInvalida() {
        borrarMetricasCargadas();
        DtoFileUpload dto = getMetricaManager().cargarMetrica(crearWebFileItem("metricasCantidadAlertasTest.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS));
        assertFalse("Debería haber fallado", dto.isValido());
    }

    /**
     * Test para verificar que se descarga una metrica.
     * @throws IOException error de lectura/escritura
     */
    @Test
    public void descargarMetrica() throws IOException {
        borrarMetricasCargadas();
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, null);
        cargarYActivarMetrica("metricasBlancosTest.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS);
        cargarYActivarMetrica("metricasRangoSinCobertura.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_CONSEJEROS);
        FileItem fileItem = getMetricaManager().descargarMetrica(crearDto(TIPO_PERSONA_FISICA, null));
        assertEquals("metricasTest.csv", fileItem.getFile().getName());
        MetricaFileReader parser = new MetricaFileReader(fileItem.getFile());
        assertEquals(3, parser.getCantidadNivelesGravedad());
        assertEquals(3, parser.getRowCount());

        fileItem = getMetricaManager().descargarMetrica(crearDto(TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS));
        assertEquals("metricasBlancosTest.csv", fileItem.getFile().getName());
        parser = new MetricaFileReader(fileItem.getFile());
        assertEquals(3, parser.getCantidadNivelesGravedad());
        assertEquals(3, parser.getRowCount());
        assertEquals(null, parser.getRow(1).getNivelesGravedad().get(0));

        fileItem = getMetricaManager().descargarMetrica(crearDto(TIPO_PERSONA_FISICA, COD_SEGMENTO_CONSEJEROS));
        assertEquals("metricasRangoSinCobertura.csv", fileItem.getFile().getName());
        parser = new MetricaFileReader(fileItem.getFile());
        fileItem = null;
        assertEquals(3, parser.getCantidadNivelesGravedad());
        assertEquals(2, parser.getRowCount());
    }

    /**
     * Test para verificar que se activa una metrica y borra la vieja.
     */
    @Test
    public void activarMetrica() {
        borrarMetricasCargadas();
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS);
        verificarMetricaCargada("metricasTest.csv");
        cargarYActivarMetrica("metricasTestValido.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS);
        verificarMetricaCargada("metricasTestValido.csv");
    }
}
