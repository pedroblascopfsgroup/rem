package es.capgemini.pfs.direccion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.direccion.dao.DireccionPersonaManualDao;
import es.capgemini.pfs.direccion.model.DireccionPersonaManual;
import es.capgemini.pfs.direccion.model.DireccionPersonaManualId;

@Repository("DireccionPersonaManualDao")
public class DireccionPersonaManualDaoImpl  extends AbstractEntityDao<DireccionPersonaManual, DireccionPersonaManualId> implements DireccionPersonaManualDao {

}
