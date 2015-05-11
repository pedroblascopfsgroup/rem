package es.capgemini.pfs.metrica.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.metrica.dao.MetricaTipoAlertaGravedadDao;
import es.capgemini.pfs.metrica.model.MetricaTipoAlertaGravedad;

/**
 * Implementación del dao MetricaTipoAlertaGravedad.
 * @author aesteban
 *
 */
@Repository("MetricaTipoAlertaGravedadDao")
public class MetricaTipoAlertaGravedadDaoImpl extends AbstractEntityDao<MetricaTipoAlertaGravedad, Long> implements MetricaTipoAlertaGravedadDao {
}
