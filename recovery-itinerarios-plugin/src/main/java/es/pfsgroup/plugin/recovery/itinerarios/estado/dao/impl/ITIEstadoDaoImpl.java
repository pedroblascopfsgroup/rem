package es.pfsgroup.plugin.recovery.itinerarios.estado.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.model.Estado;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.itinerarios.estado.dao.ITIEstadoDao;

@Repository("ITIEstadoDao")
public class ITIEstadoDaoImpl extends AbstractEntityDao<Estado, Long> implements ITIEstadoDao {

	@SuppressWarnings("static-access")
	@Override
	public List<Estado> getEstadosItienario(Long id) {
		HQLBuilder hb = new HQLBuilder("from Estado est");
		hb.addFiltroIgualQue(hb, "est.itinerario.id", id);
		hb.orderBy("est.estadoItinerario.orden", "asc");
		
		return HibernateQueryUtils.list(this, hb);
	}
	
	public Estado createNewObject (){
		return new Estado();
	}

}
