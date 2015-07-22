package es.capgemini.pfs.despachoExterno.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

/**
 * Definición del DAO de GestorDespacho.
 * @author pamuller
 *
 */
public interface GestorDespachoDao extends AbstractDao<GestorDespacho, Long> {

	/**
	 * Obtiene el GestorDespacho filtrando por el usuario y despacho
	 * 
	 * @param usuarioId Identificador del usuario
	 * @param despachoId Identificador del despacho
	 * @return 
	 */
	GestorDespacho getGestorDespachoPorUsuarioyDespacho(Long usuarioId, Long despachoId);
}
