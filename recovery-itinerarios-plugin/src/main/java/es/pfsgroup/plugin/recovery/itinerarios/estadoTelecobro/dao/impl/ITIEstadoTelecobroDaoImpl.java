package es.pfsgroup.plugin.recovery.itinerarios.estadoTelecobro.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.recovery.itinerarios.estadoTelecobro.dao.ITIEstadoTelecobroDao;

@Repository("ITIEstadoTelecobroDao")
public class ITIEstadoTelecobroDaoImpl extends AbstractEntityDao<EstadoTelecobro, Long> 
	implements ITIEstadoTelecobroDao{

	@Override
	public EstadoTelecobro createNewEstadoTelecobro() {
		EstadoTelecobro est = new EstadoTelecobro();
		//est.setId(getLastId()+1);
		return est;
	}
	
	public Long getLastId() {
		HQLBuilder b = new HQLBuilder("select max(id) from EstadoTelecobro");
		return (Long) getSession().createQuery(b.toString()).uniqueResult();
	}

}
