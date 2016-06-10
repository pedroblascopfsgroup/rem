package es.pfsgroup.plugin.recovery.config.despachoExterno.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dto.ADMDtoBusquedaDespachoExterno;

public interface ADMDespachoExternoDao extends AbstractDao<DespachoExterno, Long> {
	
	/**
	 * Nos crea una nueva instancia de DespachoExterno
	 * @return
	 */
	public DespachoExterno createNewDespachoExterno();

	/**
	 * Busca todos los supervisores de un determinado despacho. Ignora el hecho de que los usuarios sean externos.
	 * @param idDespacho
	 * @return
	 */
	public List<GestorDespacho> buscarSupervisoresDespacho(Long idDespacho);

	/**
	 * Devuelve una lista de relación Gestor - Despacho en la que despachoExterno
	 * coincide con el id que le pasamos como parámetro y tiene el campo supervisor = false.
	 * @param idDespacho
	 * @return En el caso que busquemos un despacho que no existe devolveremos una lista vacía.
	 */
	public List<GestorDespacho> buscarGestoresDespacho(Long idDespacho);

	/**
	 * Busca despachos externos según los criterios definidos en el DTO de búsqueda
	 * @param dto
	 * @return
	 */
	public Page findDespachosExternos(ADMDtoBusquedaDespachoExterno dto);

	/**
	 * Devuelve el despacho al que pertenece un gestor externo. 
	 * 
	 * <strong>Un gestor externo sólo puede pertenecer a un despacho</strong>
	 * @param idGestor ID del Usuario, debe ser gestor externo y no debe supervisar el despacho.
	 * @return Devuelve NULL si el Usuario no es gestor externo. 
	 */
	public DespachoExterno buscarPorGestor(Long idGestor);

	/**
	 * Devuelve los despachos externos de un determinado tipo
	 * @param idTipo Tipo de despacho
	 * @return Devuelve una lista vacía si no existen despachos del tipo especificado, o si el tipo no existe.
	 */
	public List<DespachoExterno> getByTipo(Long idTipo);
	
	/**
	 * Recupera despachos por el nombre (combo dinamico)
	 * @param filtro
	 * @return
	 */
	public List<DespachoExterno> getListByNombre(String filtro);

}
