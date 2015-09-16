package es.pfsgroup.plugin.recovery.itinerarios.estado.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.itinerario.model.Estado;

public interface ITIEstadoDao extends AbstractDao<Estado, Long>{

	public List<Estado> getEstadosItienario(Long id); 
		

}
