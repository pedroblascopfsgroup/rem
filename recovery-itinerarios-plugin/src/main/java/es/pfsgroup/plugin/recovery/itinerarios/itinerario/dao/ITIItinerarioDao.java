package es.pfsgroup.plugin.recovery.itinerarios.itinerario.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.plugin.recovery.itinerarios.itinerario.dto.ITIDtoBusquedaItinerarios;

public interface ITIItinerarioDao extends AbstractDao<Itinerario, Long> {

	/**
	 * 
	 * @param dto
	 * @return devuelve una lista Paginada con el resultado de la búsqueda
	 */
	public Page buscaItinerarios(ITIDtoBusquedaItinerarios dto);
	
	/**
	 * nos crea un nuevo objeto de la clase Itinerario
	 */
	public Itinerario createNewItinerario();
	

}
