package es.capgemini.pfs.metrica.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.model.Metrica;

/**
 * Dao para la métricas.
 * @author aesteban
 *
 */
public interface MetricaDao extends AbstractDao<Metrica, Long> {

    /**
     * Borra FISICAMANENTE la métrica indicada.
     * @param metrica a borrar
     */
    void borrarMetricaFisicamente(Metrica metrica);

    /**
     * Recupera la métrica asociados a un tipo de persona.
     * @return Lista de Metricas
     */
    List<Metrica> getMetricasPorDefecto();

    /**
     * Busca las métricas asociadas a un segmento.
     * @return Lista de Metricas
     */
    List<Metrica> buscarMetricasPorSegmentos();

    /**
     * Busca la métrica que corresponde al tipo de persona y/o segmento definidos en el dto.
     * @param dto parámetros
     * @param metricaActiva boolean
     * @return Metrica
     */
    Metrica getMetrica(DtoMetrica dto, Boolean metricaActiva);



}
