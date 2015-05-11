package es.pfsgroup.concursal.convenio.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.concursal.convenio.dao.DDEstadoConvenioDao;
import es.pfsgroup.concursal.convenio.model.DDEstadoConvenio;

@Repository("DDEstadoConvenioDao")
public class DDEstadoConvenioDaoImpl extends AbstractEntityDao<DDEstadoConvenio, Long> implements DDEstadoConvenioDao{

}
