package es.pfsgroup.plugin.recovery.busquedaTareas.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

public interface BTAGestorDespachoDao extends AbstractDao<GestorDespacho, Long>{
	
	/**
     * Busca un despacho a partir de un ID de usuario
     * @param id del usuario
     * @return lel gestor despacho encontrado
     */
	public GestorDespacho getGestorDespachoPorIdUsuario(Long idUsuario);
	
	/**
     * Devuelve los usuarios del despacho externo recivido
     * @param id despacho
     * @return lista de usuarios del despacho y no supervisores
     */
	public List<GestorDespacho> getGestoresDespacho(Long idDespacho);
	
	/**
     * Devuelve los usuarios del despacho externo recivido
     * @param id gestorDespacho
     * @return lista de usuarios del despacho y no supervisores
     */
	public List<GestorDespacho> getGestoresDespachoByUsd(String usdId) ;
}
