package es.pfsgroup.plugin.recovery.config.despachoExterno.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.ext.turnadodespachos.DespachoAmbitoActuacion;

public interface ADMDespachoAmbitoActuacionDao extends AbstractDao<DespachoAmbitoActuacion, Long> {

	/**
	 * Devuelve los el ámbito greográfico de actuación de un despacho
	 * 
	 * @param idDespachoExterno
	 * @return Listado de ambitos de actuación de un despacho.
	 */
	List<DespachoAmbitoActuacion> getAmbitoGeograficoDespacho(Long idDespachoExterno);
	
	/**
	 * Recupera la lista de ámbitos de actuación activos para un despacho que no han sido incluidos en la doble lista
	 * 
	 * @param idDespacho
	 * @param listadoComunidades
	 * @param listadoProvincias
	 * @return
	 */
	List<DespachoAmbitoActuacion> getAmbitosActuacionExcluidos(Long idDespacho,
			String listadoComunidades, String listadoProvincias);

	/**
	 * Recupera el ámbito de actuación para el despacho y Comunidad Autónoma dados
	 * 
	 * @param id
	 * @param codigo
	 * @return
	 */
	DespachoAmbitoActuacion getByDespachoYComunidad(Long idDespacho, String codigoComunidad);

	/**
	 * Recupera el ámbito de actuación para el despacho y provincia dados
	 * 
	 * @param idDespacho
	 * @param codigoProvincia
	 * @return
	 */
	DespachoAmbitoActuacion getByDespachoYProvincia(Long idDespacho, String codigoProvincia);
}
