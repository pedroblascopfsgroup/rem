package es.capgemini.pfs.metrica.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.metrica.dao.MetricaTipoAlertaDao;
import es.capgemini.pfs.metrica.model.MetricaTipoAlerta;

/**
 * Implementación del dao MetricaTipoAlerta.
 * @author aesteban
 *
 */
@Repository("MetricaTipoAlertaDao")
public class MetricaTipoAlertaDaoImpl extends AbstractEntityDao<MetricaTipoAlerta, Long> implements MetricaTipoAlertaDao {
}
