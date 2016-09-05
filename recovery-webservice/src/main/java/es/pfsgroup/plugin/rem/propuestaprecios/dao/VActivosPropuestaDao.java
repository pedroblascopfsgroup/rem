package es.pfsgroup.plugin.rem.propuestaprecios.dao;


import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPropuesta;

public interface VActivosPropuestaDao extends AbstractDao<VBusquedaActivosPropuesta, Long> {

	Page getListActivosByPropuestaPrecio(Long idPropuesta, WebDto webDto); 
	    
}
