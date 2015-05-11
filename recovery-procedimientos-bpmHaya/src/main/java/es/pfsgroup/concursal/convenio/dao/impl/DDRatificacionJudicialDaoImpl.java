package es.pfsgroup.concursal.convenio.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.concursal.convenio.dao.DDRatificacionJudicialDao;
import es.pfsgroup.concursal.convenio.model.DDRatificacionJudicial;

@Repository("DDRatificacionJudicialDao")
public class DDRatificacionJudicialDaoImpl extends AbstractEntityDao<DDRatificacionJudicial, Long> implements DDRatificacionJudicialDao{

}
