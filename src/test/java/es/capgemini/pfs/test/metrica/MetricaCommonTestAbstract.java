package es.capgemini.pfs.test.metrica;

import static org.junit.Assert.assertEquals;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.metrica.MetricaManager;
import es.capgemini.pfs.metrica.dao.MetricaDao;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.model.Metrica;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * Métodos en comun para las tests de métricas.
 * @author aesteban
 *
 */
public abstract class MetricaCommonTestAbstract extends CommonTestAbstract {
    protected static final String TIPO_PERSONA_FISICA = "1";
    protected static final String TIPO_PERSONA_JUDICIAL = "2";
    protected static final String COD_SEGMENTO_EMPLEADOS = "1";
    protected static final String COD_SEGMENTO_CONSEJEROS = "2";
    protected static final String COD_SEGMENTO_GENERAL = "3";
    protected static final String COD_SEGMENTO_EXTRANJEROS = "4";
    @Autowired
    private MetricaManager metricaManager;
    @Autowired
    private MetricaDao metricaDao;

    @javax.annotation.Resource
    private Resource borrarMetricas;

    /**
     * Metodo auxiliar que simula al que viene del flow.
     * @param tipoPersona string
     * @param codigoSegmento string
     * @return DtoMetrica
     */
    protected DtoMetrica crearDto(String tipoPersona, String codigoSegmento) {
        DtoMetrica dto = new DtoMetrica();
        dto.setCodigoTipoPersona(tipoPersona);
        dto.setCodigoSegmento(codigoSegmento);
        return dto;
    }

    /**
     * Metodo auxiliar que simula lo que arma MetricaManager.
     * @param fileName string
     * @param tipoPersona string
     * @param codigoSegmento string
     * @return DtoMetrica
     */
    protected DtoMetrica crearDtoConArchivo(String fileName, String tipoPersona, String codigoSegmento) {
        DtoMetrica dto = crearDto(tipoPersona, codigoSegmento);
        FileItem fi = new FileItem(getTestFile(this.getClass(), fileName));
        dto.setFileItem(fi);
        return dto;
    }

    /**
     * Creación de parámetros genéricos.
     * @param fileName string
     * @param tipoPersona string
     * @param codigoSegmento string
     * @return WebFileItem
     */
    protected WebFileItem crearWebFileItem(String fileName, String tipoPersona, String codigoSegmento) {
        WebFileItem webFileItem = new WebFileItem();
        FileItem fi = new FileItem(getTestFile(this.getClass(), fileName));
        fi.setFileName(fileName);
        webFileItem.setFileItem(fi);
        Map<String, String> params = new HashMap<String, String>();
        params.put(MetricaManager.PARAM_COD_TIPO_PER, tipoPersona);
        params.put(MetricaManager.PARAM_COD_SEGMENTO, codigoSegmento);
        webFileItem.setParameters(params);
        return webFileItem;
    }

    /**
     * Carga y activa la metrica para los parámetros indicado.
     * @param fileName string
     * @param tipoPersona string
     * @param codigoSegmento string
     */
    protected void cargarYActivarMetrica(String fileName, String tipoPersona, String codigoSegmento) {
        metricaManager.cargarMetrica(crearWebFileItem(fileName, tipoPersona, codigoSegmento));
        metricaManager.activarMetrica(crearDto(tipoPersona, codigoSegmento));
    }

    /**
     * Verifica que exista 1 metrica cargada con el nombre de fichero indicado.
     * @param fileName String
     */
    protected void verificarMetricaCargada(String fileName) {
        List<Metrica> metricas = metricaDao.getList();
        assertEquals(1, metricas.size());
        Metrica metrica = metricas.get(0);
        assertEquals(fileName, metrica.getNombreFichero());
    }

    /**
     * Borrar las metricas de la BBDD.
     */
    protected void borrarMetricasCargadas() {
        executeScript(borrarMetricas);
    }

    /**
     * @return the metricaManager
     */
    public MetricaManager getMetricaManager() {
        return metricaManager;
    }

}
