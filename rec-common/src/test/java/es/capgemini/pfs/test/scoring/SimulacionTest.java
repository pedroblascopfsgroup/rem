package es.capgemini.pfs.test.scoring;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.util.StopWatch;

import es.capgemini.pfs.metrica.MetricaManager;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.scoring.ScoringManager;
import es.capgemini.pfs.scoring.dto.DtoSimulacion;
import es.capgemini.pfs.test.metrica.MetricaCommonTestAbstract;

/**
 * Prueba las funciones del manager de metricas.
 * @author aesteban
 *
 */

public class SimulacionTest extends MetricaCommonTestAbstract {
    @Autowired
    private MetricaManager metricaManager;
    @Autowired
    private ScoringManager scoringManager;

    @javax.annotation.Resource
    private Resource borrarScoring;
    @javax.annotation.Resource
    private Resource borrarAlertas;
    @javax.annotation.Resource
    private Resource cargarAlertas;
    @javax.annotation.Resource
    private Resource cargarAlertasStress;

    /**
     * Test.
     */
    @Test
    public void simularParaTipoPersonaTest() {
        cargaBBDD();
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, null);
        metricaManager.cargarMetrica(crearWebFileItem("metricasTestValido.csv", TIPO_PERSONA_FISICA, null));
        DtoMetrica dto = crearDto(TIPO_PERSONA_FISICA, null);
        int cantIntVrc = 6;
        int cantIntRating = 5;
        dto.setCantidadIntervaloRating(cantIntRating);
        dto.setCantidadIntervaloVRC(cantIntVrc);
        Map<String, List<DtoSimulacion>> map = scoringManager.simular(dto);
        List<DtoSimulacion> simActiva = map.get(ScoringManager.MET_ACTIVA);
        List<DtoSimulacion> simInactiva = map.get(ScoringManager.MET_INACTIVA);
        assertEquals(cantIntVrc, simActiva.size());
        assertEquals(cantIntVrc, simInactiva.size());
        assertEquals(cantIntRating, simActiva.get(0).getIntervalos().size());
        assertEquals(cantIntRating, simInactiva.get(0).getIntervalos().size());
        assertEquals(8, contarPersonas(simActiva));
        assertEquals(8, contarPersonas(simInactiva));

        assertEquals(2, contarPersonas(simActiva.get(0).getIntervalos()));
        assertEquals(0, contarPersonas(simActiva.get(1).getIntervalos()));
        assertEquals(0, contarPersonas(simActiva.get(2).getIntervalos()));
        assertEquals(2, contarPersonas(simActiva.get(3).getIntervalos()));
        assertEquals(2, contarPersonas(simActiva.get(4).getIntervalos()));
        assertEquals(2, contarPersonas(simActiva.get(5).getIntervalos()));

