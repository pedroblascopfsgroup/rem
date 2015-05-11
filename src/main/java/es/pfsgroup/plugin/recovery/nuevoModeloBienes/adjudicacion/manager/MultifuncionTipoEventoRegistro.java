package es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicacion.manager;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoAdjuntoMail;

public class MultifuncionTipoEventoRegistro {

	public static final String TIPO_EVENTO_TAREA = "ANO_TAREA";
	public static final String TIPO_EVENTO_COMENTARIO = "ANO_COMENTARIO";
	public static final String TIPO_EVENTO_NOTIFICACION = "ANO_NOTIFICACION";
	public static final String TIPO_EVENTO_RESPUESTA_TAREA = "ANO_RESP_TAREA";
	public static final String TIPO_EVENTO_CORREO_ELECTRONICO = "EML";
	public static final String TIPO_EVENTO_ANO_ESPECIALIZADA = "ANO_ESPECIALIZADA";

	public interface EventoTarea {

		public static final String ID_TAREA = "ID_TAREA";
		public static final String EMISOR_TAREA = "EMISOR_TAREA";
		public static final String FECHA_CREACION_TAREA = "FECHA_CREAR_TAREA";
		public static final String FECHA_VENCIMIENTO_TAREA = "FECHA_VENC_TAREA";
		public static final String DESTINATARIO_TAREA = "DESTINATARIO_TAREA";
		public static final String ASUNTO_TAREA = "ASUNTO_TAREA";
		public static final String DESCRIPCION_TAREA = "DESCRIPCION_TAREA";
		public static final String FLAG_MAIL = "FLAG_MAIL_TAREA";
		public static final String TIPO_ANOTACION = "TIPO_ANO_TAREA";
	}

	public interface EventoComentario {

		public static final String EMISOR_COMENTARIO = "EMISOR_COMENT";
		public static final String FECHA_CREACION_COMENTARIO = "FECHA_CREAR_COMENT";
		public static final String ASUNTO_COMENTARIO = "ASUNTO_COMENT";
		public static final String DESCRIPCION_COMENTARIO = "DESCRIPCION_COMENT";
		public static final String TIPO_ANOTACION = "TIPO_ANO_COMENT";
	}

	public interface EventoNotificacion {

		public static final String ID_NOTIFICACION = "ID_NOTIF";
		public static final String EMISOR_NOTIFICACION = "EMISOR_NOTIF";
		public static final String FECHA_CREACION_NOTIFICACION = "FECHA_CREAR_NOTIF";
		public static final String DESTINATARIO_NOTIFICACION = "DESTINATARIO_NOTIF";
		public static final String ASUNTO_NOTIFICACION = "ASUNTO_NOTIF";
		public static final String DESCRIPCION_NOTIFICACION = "DESCRIPCION_NOTIF";
		public static final String FLAG_MAIL = "FLAG_MAIL_NOTIF";
		public static final String TIPO_ANOTACION = "TIPO_ANO_NOTIF";
	}

	public interface EventoRespuesta {
		public static final String ID_TAREA = "ID_TAREA_RESP";
		public static final String ID_TAREA_ORIGINAL = "ID_TAREA_ORIGINAL";
		public static final String FECHA_RESPUESTA = "FECHA_RESP_TAREA";
		public static final String RESPUESTA_TAREA = "RESP_TAREA";
		public static final String TIPO_ANOTACION = "TIPO_ANO_RESP";

	}

	public interface EventoCorreo {
		public static final String CORREO_BODY = "emailBody";
		public static final String CORREO_TO = "emailTo";
		public static final String CORREO_CC = "emailCC";
		public static final String CORREO_DESTINATARIO = "emailReceiver";
		public static final String CORREO_ASUNTO = "emailSubject";
		public static final String CORREO_FROM = "emailFrom";
		public static final String CORREO_SUPERVISOR = "emailSupervisor";
		public static final String CLAVE_ADJUNTOS = "emailAdjuntos";
	}

