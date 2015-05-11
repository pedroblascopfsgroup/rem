package es.capgemini.pfs.test.metrica;

import static org.junit.Assert.fail;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;


/**
 * Prueba las funciones del manager de metricas.
 * @author aesteban
 *
 */

public class BorrarMetricasTest extends MetricaCommonTestAbstract {

    /**
     * Test para verificar que se borra una metrica valida para un segmento.
     */
    @Test
    public void borrarMetricaSegmentoValida() {
        borrarMetricasCargadas();
        //Carga metrica defualt para el tipo de persona fisica
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, null);
        verificarMetricaCargada("metricasTest.csv");
        // Carga una metrica especifica para el segmento general
        cargarYActivarMetrica("metricasTestValido.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS);
        flushHibernateSession();
        // Ahora lo intento borrar
        getMetricaManager().borrarMetricaActiva(crearDto(TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS));
        verificarMetricaCargada("metricasTest.csv");
    }

    /**
     * Test para verificar que se borra una metrica valida para un tipo de persona.
     */
    @Test
    public void borrarMetricaTipoPersonaValida() {
        borrarMetricasCargadas();
        //Carga metrica defualt para el tipo de persona fisica
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, null);
        // Cargo para cada segmento
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EMPLEADOS);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_CONSEJEROS);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_GENERAL);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EXTRANJEROS);
        getMetricaManager().borrarMetricaActiva(crearDto(TIPO_PERSONA_FISICA, null));

    }

    /**
     * Test para verificar que no se borra una metrica valida.
     */
    @Test
    public void borrarMetricaInvalida() {
        borrarMetricasCargadas();
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS);
        verificarMetricaCargada("metricasTest.csv");
        try {
            getMetricaManager().borrarMetricaActiva(crearDto(TIPO_PERSONA_FISICA, COD_SEGMENTO_EMPLEADOS));
            fail("Deberia haber lanzado una excepcion");
        } catch (BusinessOperationException e) {
            verificarMetricaCargada("metricasTest.csv");
        }
    }

    /**
     * Test para verificar que no se borra una metrica valida.
     * Ver el documento de CU.
     */
    @Test
    public void pruebaGeneral() {
        borrarMetricasCargadas();
        //Cargo metricas validas para todos los segmentos para poder cargar una con blanco en el default
        cargarYActivarMetrica("metricasTest.csv", null, COD_SEGMENTO_GENERAL);
        cargarYActivarMetrica("metricasTest.csv", null, COD_SEGMENTO_EXTRANJEROS);
        cargarYActivarMetrica("metricasTest.csv", null, COD_SEGMENTO_EMPLEADOS);
        cargarYActivarMetrica("metricasTest.csv", null, COD_SEGMENTO_CONSEJEROS);
        cargarYActivarMetrica("metricasBlancosTest.csv", TIPO_PERSONA_FISICA, null);
        //Sobreescribo la metrica con una con blancos
        cargarYActivarMetrica("metricasNGR2Blanco.csv", null, COD_SEGMENTO_CONSEJEROS);

        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_JUDICIAL, null);

        try {
            getMetricaManager().borrarMetricaActiva(crearDto(TIPO_PERSONA_FISICA, null));
            fail("Deberia haber lanzado una excepcion");
            getMetricaManager().borrarMetricaActiva(crearDto(null, COD_SEGMENTO_CONSEJEROS));
            fail("Deberia haber lanzado una excepcion");
            getMetricaManager().borrarMetricaActiva(crearDto(null, COD_SEGMENTO_EMPLEADOS));
            fail("Deberia haber lanzado una excepcion");
            getMetricaManager().borrarMetricaActiva(crearDto(TIPO_PERSONA_JUDICIAL, null));
            fail("Deberia haber lanzado una excepcion");
        } catch (BusinessOperationException e) {
        }
    }

}
