package es.pfsgroup.plugin.recovery.masivo.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVConfImpulsoAutomaticoBusquedaDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVConfImpulsoAutomaticoDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVConfImpulsoAutomatico;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoJuicio;

public interface MSVConfImpulsoAutomaticoApi {
	
	public static final String PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_CONFIMP = "plugin.masivo.confImpulso.buscaConfImpulsos";
	public static final String PLUGIN_MASIVO_CONF_IMPULSO_GET_CONFIMP_POR_ID = "plugin.masivo.confImpulso.getConfImpulsoPorId";
	public static final String PLUGIN_MASIVO_CONF_IMPULSO_GET_CONFIMP_POR_DTO = "plugin.masivo.confImpulso.getConfImpulsoPorDto";
	public static final String PLUGIN_MASIVO_CONF_IMPULSO_GUARDAR_CONFIMP = "plugin.masivo.confImpulso.guardarConfImpulso";
	public static final String PLUGIN_MASIVO_CONF_IMPULSO_BORRAR_CONFIMP = "plugin.masivo.confImpulso.borrarConfImpulso";
	
	public static final String PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_TIPO_JUICIOS = "plugin.masivo.confImpulso.buscaTipoJuicios";
	public static final String PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_TAREAS_PROCEDIMIENTO = "plugin.masivo.confImpulso.buscaTareasProcedimiento";
	public static final String PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_DESPACHOS = "plugin.masivo.confImpulso.buscaDespachos";

	public static final String PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_CARTERAS = "plugin.masivo.confImpulso.buscaCarteras";
	
	/**
	 * Obtiene un Page de Configuraciones de Impulso
	 * @param dtoBusqueda
	 * @return
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_CONFIMP)
	public Page buscaConfImpulsos(MSVConfImpulsoAutomaticoBusquedaDto dtoBusqueda);
	
	/**
	 * Obtiene la configuración de Impulso Automático por id
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_CONF_IMPULSO_GET_CONFIMP_POR_ID)
	public MSVConfImpulsoAutomatico getConfImpulsoPorId(Long id);
	
	/**
	 * Obtiene la configuración de Impulso Automático por criterios del Dto
	 * @param Dto 
	 * @return debe devolver un único objeto o si no devolverá null
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_CONF_IMPULSO_GET_CONFIMP_POR_DTO)
	public MSVConfImpulsoAutomatico getConfImpulsoPorDto(MSVConfImpulsoAutomaticoBusquedaDto dtoBusqueda);
	
	/**
	 * Guarda los datos de la configuración de Impulso Automático
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_CONF_IMPULSO_GUARDAR_CONFIMP)
	public MSVConfImpulsoAutomatico guardarConfImpulso(MSVConfImpulsoAutomaticoDto dto) throws Exception;
	
	/**
	 * Borra la configuración de Impulso Automático designada por id
	 * @param id
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_CONF_IMPULSO_BORRAR_CONFIMP)
	public void borrarConfImpulso(Long id) throws Exception;
	

	/**
	 * Obtiene una lista de tipos de juicio
	 * @return lista de tipos de juicio aplicables
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_TIPO_JUICIOS)
	public List<MSVDDTipoJuicio> buscaTipoJuicios();
	
	/**
	 * Obtiene una lista de tareas/procedimiento a partir de un id de procedimiento
	 * @param id del tipo de juicio
	 * @return lista de tipos de tarea del procedimiento
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_TAREAS_PROCEDIMIENTO)
	public List<TareaProcedimiento> buscaTareasProcedimiento(Long idTipoJuicio);
	
	/**
	 * Obtiene una lista de despachos externos existentes
	 * @return lista de despachos externos existentes
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_DESPACHOS)
	public List<DespachoExterno> buscaDespachos();

	/**
	 * Obtiene la lista de carteras existentes
	 * @return lista de carteras existentes
	 */
	@BusinessOperationDefinition(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_CARTERAS)
	public List<String> buscaCarteras();
	
}
