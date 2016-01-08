package es.pfsgroup.plugin.recovery.itinerarios.comite.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.itinerarios.comite.dao.ITIComiteDao;

@Repository("ITIComiteDao")
public class ITIComiteDaoImpl extends AbstractEntityDao<Comite, Long> 
	implements ITIComiteDao{

	@Override
	public List<Comite> findByItinerario(Long idItinerario) {
		// TODO
		return null;
	}

	
		

}
