package es.capgemini.pfs.procesosJudiciales.model;

/**
 * Constantes Para Los Procesos Judiciales.
 * @author jbosnjak, marruiz
 */
public interface TareasProcesosJudicialesConstants {

	/*
	 * Procedimiento Ejecucion Titulo Judicial
	 */
	String ETJ_TAREA_INTERPOSICION_DEMANDA_TITULO_JUDICIAL = "101";
	String ETJ_TAREA_AUTO_DESPACHO_EJECUCION = "102";
	String ETJ_TAREA_REGISTRAR_ANOTACION_REGISTRO = "103";
	String ETJ_TAREA_CONFIRMAR_NOTIFICACION = "104";
	String ETJ_TAREA_REGISTRAR_OPOSICION_VISTA = "105";
	String ETJ_TAREA_HAY_VISTA = "106";
	String ETJ_TAREA_REGISTRAR_VISTA= "107";
	String ETJ_TAREA_REGISTRAR_RESOLUCION = "108";
	String ETJ_TAREA_RESOLUCION_FIRME = "109";

	/*
	 * Procesos del trámite de embargo de salarios
	 */
    String TES_TAREA_SOLICITAR_NOTIF_RET_PAGADOR = "201";
    String TES_TAREA_CONFIRMAR_RETENCIONES = "202";
    String TES_TAREA_GESTIONAR_PROBLEMAS_RETENCION = "203";
    String TES_TAREA_ACTUALIZAR_SOLVENCIA_CLIENTE = "204";

    /*
     * Procesos del trámite de interes
     */
    String TI_TAREA_ELABORAR_ENVIAR_LIQ_INTERESES = "301";
    String TI_TAREA_SOL_LIQ_INTERES = "302";
    String TI_TAREA_REGISTRAR_RESOLUCION = "303";
    String TI_TAREA_CONFIRMAR_NOTIFICACION = "304";
    String TI_TAREA_REGISTRAR_IMPUGNACION = "305";
    String TI_TAREA_REGISTRAR_VISTA = "306";
    String TI_TAREA_REGISTRAR_RESOLUCION_2 = "307";
    String TI_TAREA_RESOLUCION_FIRME = "308";

    /*
     * Procesos de trámite de subasta
     */
    String TS_SOL_SUBASTA_ESTIMACION_COSTOS = "401";
    String TS_DICTAR_INSTRUCCIONES = "402";
    String TS_ACEPTACION_INSTRUCCIONES = "403";
    String TS_ANUNCIO_SUBASTA = "404";
    String TS_CELEBRACION_SUBASTA = "405";
    String TS_SOL_MANDAMIENTO_PAGO = "406";
    String TS_COBRO = "407";
}
