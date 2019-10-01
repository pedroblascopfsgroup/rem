package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoCargas;

public interface ActivoCargasDao extends AbstractDao<ActivoCargas, Long>{
	
	/* Nombre que le damos al Activo buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "car";

	public Boolean esActivoConCargasNoCanceladas(Long idActivo);
	
	public Boolean esActivoConCargasNoCanceladasRegistral(Long idActivo);
	
	public Boolean esActivoConCargasNoCanceladasEconomica(Long idActivo);

	/**
	 * Este metodo lanza el procedimiento que calcula el estado de la carga de un activo
	 *
	 * @param idActivo:
	 *            ID del activo para el cual se desea realizar la operación. 
	 *            Si viene a nulo se lanza para todos
	 * @param username:
	 *            nombre del usuario, si la llamada es desde la web, que realiza
	 *            la operación.
	 * @return Devuelve True si la operacion ha sido satisfactoria, False si no
	 *         ha sido satisfactoria.
	 */
	public Boolean calcularEstadoCargaActivo(Long idActivo, String username, boolean doFlush);
}
