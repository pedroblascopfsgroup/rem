package es.pfsgroup.concursal.convenio.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.concursal.convenio.dao.DDInicioConvenioDao;
import es.pfsgroup.concursal.convenio.model.DDInicioConvenio;


@Repository("DDInicioConvenioDao")
public class DDInicioConvenioDaoImpl extends AbstractEntityDao<DDInicioConvenio, Long> implements DDInicioConvenioDao{

}
