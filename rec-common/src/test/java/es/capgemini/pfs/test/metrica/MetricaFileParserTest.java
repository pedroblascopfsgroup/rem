package es.capgemini.pfs.test.metrica;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

import es.capgemini.pfs.metrica.MetricaFileReader;
import es.capgemini.pfs.metrica.dto.DtoMetricaPorAlerta;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * Prueba las funciones del parser de metricas.
 * @author aesteban
 *
 */
public class MetricaFileParserTest extends CommonTestAbstract {

    private MetricaFileReader metricaFileParser;

    /**
     * Test para verificar la cantidad de filas.
     * @throws IOException problema de lectura
     */
    @Test
    public void cantidadFilas() throws IOException {
        assertEquals(3, metricaFileParser.getRowCount());
        //Verifico otra vez para validar que el parseador se resetea
        assertEquals(3, metricaFileParser.getRowCount());

    }

    /**
     * Test para verificar la cantidad de columnas.
     * @throws IOException problema de lectura
     */
    @Test
    public void cantidadColumnas() throws IOException {
        assertEquals(6, metricaFileParser.getColumnCount());
    }

    /**
     * Test para verificar que calcula bien la cantidad de niveles de gravedad.
     * @throws IOException problema de lectura
     */
    @Test
    public void cantidadNivelesDeGravedad() throws IOException {
        assertEquals(3, metricaFileParser.getCantidadNivelesGravedad());
    }

    /**
     * Test para verificar si recupera filas específicas.
     * @throws IOException problema de lectura
     */
    @Test
    public void recuperarFilasEspecificas() throws IOException {
        DtoMetricaPorAlerta dto = metricaFileParser.getRow(2);
        assertEquals("ALE02", dto.getCodigoAlerta());
        assertEquals(1, (int) dto.getNivelPreocupacion());
        List<Integer> niveles = dto.getNivelesGravedad();
        assertEquals(3, niveles.size());
        assertEquals(15, (int) niveles.get(0));
        assertEquals(25, (int) niveles.get(1));
        assertEquals(30, (int) niveles.get(2));
    }

    /**
     * Prepara los datos necesarios para los tests.
     */
    @Before
    public void prepararDatos() {
        metricaFileParser = new MetricaFileReader(getCSVFile());

    }

    private File getCSVFile() {
        return getTestFile(this.getClass(), "metricasTest.csv");
    }

}
