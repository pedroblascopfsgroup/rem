package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICDiccionarioEditableDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditable;

@Repository("ADMDiccionarioEditableDao")
public class DICDiccionarioEditableDaoHibernateImpl extends AbstractEntityDao<DICDiccionarioEditable, Long> implements DICDiccionarioEditableDao{

}
