package es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.dto.ITIDtoAltaReglaElevacion;
import es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.model.ITIReglasElevacion;

public interface ITIReglasElevacionDao extends AbstractDao<ITIReglasElevacion, Long>{

	/**
	 * 
	 * @param id del estado
	 * @return devuelve una lista de todas las reglas de elevación asociadas a un estado
	 */
	public List<ITIReglasElevacion> buscaReglasEstado(Long id);

	public  ITIReglasElevacion createNewReglasElevacion();

	public boolean comprobarExisteRegla(ITIDtoAltaReglaElevacion dto); 

}
