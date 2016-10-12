package es.pfsgroup.plugin.rem.notificacion.api;

import java.util.Date;
import java.util.List;
import java.util.Map;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJRegistro;

public interface RegistroApi {
	
	
	public static final String PLUGIN_REM_REGISTRO_DEJAR_TRAZA = "es.pfsgroup.recovery.cdc.api.dejarTraza";	
	public static final String PLUGIN_REM_REGISTRO_CREA_INFO_TAREA = "es.pfsgroup.recovery.cdc.api.createInfoEventoTarea";	
	public static final String PLUGIN_REM_REGISTRO_CREA_INFO_NOTIFICACION = "es.pfsgroup.recovery.cdc.api.createInfoEventoNotificacion";
	public static final String PLUGIN_REM_REGISTRO_CREA_INFO_COMENTARIO = "es.pfsgroup.recovery.cdc.api.createInfoEventoComentario";
	public static final String PLUGIN_REM_REGISTRO_CREA_INFO_MAIL = "es.pfsgroup.recovery.cdc.api.createInfoEventoMail";
	public static final String PLUGIN_REM_REGISTRO_CREA_INFO_MAIL_CON_ADJUNTO = "es.pfsgroup.recovery.cdc.api.createInfoEventoMailConAdjunto";
	public static final String PLUGIN_REM_REGISTRO_DELETE_ATTRIBUTE_INFO_REGISTRO = "es.pfsgroup.recovery.cdc.api.deleteAttributeInfoRegistro";
	
	public interface EventoTarea {
		public static final String ID_ADJUNTO_CREAR_TAREA = "ADJUNTO_CREAR_TAREA";
		public static final String ID_ADJUNTO_RESP_TAREA = "ADJUNTO_RESP_TAREA";
        public static final String LISTA_MAIL_PARA_TAREA = "LIST_MAIL_PARA_TAREA";
    	public static final String LISTA_MAIL_CC_TAREA = "LIST_MAIL_CC_TAREA";
    	public static final String ID_TAREA_APP_EXTERNA = "ID_TAREA_APP_EXTERNA";
	}
	
	public interface EventoNotificacion {
		public static final String ID_ADJUNTO_CREAR_NOTIF = "ADJUNTO_CREAR_NOTIF";
		public static final String ID_ADJUNTO_RESP_NOTIF = "ADJUNTO_RESP_NOTIF";
		public static final String LISTA_MAIL_PARA_NOTIF = "LIST_MAIL_PARA_NOTIF";
	    public static final String LISTA_MAIL_CC_NOTIF = "LIST_MAIL_CC_NOTIF";
	    public static final String ID_TAREA_APP_EXTERNA = "ID_TAREA_APP_EXTERNA";
    }
	 
	
	

	

	
	/**
	 * Genera el registro 
	 * @param idUsuario emi
	 * @param tipoEvento codigo de MEJDDTipoRegistro
	 * @param idUg id de la entidad a registrar
	 * @param codUg codigo de DDTipoEntidad
	 * @param infoEvento informacion adicional a registrar
	 * @param registro Si no se pasa, se crea un registro nuevo. Si se pasa, se actualiza el registro con los datos de infoEvento
	 * @return 
	 */
	@BusinessOperationDefinition(PLUGIN_REM_REGISTRO_DEJAR_TRAZA)
	public void dejarTraza(final long idUsuario, final String tipoEvento,
			final long idUg, final String codUg, final Map<String, Object> infoEvento, 
			final MEJRegistro registro);
	
	
	
	/**
	 * Genera la informaci�n adicional a un registro de tipo TAREA. A�adir parametros seg�n necesidades
	 * @param idTarea idtarea asociada al registro
	 * @param emisor idusuario emisor de la tarea
	 * @param fecha_creacion fecha creacion tarea
	 * @param fecha_vencimiento fecha vencimeinto tarea
	 * @param destinatario idusuario destinatario de la tarea
	 * @param asunto asunto de la anotacion
	 * @param descripcion cuerpo de la anotacion
	 * @param mail true si hay que enviar email.
	 * @param tipoAnotacion clave del inforegistro
	 * @param mailPara List<String> con las direcciones de correo destino.
	 * @param mailCc List<String> con las direcciones de correo en copia.
	 * @param idAdjunto id del adjunto a un expediente
	 * @return 
	 */
	@BusinessOperationDefinition(PLUGIN_REM_REGISTRO_CREA_INFO_TAREA)
	public Map<String, Object> createInfoEventoTarea(Long idTarea,
			Long emisor, Date fecha_creacion, Date fecha_vencimiento,
			Long destinatario, String asunto, String descripcion, boolean mail,
			String tipoAnotacion, List<String> mailPara, List<String> mailCc,
			String idAdjuntoCrear, String idAdjuntoResp, Long idTareaAppExterna);
	
	
	
	

