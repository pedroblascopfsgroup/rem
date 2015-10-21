package es.pfsgroup.concursal.convenio.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.concursal.convenio.dao.DDSiNoDao;

@Repository("DDSiNoDao")
public class DDSiNoDaoImpl extends AbstractEntityDao<DDSiNo, Long> implements DDSiNoDao{

}