        assertEquals(2, contarPersonas(simInactiva.get(0).getIntervalos()));
        assertEquals(0, contarPersonas(simInactiva.get(1).getIntervalos()));
        assertEquals(0, contarPersonas(simInactiva.get(2).getIntervalos()));
        assertEquals(2, contarPersonas(simInactiva.get(3).getIntervalos()));
        assertEquals(2, contarPersonas(simInactiva.get(4).getIntervalos()));
        assertEquals(2, contarPersonas(simInactiva.get(5).getIntervalos()));
    }

    /**
     * Test.
     */
    @Test
    public void simularParaTipoSegmentoTest() {
        cargaBBDD();
        cargarYActivarMetrica("metricasTest.csv", TIPO_PERSONA_FISICA, null);
        cargarYActivarMetrica("metricasTestValido.csv", TIPO_PERSONA_JUDICIAL, null);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EMPLEADOS);
        metricaManager.cargarMetrica(crearWebFileItem("metricasTest.csv", null, COD_SEGMENTO_EMPLEADOS));
        DtoMetrica dto = crearDto(null, COD_SEGMENTO_EMPLEADOS);
        int cantIntVrc = 6;
        int cantIntRating = 5;
        dto.setCantidadIntervaloRating(cantIntRating);
        dto.setCantidadIntervaloVRC(cantIntVrc);
        Map<String, List<DtoSimulacion>> map = scoringManager.simular(dto);
        List<DtoSimulacion> simActiva = map.get(ScoringManager.MET_ACTIVA);
        List<DtoSimulacion> simInactiva = map.get(ScoringManager.MET_INACTIVA);
        assertEquals(cantIntVrc, simActiva.size());
        assertEquals(cantIntVrc, simInactiva.size());
        assertEquals(cantIntRating, simActiva.get(0).getIntervalos().size());
        assertEquals(cantIntRating, simInactiva.get(0).getIntervalos().size());
        assertEquals(8, contarPersonas(simActiva));
        assertEquals(8, contarPersonas(simInactiva));
    }

    /**
     * Test.
     */
    @Test
    public void simularParaTipoPersonaConMetricaIncompletaTest() {
        cargaBBDD();
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EMPLEADOS);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_CONSEJEROS);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EXTRANJEROS);
        cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_GENERAL);
        cargarYActivarMetrica("metricasBlancosTest.csv", TIPO_PERSONA_FISICA, null);
        cargarYActivarMetrica("metricasBlancosTest.csv", TIPO_PERSONA_JUDICIAL, null);
        metricaManager.cargarMetrica(crearWebFileItem("metricasTestValido.csv", TIPO_PERSONA_FISICA, null));
        DtoMetrica dto = crearDto(TIPO_PERSONA_FISICA, null);
        int cantIntVrc = 6;
        int cantIntRating = 5;
        dto.setCantidadIntervaloRating(cantIntRating);
        dto.setCantidadIntervaloVRC(cantIntVrc);
        Map<String, List<DtoSimulacion>> map = scoringManager.simular(dto);
        List<DtoSimulacion> simActiva = map.get(ScoringManager.MET_ACTIVA);
        List<DtoSimulacion> simInactiva = map.get(ScoringManager.MET_INACTIVA);
        assertEquals(cantIntVrc, simActiva.size());
        assertEquals(cantIntVrc, simInactiva.size());
        assertEquals(cantIntRating, simActiva.get(0).getIntervalos().size());
        assertEquals(cantIntRating, simInactiva.get(0).getIntervalos().size());
        assertEquals(8, contarPersonas(simActiva));
        assertEquals(8, contarPersonas(simInactiva));
    }

    /**
     * Test.
     */
    @Test
    public void simularParaSegmentoConMetricaIncompletaTest() {
        cargaBBDD();
        cargarYActivarMetrica("metricasTestValido.csv", TIPO_PERSONA_FISICA, null);
        cargarYActivarMetrica("metricasTestValido.csv", TIPO_PERSONA_JUDICIAL, null);
        cargarYActivarMetrica("metricasBlancosTest.csv", null, COD_SEGMENTO_EMPLEADOS);
        metricaManager.cargarMetrica(crearWebFileItem("metricasTestValido.csv", null, COD_SEGMENTO_EMPLEADOS));
        DtoMetrica dto = crearDto(null, COD_SEGMENTO_EMPLEADOS);
        int cantIntVrc = 6;
        int cantIntRating = 5;
        dto.setCantidadIntervaloRating(cantIntRating);
        dto.setCantidadIntervaloVRC(cantIntVrc);
        Map<String, List<DtoSimulacion>> map = scoringManager.simular(dto);
        List<DtoSimulacion> simActiva = map.get(ScoringManager.MET_ACTIVA);
        List<DtoSimulacion> simInactiva = map.get(ScoringManager.MET_INACTIVA);
        assertEquals(cantIntVrc, simActiva.size());
        assertEquals(cantIntVrc, simInactiva.size());
        assertEquals(cantIntRating, simActiva.get(0).getIntervalos().size());
        assertEquals(cantIntRating, simInactiva.get(0).getIntervalos().size());
        assertEquals(8, contarPersonas(simActiva));
        assertEquals(8, contarPersonas(simInactiva));
    }

    /**
     * Test de stress con metricas para segmentos incompletas.
     */
    @Test
    public void simularStressTest() {
        executeScript(borrarScoring);
        executeScript(borrarAlertas);
        executeScript(cargarAlertasStress);
        borrarMetricasCargadas();
        cargarYActivarMetrica("metricasTestValido.csv", TIPO_PERSONA_FISICA, null);
        cargarYActivarMetrica("metricasTestValido.csv", TIPO_PERSONA_JUDICIAL, null);
        cargarYActivarMetrica("metricasBlancosTest.csv", null, COD_SEGMENTO_EMPLEADOS);
        //cargarYActivarMetrica("metricasTestValido.csv", null, COD_SEGMENTO_EMPLEADOS);
        metricaManager.cargarMetrica(crearWebFileItem("metricasTestValido.csv", null, COD_SEGMENTO_EMPLEADOS));
        DtoMetrica dto = crearDto(null, COD_SEGMENTO_EMPLEADOS);
        int cantIntVrc = 6;
        int cantIntRating = 5;
        dto.setCantidadIntervaloRating(cantIntRating);
        dto.setCantidadIntervaloVRC(cantIntVrc);
        System.out.println("Inicio de la simulación con muchos datos");
        StopWatch sw = new StopWatch();
        sw.start();
        Map<String, List<DtoSimulacion>> map = scoringManager.simular(dto);
        sw.stop();
        System.out.println("Fin de simulación. Tiempo total: " + sw.getTotalTimeMillis() + " ms.");

        List<DtoSimulacion> simActiva = map.get(ScoringManager.MET_ACTIVA);
        List<DtoSimulacion> simInactiva = map.get(ScoringManager.MET_INACTIVA);
        assertEquals(cantIntVrc, simActiva.size());
        assertEquals(cantIntVrc, simInactiva.size());
        assertEquals(cantIntRating, simActiva.get(0).getIntervalos().size());
        assertEquals(cantIntRating, simInactiva.get(0).getIntervalos().size());
        assertEquals(500, contarPersonas(simActiva));
        assertEquals(500, contarPersonas(simInactiva));
    }

    private int contarPersonas(List<DtoSimulacion> simActiva) {
        int contador = 0;
        for (DtoSimulacion dtoSimulacion : simActiva) {
            contador += contarPersonas(dtoSimulacion.getIntervalos());
        }
        return contador;
    }

    private int contarPersonas(Map<String, Map<String, Double>> map) {
        int contador = 0;
        for (String nombreIntervalo : map.keySet()) {
            contador += map.get(nombreIntervalo).get(DtoSimulacion.KEY_CANT_CLIENTES);
        }
        return contador;
    }

    /**
     * Carga personas, contratos, sus relaciones y alertas.
     */
    private void cargaBBDD() {
        executeScript(borrarScoring);
        executeScript(borrarAlertas);
        executeScript(cargarAlertas);
        borrarMetricasCargadas();
    }
}
