package es.pfsgroup.plugin.recovery.masivo.api;

import java.util.Collection;
import java.util.Date;

import es.capgemini.pfs.asunto.model.Asunto;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.model.MSVAsunto;

/**
 * Manager encargado de comprobar si el asunto se encuentra en un estado vï¿½lido.
 * @author manuel
 *
 */
public interface MSVAsuntoApi {
	
	public static final String MSV_BO_COMPROBAR_ESTADO_ASUNTO = "es.pfsgroup.plugin.recovery.masivo.api.comprobarEstadoAsunto";
	public static final String MSV_BO_CONSULTAR_ASUNTOS = "es.pfsgroup.plugin.recovery.masivo.api.consultarAsuntos";
	public static final String MSV_ASUNTO_CANCELA_ASUNTO = "es.pfsgroup.plugin.recovery.masivo.api.cancelaAsunto";
	public static final String MSV_ASUNTO_CANCELA_ASUNTO_CON_MOTIVO = "es.pfsgroup.plugin.recovery.masivo.api.cancelaAsuntoConMotivo";
	public static final String MSV_ASUNTO_PARALIZA_ASUNTO = "es.pfsgroup.plugin.recovery.masivo.api.paralizaAsunto";
	public static final String MSV_USUARIO_MASIVO = "MASIVO";
	
	/**
	 * Devuelve si el estado del asunto es vÃ¡lido o no (recibe el nombre del asunto)
	 * @return boolean
	 */
	@BusinessOperationDefinition(MSV_BO_COMPROBAR_ESTADO_ASUNTO)
	public boolean comprobarEstadoAsunto(String nombreAsunto);

	/**
	 * Devuelve la lista de asuntos que concuerdan con la expresión pasada
	 * (Puede incluir nombre de asunto, plaza, juzgado, auto
	 * @return boolean
	 */
	@BusinessOperationDefinition(MSV_BO_CONSULTAR_ASUNTOS)
	public Collection<? extends MSVAsunto>  getAsuntos(String query);
	
	/**
	 * Cancela el asunto y cierra sus procedimientos activos
	 * @param asunto
	 * @param fechaCancelacion
	 */
	@BusinessOperationDefinition(MSV_ASUNTO_CANCELA_ASUNTO)
	public void cancelaAsunto(Asunto asunto, Date fechaCancelacion);
	
	/**
	 * Cancela el asunto y cierra sus procedimientos activos
	 * @param asunto
	 * @param fechaCancelacion
	 * @param motivoCancelacion
	 */
	@BusinessOperationDefinition(MSV_ASUNTO_CANCELA_ASUNTO_CON_MOTIVO)
	public void cancelaAsuntoConMotivo(Asunto asunto, Date fechaCancelacion,String motivoCancelacion);
	
	/**
	 * Paraliza los procedimientos activos del asunto
	 * @param asunto
	 * @param fechaParalizacion
	 */
	@BusinessOperationDefinition(MSV_ASUNTO_PARALIZA_ASUNTO)
	public void paralizaAsunto(Asunto asunto, Date fechaParalizacion);
	
	/**
	 * Devuelve la lista de asuntos que pertenecen al usuario logueado y a su grupo y además que concuerdan con la expresión pasada
	 * (Puede incluir nombre de asunto, plaza, juzgado, auto
	 * @return boolean
	 */
	public Collection<? extends MSVAsunto> getAsuntosGrupoUsuarios(String query);

}
