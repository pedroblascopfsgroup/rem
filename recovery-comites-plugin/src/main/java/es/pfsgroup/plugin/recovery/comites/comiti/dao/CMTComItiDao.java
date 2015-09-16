package es.pfsgroup.plugin.recovery.comites.comiti.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.comites.comiti.model.CMTComIti;

public interface CMTComItiDao extends AbstractDao<CMTComIti, Long>{

	public CMTComIti find(Long idComite,Long idItinerario);

	public List<CMTComIti> getItinerariosComite(Long idComite); 

}
