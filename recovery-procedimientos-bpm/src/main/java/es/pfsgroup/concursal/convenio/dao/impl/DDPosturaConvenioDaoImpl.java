package es.pfsgroup.concursal.convenio.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.concursal.convenio.dao.DDPosturaConvenioDao;
import es.pfsgroup.concursal.convenio.model.DDPosturaConvenio;

@Repository("DDPosturaConvenioDao")
public class DDPosturaConvenioDaoImpl extends AbstractEntityDao<DDPosturaConvenio, Long> implements DDPosturaConvenioDao{

}
