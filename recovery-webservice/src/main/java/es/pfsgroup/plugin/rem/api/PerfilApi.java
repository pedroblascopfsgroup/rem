package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.perfilAdministracion.dto.DtoPerfilAdministracionFilter;

public interface PerfilApi {

	/**
	 * Devuelve una lista de perfiles aplicando el filtro que recibe.
	 * 
	 * @param dtoPerfilFiltro: dto con los filtros de busqueda a aplicar.
	 * @return Devuelve un objeto Page de Perfil.
	 */
	public List<DtoPerfilAdministracionFilter> getPerfiles(DtoPerfilAdministracionFilter dtoPerfilFiltro);
	
	/**
	 * Este método devuelve un perfil por el ID de perfil.
	 * 
	 * @param dtoPerfilFiltro: dto con los filtros de busqueda a aplicar.
	 * @return Devuelve un dto con los datos de Perfil.
	 */
	public DtoPerfilAdministracionFilter getPerfilById(Long id);
	
	/**
	 * Este método devuelve la lista de funciones de un perfil por el ID.
	 * 
	 * @param dtoPerfilFiltro: dto con los filtros de busqueda a aplicar.
	 * @return Devuelve un dto con los datos de Perfil.
	 */
	public List<DtoPerfilAdministracionFilter> getFuncionesByPerfilId(Long id, DtoPerfilAdministracionFilter dto);
	
}