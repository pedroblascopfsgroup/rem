package es.capgemini.pfs.test.metrica;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.metrica.MetricaValidator;
import es.capgemini.pfs.metrica.dto.DtoMetrica;

/**
 * Prueba las funciones del validador de metricas.
 * @author aesteban
 *
 */
public class MetricaValidatorTest extends MetricaCommonTestAbstract {
    @Autowired
    private MetricaValidator metricaValidator;

    /**
     * Test para verificar que se una metrica valida.
     */
    @Test
    public void metricaValida() {
        assertTrue("La metrica deberia ser valida", metricaValidator.sePuedeCargar(crearDtoGenerico("metricasTest.csv")));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaInvalidaCantidadAlertas() {
        assertFalse("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(crearDtoGenerico("metricasCantidadAlertasTest.csv")));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaInvalidaCodigoAlertas() {
        assertFalse("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(crearDtoGenerico("metricasCodigoAlertasTest.csv")));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaInvalidaCantidadNivelesGravedad() {
        assertFalse("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(crearDtoGenerico("metricasCantidadNivelesGravedadTest.csv")));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaInvalidaRangoNivelPreocupacion() {
        assertFalse("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(crearDtoGenerico("metricasRangoNivelPreocupacionTest.csv")));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaInvalidaRangoNivelGravedad() {
        assertFalse("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(crearDtoGenerico("metricasRangoNivelGravedadTest.csv")));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaInvalidaRangoSinCobertura() {
        assertFalse("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(crearDtoGenerico("metricasRangoSinCobertura.csv")));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaInvalidaPorBlancos() {
        assertFalse("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(crearDtoGenerico("metricasBlancosTest.csv")));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaPorSegmentoConBlancosValida() {
        //Metrica por defecto
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, null);
        assertTrue("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(crearDtoGenerico("metricasBlancosTest.csv")));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaPorDefaultConBlancosInvalida() {
        //Metrica para un segmento
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS);
        //Intento cargar una métrica por defecto
        DtoMetrica dto = crearDtoConArchivo("metricasBlancosTest.csv", TIPO_PERSONA_FISICA, null);
        assertFalse("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(dto));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaPorDefaultConBlancosInvalida2() {
        // Cargo para cada segmento
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EMPLEADOS);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_CONSEJEROS);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EXTRANJEROS);
        DtoMetrica dto = crearDtoConArchivo("metricasBlancosTest.csv", TIPO_PERSONA_JUDICIAL, null);
        assertFalse("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(dto));
    }

    /**
     * Test para verificar que se una metrica invalida.
     */
    @Test
    public void metricaPorDefaultConBlancosValida() {
        // Cargo para cada segmento
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EMPLEADOS);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_CONSEJEROS);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_GENERAL);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EXTRANJEROS);
        DtoMetrica dto = crearDtoConArchivo("metricasBlancosTest.csv", TIPO_PERSONA_FISICA, null);
        assertTrue("La metrica deberia ser invalida", metricaValidator.sePuedeCargar(dto));
    }

    /**
     * Creación de parámetros genéricos.
     * @return
     */
    private DtoMetrica crearDtoGenerico(String fileName) {
        return crearDtoConArchivo(fileName, null, COD_SEGMENTO_EMPLEADOS);
    }

    /**
     * Borramos las métricas existentes.
     */
    @Before
    public void borrarMetricas() {
        borrarMetricasCargadas();
    }

}
