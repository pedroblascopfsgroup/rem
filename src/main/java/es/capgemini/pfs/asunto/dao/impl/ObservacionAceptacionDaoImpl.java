package es.capgemini.pfs.asunto.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.ObservacionAceptacionDao;
import es.capgemini.pfs.asunto.model.ObservacionAceptacion;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementaci�n  del Dao de Observación de Asuntos.
 * @author pamuller
 *
 */
@Repository("ObservacionAceptacionDao")
public class ObservacionAceptacionDaoImpl extends AbstractEntityDao<ObservacionAceptacion, Long> implements ObservacionAceptacionDao {

}
