package es.pfsgroup.recovery.recobroCommon.esquema.manager.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroSubcarAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroSubcarteraDto;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSimulacionEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraRanking;
import es.pfsgroup.recovery.recobroCommon.esquema.serder.recobroSubCarAgencias.RecobroSubcarteraAgenciasGrid;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonEsquemasConstants;

public interface RecobroEsquemaApi {
	
	/**
	 * Método que a partir de un dto de búsqueda devuelve una página con todos 
	 * los objetos de tipo RecobroEsquema que cumplen los criterios de búsqueda
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BUSCAR_ESQUEMAS_BO)
	Page buscarRecobroEsquema(RecobroEsquemaDto dto);
	
	/**
	 * Método que devuelve la instancia de la clase RecobroEsquema cuyo id coincide con el parámetro 
	 * que se le pasa por entrada
	 * @param idEsquema
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_GET_BO)
	RecobroEsquema getRecobroEsquema(Long idEsquema);
	
	/**
	 * Método que elimina la instancia de RecobroEsquema que tenga el id que se le pasa como parámetro
	 * @param idEsquema
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_DELETEESQUEMA_BO)
	void borrarRecobroEsquema(Long idEsquema);
	
	
	/**
	 * Método que modifica los valores de un Esquema de Recobro a partir de los datos 
	 * que vienen en el dto.
	 * Si el el idEsquema del dto es null o no existe el esquema se creará uno nuevo, 
	 * si no modificará la ya existente en base de datos 
	 * @param dto
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_SAVEESQUEMA_BO)
	Long guardarRecobroEsquema(RecobroEsquemaDto dto);
	
	/**
	 * Método que devuelve el objeto RecobroCarteraEsquema que tiene ese id
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_GET_CARTERA_ESQUEMA_BO)
	RecobroCarteraEsquema getRecobroCarteraEsquema(Long id);

	/**
	 * Método que devuelve todas las subcarteras que tiene asociada una cartera en un esquema
	 * @param idCarteraEsquema
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERA_BY_ESQUEMACARTERA_BO)
	List<? extends RecobroSubCartera> getSubcarterasCarteraEsquema(Long idCarteraEsquema);
	
	/**
	 * Método que guarda los modelos asignados a la subcartera
	 * @param dto
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_SAVE_MODELOS_SUBCARTERA_BO)
	void guardarModelosSubcartera(RecobroSubcarteraDto dto);
	
	/**
	 * Método que devuelve todas las agencias que tiene asociada una subcartera
	 * @param idSubCartera
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERAAGENCIAS_BO)
	List<? extends RecobroSubcarteraAgencia> getSubCarterasAgencias(Long idSubCarteraAgencias);

	/**
	 * Método que devuelve todas las agencias que tiene asociada una subcartera
	 * @param idSubCartera
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERARANKING_BO)
	List<? extends RecobroSubcarteraRanking> getSubCarterasRanking(Long idSubCarteraAgencias);

	/**
	 * método que devuelve una lista de todos los esquemas de recobro dados de alta en la base de datos
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_GETLIST_BO)
	List<RecobroEsquema> getListaEsquemas();
	
	/**
	 * Método que guarda el reparto de agencias de las subcarteras
	 * @param idCarteraEsquema
	 * @param idTipoReparto
	 * @param idSubCartera
	 * @param nomSubCartera
	 * @param particion
	 * @param gridItems
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_ESQUEMAAPI_SAVE_AGENCIAS_SUBCARTERA_BO)
	void guardarAgenciasSubcartera(RecobroSubcarAgenciaDto dto, RecobroSubcarteraAgenciasGrid gridItems);

	/**
	 * Cambiar el estado del esquema recibido según el código de estado recibido
	 * @param idCarteraEsquema
	 * @param codEstado
	 * @param map
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_ESQUEMA_CABIAR_ESTADO_BO)
	void cambiarEstadoRecobroEsquema(Long idEsquema, String codEstado);

	/**
	 * Devuelve el resultado de la simulación de un esquema
	 * @param idEsquema
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_GET_SIMULACION_ESQUEMA_BO)
	RecobroSimulacionEsquema getSimulacion(Long idEsquema);

	/**
	 * Devuelve el resultado o el detalle de la simulación del esquema realizada por batch según el tipo de fichero
	 * @param idEsquema
	 * @param tipoFichero RES=Resumen, DET=Detalle
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_GET_FICHERO_SIMULACION_BO)
	FileItem getFicheroSimulacion(Long idEsquema, String tipoFichero);

	/**
	 * Crea una copia exacta del esquema cuyo id coincide con el que se la pasa como parámetro
	 * @param idEsquema
	 * @param resetVersion : si true la versión del esquema nuevo será la 1.0.0 y el nombre se le concatenará
	 * "_COPIA", si no será la misma versión que la del esquema y el nombre también el mismo 
	 * @return id del esquema creado
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_COPIAR_ESQUEMA_BO)
	Long copiaEsquema(Long idEsquema, Boolean resetVersion);

	/**
	 * Consulta si el esquema recibido es la última versión de dicho esquema
	 * @param idEsquema
	 * @return true si es la última versión y false si no lo es
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_ULTIMA_VERSION_ESQUEMA_BO)
	boolean ultimaVersionDelEsquema(Long idEsquema);
	
	/**
	 *  A partir de un esquema indica se es una version del esquema liberado o no.
	 * @param esquema
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_EN_ESQUEMA_LIBERADO_BO)
	Boolean esVersionDelEsquemaliberado(RecobroEsquema esquema);

	/**
	 * Devuelve el esquema recibido en su última versión
	 * @param idEsquema
	 * @return el esquema en su ultima versión
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_GET_ULTIMA_VERSION_ESQUEMA_BO)
	RecobroEsquema getUltimaVersionDelEsquema(Long idEsquema);

	/**
	 * Devuelve true cuando un esquema está en estado simulado o en definición si pertenece al grupo del esquema liberado
	 * y no se ha cambiado la versión del esquema
	 * Si no está simulado o ha cambiado la versión del esquema en vigor no se podrá liberar sin simular
	 * @param idEsquema
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBROCONFIG_ESQUEMAAPI_APTOLIBERAR_BO )
	Boolean compruebaEstadoCorrectoLiberar(Long idEsquema);


	/**
	 * Devuelve una lista de esquemas a los que ya no se les deben modificar los datos 
	 * por estar liberado, pdt. liberar o simulado
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_GET_ESQUEMAS_BLOQUEADOS)
	List<RecobroEsquema> getEsquemasBloqueados();
}
