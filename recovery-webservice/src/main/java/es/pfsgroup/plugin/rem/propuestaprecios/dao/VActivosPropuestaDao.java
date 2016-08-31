package es.pfsgroup.plugin.rem.propuestaprecios.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPropuesta;

public interface VActivosPropuestaDao extends AbstractDao<VBusquedaActivosPropuesta, Long> {

	List<VBusquedaActivosPropuesta> getListActivosByPropuestaPrecio(Long idPropuesta); 
	    
}
