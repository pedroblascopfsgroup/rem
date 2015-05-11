package es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.ObservacionAceptacion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.MEJObservacionAceptacionDao;

@Repository("MEJObservacionAceptacionDao")
public class MEJObservacionAceptacionDaoImpl extends AbstractEntityDao<ObservacionAceptacion, Long> implements MEJObservacionAceptacionDao {

}
