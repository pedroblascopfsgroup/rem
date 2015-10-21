package es.pfsgroup.concursal.convenio.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.concursal.convenio.dao.DDTipoConvenioDao;
import es.pfsgroup.concursal.convenio.model.DDTipoConvenio;

@Repository("DDTipoConvenioDao")
public class DDTipoConvenioDaoImpl extends AbstractEntityDao<DDTipoConvenio, Long> implements DDTipoConvenioDao{

}
