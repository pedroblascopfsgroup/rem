package es.pfsgroup.plugin.recovery.config.perfiles.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.config.perfiles.dto.ADMDtoBuscaPerfil;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;

public interface ADMPerfilDao extends AbstractDao<EXTPerfil, Long> {

	/**
	 * Busca usuarios seg�n los criterios definidos en el DTO
	 * 
	 * @param dtoPerfil
	 * @return Devuelve una lista de objetos Perfil paginada.
	 */
	public Page findPerfiles(ADMDtoBuscaPerfil dto);

	/**
	 * Crea un nuevo objeto Perfil, no persistido.
	 * 
	 * @return
	 */
	public EXTPerfil createNew();

	/**
	 * Devuelve el �ltimo c�digo de Perfil almacenado en base de datos. Los
	 * c�digos de perfil s�lo pueden ser valores num�ricos.
	 * 
	 * @return
	 */
	public Long getLastCodigo();
	
	/**
	 * Devuelve todos los perfiles NO borrados logicamente 
	 * (borrado = 0)
	 * @return
	 */
	public List<EXTPerfil> getListUndeleted();

}
