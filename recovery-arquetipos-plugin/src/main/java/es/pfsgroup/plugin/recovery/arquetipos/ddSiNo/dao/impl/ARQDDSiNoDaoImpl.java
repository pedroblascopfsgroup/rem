package es.pfsgroup.plugin.recovery.arquetipos.ddSiNo.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.plugin.recovery.arquetipos.ddSiNo.dao.ARQDDSiNoDao;

@Repository("ARQDDSiNoDao")
public class ARQDDSiNoDaoImpl extends AbstractEntityDao<DDSiNo, Long> implements ARQDDSiNoDao{

}
