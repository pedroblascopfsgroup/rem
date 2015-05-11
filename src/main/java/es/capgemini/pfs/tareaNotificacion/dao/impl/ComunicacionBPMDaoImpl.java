package es.capgemini.pfs.tareaNotificacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.dao.ComunicacionBPMDao;
import es.capgemini.pfs.tareaNotificacion.model.ComunicacionBPM;

/**
 * Implementación del dao de ComunicacionBPM.
 * @author pamuller
 *
 */
@Repository("ComunicacionBPMDao")
public class ComunicacionBPMDaoImpl extends AbstractEntityDao<ComunicacionBPM, Long> implements ComunicacionBPMDao{

}