	public static Map<String, Object> createInfoEventoNotificacion(
			Long idnotificacion, Long emisor, Date fecha_creacion,
			Long destinatario, String asunto, String descripcion, boolean mail,
			String tipoAnotacion) {
		HashMap<String, Object> info = new HashMap<String, Object>();
		info.put(EventoNotificacion.ID_NOTIFICACION, idnotificacion);
		info.put(EventoNotificacion.EMISOR_NOTIFICACION, emisor);
		info.put(EventoNotificacion.FECHA_CREACION_NOTIFICACION, fecha_creacion);
		info.put(EventoNotificacion.DESTINATARIO_NOTIFICACION, destinatario);
		info.put(EventoNotificacion.ASUNTO_NOTIFICACION, asunto);
		info.put(EventoNotificacion.DESCRIPCION_NOTIFICACION, descripcion);
		if (mail) {
			info.put(EventoNotificacion.FLAG_MAIL, 1);
		}
		info.put(EventoNotificacion.TIPO_ANOTACION, tipoAnotacion);
		return info;
	}

	public static Map<String, Object> createInfoEventoTarea(Long idTarea,
			Long emisor, Date fecha_creacion, Date fecha_vencimiento,
			Long destinatario, String asunto, String descripcion, boolean mail,
			String tipoAnotacion) {
		HashMap<String, Object> info = new HashMap<String, Object>();
		info.put(EventoTarea.ID_TAREA, idTarea);
		info.put(EventoTarea.EMISOR_TAREA, emisor);
		info.put(EventoTarea.FECHA_CREACION_TAREA, fecha_creacion);
		info.put(EventoTarea.FECHA_VENCIMIENTO_TAREA, fecha_vencimiento);
		info.put(EventoTarea.DESTINATARIO_TAREA, destinatario);
		info.put(EventoTarea.ASUNTO_TAREA, asunto);
		info.put(EventoTarea.DESCRIPCION_TAREA, descripcion);
		if (mail) {
			info.put(EventoTarea.FLAG_MAIL, 1);
		}
		info.put(EventoTarea.TIPO_ANOTACION, tipoAnotacion);
		return info;
	}

	public static Map<String, Object> createInfoEventoComentario(Long emisor,
			Date fecha_creacion, String asunto, String descripcion,
			String tipoAnotacion) {
		HashMap<String, Object> info = new HashMap<String, Object>();
		info.put(EventoComentario.EMISOR_COMENTARIO, emisor);
		info.put(EventoComentario.FECHA_CREACION_COMENTARIO, fecha_creacion);
		info.put(EventoComentario.ASUNTO_COMENTARIO, asunto);
		info.put(EventoComentario.DESCRIPCION_COMENTARIO, descripcion);
		info.put(EventoComentario.TIPO_ANOTACION, tipoAnotacion);
		return info;
	}

	public static Map<String, Object> createInfoEventoMail(String asunto,
			String from, String destino, String cc, String cuerpo) {
		HashMap<String, Object> info = new HashMap<String, Object>();

		info.put(EventoCorreo.CORREO_FROM, from);
		info.put(EventoCorreo.CORREO_ASUNTO, asunto);
		info.put(EventoCorreo.CORREO_TO, destino);
		info.put(EventoCorreo.CORREO_CC, cc);
		info.put(EventoCorreo.CORREO_BODY, cuerpo);

		return info;
	}

	public static Map<String, Object> createInfoEventoMailConAdjunto(
			String asunto, String from, String destino, String cc,
			String cuerpo, List<DtoAdjuntoMail> adjuntosList) {
		HashMap<String, Object> info = new HashMap<String, Object>();

		info.put(EventoCorreo.CORREO_FROM, from);
		info.put(EventoCorreo.CORREO_ASUNTO, asunto);
		info.put(EventoCorreo.CORREO_TO, destino);
		info.put(EventoCorreo.CORREO_CC, cc);
		info.put(EventoCorreo.CORREO_BODY, cuerpo);
		
		if (!Checks.esNulo(adjuntosList) && !Checks.estaVacio(adjuntosList)) {
			String adjuntos = "";
			for (DtoAdjuntoMail adjunto : adjuntosList) {
				if ("".equals(adjuntos)) {
					adjuntos = adjuntos + adjunto.getAdjunto().getId();
				} else {
					adjuntos = adjuntos + "," + adjunto.getAdjunto().getId();
				}
			}
			info.put(EventoCorreo.CLAVE_ADJUNTOS, adjuntos);
		}

		return info;
	}
}
