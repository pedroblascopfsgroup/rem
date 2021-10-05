package es.pfsgroup.plugin.rem.api;

import java.util.Arrays;
import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.perfilAdministracion.dto.DtoPerfilAdministracionFilter;

public interface PerfilApi {

	public final static String COD_PERFIL_CARTERA_BBVA = "CARTERA_BBVA";
	public final static String COD_PERFIL_USUARIO_BC = "USUARIOS_BC";
	
	public static final String PERFIL_TASADORA = "TASADORA";
	public static final List<String> MATRICULAS_TASADORA = Arrays.asList(
			"AI-01-NOTS-01", //Nota simple actualizada
			"AI-02-CNCV-04", //Alquiler: contrato
			"AI-02-CNCV-05", //Alquiler: contrato con opción a compra
			"AI-02-DOCJ-23", //Usurpación: denuncia
			"AI-01-CERA-16", //Impuesto sobre bienes inmuebles (IBI): recibo
			"AI-04-TASA-11", //Tasación adjudicación
			"OP-13-TASA-11" //Tasación: informe activo
			);
	
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

	boolean usuarioHasPerfil(String codPerfil, String userName);

	List<DtoAdjunto> devolverAdjuntosPorPerfil(List<DtoAdjunto> adjuntos);
	
}