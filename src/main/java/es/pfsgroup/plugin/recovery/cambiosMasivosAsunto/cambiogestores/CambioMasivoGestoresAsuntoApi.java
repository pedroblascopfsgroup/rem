package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores;

import java.util.Collection;
import java.util.List;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.CambiosMasivosAsuntoPluginConfig;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dto.PeticionCambioMasivoGestoresDtoImpl;
import es.pfsgroup.plugins.domain.PluginConfig;

/**
 * Operaciones de negocio para el cambio masivo de gestores del Asunto.
 * 
 * @author bruno
 * 
 */
public interface CambioMasivoGestoresAsuntoApi {

	final String CAMBIO_MASIVO_GESTORES_ANOTAR_CAMBIOS = "es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi.anotarCambiosPendientes";

	final String CAMBIO_MASIVO_GESTORES_COMPROBAR_CAMBIOS = "es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi.comprobarrCambiosPendientes";

	final String CAMBIO_MASIVO_GESTORES_GET_TIPOS_GESTOR = "es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi.getTiposGestor";
	
	final String CAMBIO_MASIVO_GESTORES_GET_GESTORES = "es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi.buscaGestoresByDespachoTipoGestor";
	
	final String CAMBIO_MASIVO_GESTORES_GET_TODOS_DESPACHOS = "es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi.getTodosLosDespachos";
	
//	final String CAMBIO_MASIVO_GESTORES_GET_USUARIOS = "es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi.getUsuarios";

	/**
	 * Anota en BBDD una petición de cambio masivo de gestores de un asunto para
	 * su posterior proceso en el batch
	 * 
	 * @param dto
	 */
	@BusinessOperationDefinition(CAMBIO_MASIVO_GESTORES_ANOTAR_CAMBIOS)
	void anotarCambiosPendientes(PeticionCambioMasivoGestoresDto dto);

	/**
	 * Comprueba cuantas modificaciones se realizarian para una determinada
	 * peticion de cambio
	 * 
	 * @param dto
	 * @return Número de modificaciones
	 */
	@BusinessOperationDefinition(CAMBIO_MASIVO_GESTORES_COMPROBAR_CAMBIOS)
	int comprobarCambiosPendientes(PeticionCambioMasivoGestoresDtoImpl dto);

	/**
	 * Devuelve la lista de tipos de gestores posibles para cambiar. Tiene en
	 * cuenta los criterios establecidos en la configuración del plugin en
	 * {@link CambiosMasivosAsuntoPluginConfig}
	 * 
	 * @return
	 */
	@BusinessOperationDefinition(CAMBIO_MASIVO_GESTORES_GET_TIPOS_GESTOR)
	List<EXTDDTipoGestor> getTiposGestor();

	/**
	 * Busca gestores que estén asociados a algún Asunto con un determinado tipo de Gestor y a un Despacho
	 * @param despacho
	 * @param tipoGestor
	 * @return
	 */
	@BusinessOperationDefinition(CAMBIO_MASIVO_GESTORES_GET_GESTORES)
	List<GestorDespacho> buscaGestoresByDespachoTipoGestor(Long despacho, Long tipoGestor);

	/**
	 * Devuelve una lista de todos los despachos que existen
	 * @return
	 */
	@BusinessOperationDefinition(CAMBIO_MASIVO_GESTORES_GET_TODOS_DESPACHOS)
	List<DespachoExterno> getTodosLosDespachos();

//	@BusinessOperationDefinition(CAMBIO_MASIVO_GESTORES_GET_USUARIOS)
//	Collection<? extends Usuario>  getUsuarios(String query);

}
