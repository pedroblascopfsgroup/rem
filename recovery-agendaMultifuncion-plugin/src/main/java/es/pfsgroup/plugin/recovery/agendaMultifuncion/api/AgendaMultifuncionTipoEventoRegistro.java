package es.pfsgroup.plugin.recovery.agendaMultifuncion.api;

import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;

public interface AgendaMultifuncionTipoEventoRegistro {

    public static final String TIPO_EVENTO_TAREA = "ANO_TAREA";
    public static final String TIPO_EVENTO_COMENTARIO = "ANO_COMENTARIO";
    public static final String TIPO_EVENTO_NOTIFICACION = "ANO_NOTIFICACION";
    public static final String TIPO_EVENTO_RESPUESTA_TAREA = "ANO_RESP_TAREA";
    public static final String TIPO_EVENTO_CORREO_ELECTRONICO = MEJDDTipoRegistro.CODIGO_ENVIO_EMAILS;
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
    	public static final String CORREO_BODY = MEJDDTipoRegistro.RegistroEmail.CLAVE_CUERPO;
    	public static final String CORREO_TO = MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_DESTINO;
    	public static final String CORREO_CC = MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_CC;
    	public static final String CORREO_DESTINATARIO = MEJDDTipoRegistro.RegistroEmail.CLAVE_DESTINATARIO;
    	public static final String CORREO_ASUNTO = MEJDDTipoRegistro.RegistroEmail.CLAVE_ASUNTO;
    	public static final String CORREO_FROM = MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_ORIGEN;
    	public static final String CORREO_SUPERVISOR = MEJDDTipoRegistro.RegistroEmail.CLAVE_SUPERVISOR;
    	
    }
}
