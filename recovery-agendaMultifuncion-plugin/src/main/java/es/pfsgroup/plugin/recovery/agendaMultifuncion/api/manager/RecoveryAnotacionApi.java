package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager;

import java.util.Collection;
import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.AnotacionAgendaDto;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionInfo;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionRespuestaTareaInfo;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;

public interface RecoveryAnotacionApi {

	final static String AMF_GET_CODIGO_LITIGIO 		= "es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.getCodigoLitigioAsu";
	final static String AMF_GET_USUARIOS 			= "es.pfsgroup.plugin.recovery.agendaMultifuncion.anotacion.getUsuarios";
	final static String AMF_GET_TIPOS_ANOTACIONES 	= "es.pfsgroup.plugin.recovery.agendaMultifuncion.anotacion.getTiposAnotacion";
	final static String AMF_CREATE_ANOTACION 		= "es.pfsgroup.plugin.recovery.agendaMultifuncion.anotacion.createAnotacion";
	final static String AMF_CREATE_RESPUESTA 		= "es.pfsgroup.plugin.recovery.agendaMultifuncion.anotacion.createRespuesta";
	final static String AMF_GET_ANOTACIONES_AGENDA  = "es.pfsgroup.plugin.recovery.agendaMultifuncion.anotacion.getAnotacionesAgenda";
	static final String AMF_GET_TIPO_ANOTACION_BY_CODIGO = "es.pfsgroup.plugin.recovery.agendaMultifuncion.anotacion.getTipoAnotacionByCodigo";
	
	/**
	 * Recupera los usuarios cuyo nombre contiene el texto query
	 * 
	 * @param query
	 *            Es la query que envia desde la Web para filtrar
	 * @return
	 */
	@BusinessOperationDefinition(AMF_GET_USUARIOS)
	public Collection<? extends Usuario> getUsuarios(String query);

	/**
	 * Método para crear una anotación
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(AMF_CREATE_ANOTACION)
	public List<Long> createAnotacion(DtoCrearAnotacionInfo dto);

	@BusinessOperationDefinition(AMF_CREATE_RESPUESTA)
	public void createRespuesta(DtoCrearAnotacionRespuestaTareaInfo dto);

	@BusinessOperationDefinition(AMF_GET_TIPOS_ANOTACIONES)
	public List<DDTipoAnotacion> getListaTiposAnotacion();

	/**
	 * Devuelve las anotaciones que haya para una determinada unidad de gestión
	 * 
	 * @param tipoUnidadGestion
	 *            Tipo de la unidad de gestión
	 * @param idUnidadGestion
	 *            Identificador de la unidad de gestión
	 * @param tipoAnotacion
	 *            Tipos de anotaciones que queremos devolver. Si no
	 *            especificamos ningún tipo, se van a devolver todas las
	 *            anotaciones relativas a la unidad de gestión. Si se
	 *            especifican uno o más tipos se devolverán sólo esas.
	 * @return
	 */
	@BusinessOperationDefinition(AMF_GET_ANOTACIONES_AGENDA)
	public List<AnotacionAgendaDto> getAnotacionesAgenda(
			String tipoUnidadGestion, Long idUnidadGestion,
			String[] tipoAnotacion);
	
	
	/**
	 * Devuelve el tipo de anotación dado el código
	 * @param codigo
	 * @return
	 */
	@BusinessOperationDefinition(AMF_GET_TIPO_ANOTACION_BY_CODIGO)
	public DDTipoAnotacion getTipoAnotacionByCodigo(String codigo);
	
	/**
	 * Devuelve el  código de litigio del asunto
	 * @param codigo
	 * @return
	 */
	@BusinessOperationDefinition(AMF_GET_CODIGO_LITIGIO)
	public String getCodigoLitigioAsu(Long id);

}
