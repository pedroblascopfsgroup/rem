package es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.FichaAceptacion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.MEJFichaAceptacionDao;

@Repository("MEJFichaAceptacionDao")
public class MEJFichaAceptacionDaoImpl extends AbstractEntityDao<FichaAceptacion, Long> implements MEJFichaAceptacionDao {

}
