package es.capgemini.pfs.despachoExterno.dao;

import java.util.List;

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
	
	/**
	 * Devuelve una lista de gestorDespacho a partur del usuId
	 * @param usuId
	 * @return
	 */
	List<GestorDespacho> getGestorDespachoByUsuId(Long usuId);

	/**
	 * Obtiene los gestordespacho filtrando por usuario y tipo de despacho.
	 * @param usuId
	 * @return
	 */
	List<GestorDespacho> getGestorDespachoByUsuIdAndTipoDespacho(Long usuId, String tipoDespachoExterno);	
}
