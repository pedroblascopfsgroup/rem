package es.pfsgroup.plugin.recovery.itinerarios.comite.dao;

import java.util.List;

import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.dao.AbstractDao;

public interface ITIComiteDao extends AbstractDao<Comite, Long>{

	public List<Comite> findByItinerario(Long idItinerario);

	

}
