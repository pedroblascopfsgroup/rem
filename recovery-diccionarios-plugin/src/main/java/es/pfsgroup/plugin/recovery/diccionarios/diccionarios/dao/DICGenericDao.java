package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditable;

public interface DICGenericDao extends AbstractDao<DICDiccionarioEditable, Long>{

	Long getLastId(Class entityClass);
}
