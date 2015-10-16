package es.pfsgroup.plugin.recovery.config.despachoExterno.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoAmbitoActuacion;

public interface ADMDespachoAmbitoActuacionDao extends AbstractDao<DespachoAmbitoActuacion, Long> {

	/**
	 * Devuelve los el ámbito greográfico de actuación de un despacho
	 * 
	 * @param idDespachoExterno
	 * @return Listado de ambitos de actuación de un despacho.
	 */
	List<DespachoAmbitoActuacion> getAmbitoGeograficoDespacho(Long idDespachoExterno);

}