	/**
	 * Genera la informaci�n adicional a un registro de tipo NOTIFICACION. A�adir parametros seg�n necesidades
	 * @param idnotificacion idnotificacion asociada al registro
	 * @param emisor idusuario emisor de la tarea
	 * @param fecha_creacion fecha creacion tarea
	 * @param destinatario idusuario destinatario de la tarea
	 * @param asunto asunto de la anotacion
	 * @param descripcion cuerpo de la anotacion
	 * @param mail true si hay que enviar email.
	 * @param tipoAnotacion clave del inforegistro
	 * @param mailPara List<String> con las direcciones de correo destino.
	 * @param mailCc List<String> con las direcciones de correo en copia.
	 * @param idAdjunto id del adjunto a un expediente
	 * @return 
	 */
	@BusinessOperationDefinition(PLUGIN_REM_REGISTRO_CREA_INFO_NOTIFICACION)
	public Map<String, Object> createInfoEventoNotificacion(Long idnotificacion,
			Long emisor, Date fecha_creacion,
			Long destinatario, String asunto, String descripcion, boolean mail,
			String tipoAnotacion, List<String> mailPara, List<String> mailCc,
			String idAdjuntoCrear,String idAdjuntoResp, Long idTareaAppExterna);

	
	
	/**
	 * Genera la informaci�n adicional a un registro de tipo COMENTARIO. A�adir parametros seg�n necesidades
	 * @param emisor idusuario emisor de la tarea
	 * @param fecha_creacion fecha creacion tarea
	 * @param asunto asunto de la anotacion
	 * @param descripcion cuerpo de la anotacion
	 * @param tipoAnotacion clave del inforegistro
	 * @return 
	 */
	@BusinessOperationDefinition(PLUGIN_REM_REGISTRO_CREA_INFO_COMENTARIO)
	public Map<String, Object> createInfoEventoComentario(Long emisor,
			Date fecha_creacion, String asunto, String descripcion,
			String tipoAnotacion, Long idTareaAppExterna);
	
	
	
	/**
	 * Genera la informaci�n adicional a un registro de tipo MAIL. A�adir parametros seg�n necesidades
	 * @param asunto asunto de la anotacion
	 * @param from direcci�n correo para
	 * @param destino destinatario mail
	 * @param cc direcci�n correo en copia
	 * @param cuerpo contenido del correo
	 * @return 
	 */
	@BusinessOperationDefinition(PLUGIN_REM_REGISTRO_CREA_INFO_MAIL)
	public Map<String, Object> createInfoEventoMail(String asunto,
			String from, String destino, String cc, String cuerpo);
	
	
	
	/**
	 * Genera la informaci�n adicional a un registro de tipo MAIL_CON_ADJUNTOS. A�adir parametros seg�n necesidades
	 * @param asunto asunto de la anotacion
	 * @param from direcci�n correo para
	 * @param destino destinatario mail
	 * @param cc direcci�n correo en copia
	 * @param cuerpo contenido del correo
	 * @param adjuntosList lista de adjuntos a enviar por correo
	 * @return 
	 */
	@BusinessOperationDefinition(PLUGIN_REM_REGISTRO_CREA_INFO_MAIL_CON_ADJUNTO)
	public Map<String, Object> createInfoEventoMailConAdjunto(
			String asunto, String from,
			String destino,
			String cc, String cuerpo,
			List<DtoAdjuntoMail> adjuntosList);
	
	
	
	/**
	 * Borra un atributo de la informaci�n adicional de un registro. 
	 * @param Attribute cadena identificadora del atributo a eliminar
	 * @param idTraza identificador del registro
	 * @return true si se ha eliminado el atributo
	 */
	@BusinessOperationDefinition(PLUGIN_REM_REGISTRO_DELETE_ATTRIBUTE_INFO_REGISTRO)
	public Boolean deleteAttributeInfoRegistro(String Attribute, Long idTraza);

}
