package es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api;

import java.util.Date;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoCrearAnotacion;

public interface AdjudicacionHandlerDelegateApi {
	
	public static final String BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_PRESENTACION = "es.pfsgroup.recovery.adjudicacion.insertarFechaPresentacionCarga";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_INS = "es.pfsgroup.recovery.adjudicacion.insertarFechaInsCarga";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CAMBIO_CERRADURA = "es.pfsgroup.recovery.adjudicacion.insertarFechaCambioCerradura";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_ER_DEPO = "es.pfsgroup.recovery.adjudicacion.insertarNombreErDepo";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_ENVIO = "es.pfsgroup.recovery.adjudicacion.insertarFechaEnvioLlaves";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_ER_DEPO = "es.pfsgroup.recovery.adjudicacion.insertarFechaRecepcionErDepo";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_DEPO_FINAL = "es.pfsgroup.recovery.adjudicacion.insertarNombreDepoFinal";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEP_FINAL = "es.pfsgroup.recovery.adjudicacion.insertarFechaRecepcionFinal";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_LLAVES = "es.pfsgroup.recovery.adjudicacion.insertarFechaRecepcionLLaves";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_SOL_MORAT = "es.pfsgroup.recovery.adjudicacion.insertarFechaSolMorat";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_RES_MORAT= "es.pfsgroup.recovery.adjudicacion.insertarFechaResMorat";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_CARGA_RESULTADO_MORAT= "es.pfsgroup.recovery.adjudicacion.insertarResultadoMorat";
	
	
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPADO = "es.pfsgroup.recovery.posesion.ocupado";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_POSIBLE_POSESION = "es.pfsgroup.recovery.posesion.posiblePosesion";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOLICITUD = "es.pfsgroup.recovery.posesion.fechaSolicitud";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO = "es.pfsgroup.recovery.posesion.fechaSenayalamiento";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_REALIZACION = "es.pfsgroup.recovery.posesion.fechaRealizacion";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPANTES_DURANTE = "es.pfsgroup.recovery.posesion.ocupantesDurantePosesion";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_LANZAMIENTO_NECESARIO = "es.pfsgroup.recovery.posesion.lanzamientoNecesario";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOL_LANZAMIENTO = "es.pfsgroup.recovery.posesion.fechaSolicitudLanzamiento";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO_LANZAMIENTO = "es.pfsgroup.recovery.posesion.fechaSenyalamientoLanz";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_CREAR_ANOTACION = "es.pfsgroup.recovery.posesion.crearAnotacion";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_LANZAMIENTO_EFECTUADO = "es.pfsgroup.recovery.posesion.fechaLanzamientoEfec";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_LLAVES_NECESARIAS = "es.pfsgroup.recovery.posesion.llavesNecesarias";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_FUERZA_PUBLICA = "es.pfsgroup.recovery.posesion.fuerzaPublica";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_POSESION_ENTREGA_VOLUNTARIA = "es.pfsgroup.recovery.posesion.entregaVoluntaria";
		
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_SOLICITUD_DECRETO = "es.pfsgroup.recovery.adjudicacion.fechaSolicitudDecreto";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_NOTIFICACION_DECRETO = "es.pfsgroup.recovery.adjudicacion.fechaNotificacionDecreto";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_ENTIDAD_ADJUDICATARIA = "es.pfsgroup.recovery.adjudicacion.entidadAdjudicataria";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FONDO = "es.pfsgroup.recovery.adjudicacion.fondo";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_FECHA_NOTIF_DECRETO_AL_CONTRARIO = "es.pfsgroup.recovery.adjudicacion.fechaNotifDecretoAlContrario";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_FECHA_SOLICITUD_TESTIMONIO_DECRETO = "es.pfsgroup.recovery.adjudicacion.fechaSolicitudTestimonioDecreto";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_FECHA_TESTIMONIO_DECRETO = "es.pfsgroup.recovery.adjudicacion.fechaTestimonioDecreto";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_GESTORIA = "es.pfsgroup.recovery.adjudicacion.fechaEnvioGestoria";	
	public static final String BO_ADJUDICACION_HANDLER_INSERT_FECHA_RECEPCION = "es.pfsgroup.recovery.adjudicacion.fechaRecepcion";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_HACIENDA = "es.pfsgroup.recovery.adjudicacion.fechaPresentacionHacienda";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_REGISTRO = "es.pfsgroup.recovery.adjudicacion.fechaPresentacionRegistro";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_FECHA_INSCRIPCION_TITULO = "es.pfsgroup.recovery.adjudicacion.fechaInscripcionTitulo";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_DECRETO_ADICION = "es.pfsgroup.recovery.adjudicacion.fechaEnvioDecretoAdicion";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_SITUACION_TITULO = "es.pfsgroup.recovery.adjudicacion.situacionTitulo";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_GESTORIA = "es.pfsgroup.recovery.adjudicacion.insertarGestoria";
	public static final String BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CONTABILIDAD = "es.pfsgroup.recovery.adjudicacion.fechaContabilidad";
	
	/**
	 * Inserta fecha presentacion en las cargas de un bien
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_PRESENTACION)
	public void insertarFechaPresentacionCarga(Long prcId, Date fechaPresentacion);
	
	
	/**
	 * Inserta fecha Ins
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_INS)
	public void insertarFechaInsCarga(Long prcId, Date fechaIns);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CAMBIO_CERRADURA)
	public void insertarFechaCambioCerradura(Long prcId, Date fecha);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_ER_DEPO)
	public void insertarNombreErDepo(Long prcId, String nombre);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_ENVIO) 
	public void  insertarFechaEnvioLlaves(Long prcId, Date fecha);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_ER_DEPO) 
	public void insertarFechaRecepcionErDepo(Long prcId, Date fecha);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_DEPO_FINAL)
	public void insertarNombreDepoFinal(Long prcId, String nombre);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEP_FINAL) 
	public void insertarFechaRecepcionFinal(Long prcId, Date fecha);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_LLAVES) 
	public void insertarFechaRecepcionLLaves(Long prcId, Date fecha);
	
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_SOL_MORAT) 
	public void insertarFechaSolMorat(Long prcId, Date fecha);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_RES_MORAT) 
	public void insertarFechaResMorat(Long prcId, Date fecha);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_CARGA_RESULTADO_MORAT) 
	public void insertarResultadoMorat(Long prcId, String resultado);

	
	
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPADO) 
	public void insertarPosesionComboOcupado(Long prcId, Boolean valor);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_POSIBLE_POSESION) 
	public void insertarPosesionComboPosiblePosesion(Long prcId, Boolean valor);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOLICITUD) 
	public void insertarPosesionFechaSolicitud(Long prcId, Date valor);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO) 
	public void insertarPosesionFechaSenyalamiento(Long prcId, Date valor);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_REALIZACION) 
	public void insertarPosesionFechaRealizacion(Long prcId, Date valor);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPANTES_DURANTE) 
	public void insertarPosesionComboOcupantesDurantePosesion(Long prcId, Boolean valor);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_LANZAMIENTO_NECESARIO) 
	public void insertarPosesionComboLanzamientoNecesario(Long prcId, Boolean valor);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOL_LANZAMIENTO) 
	public void insertarPosesionFechaSolicitudLanzamiento(Long prcId, Date valor);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO_LANZAMIENTO) 
	public void insertarPosesionFechaSenyalamientoLanzamiento(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_CREAR_ANOTACION)
	public void createAnotacion(DtoCrearAnotacion dto);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_LANZAMIENTO_EFECTUADO) 
	public void insertarPosesionFechaLanzamientoEfectuado(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_LLAVES_NECESARIAS) 
	public void insertarPosesionComboGestionLlaves(Long prcId, Boolean valor);

	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FUERZA_PUBLICA) 
	public void insertarPosesionComboFuerzaPublica(Long prcId, Boolean valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_POSESION_ENTREGA_VOLUNTARIA) 
	public void insertarPosesionComboEntregaVoluntaria(Long prcId, Boolean valor);
		
	
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_SOLICITUD_DECRETO)
	public void insertarFechaSolicitudDecreto(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_NOTIFICACION_DECRETO)
	public void insertarFechaNotificacionDecreto(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_ENTIDAD_ADJUDICATARIA)
	public void insertarEntidadAdjudicataria(Long prcId, String valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FONDO)
	public void insertarFondo(Long prcId, String valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_FECHA_NOTIF_DECRETO_AL_CONTRARIO)
	public void insertarNotificacionDecretoAlContrario(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_FECHA_SOLICITUD_TESTIMONIO_DECRETO)
	public void insertarFechaSolicitudTestimonioDecreto(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_FECHA_TESTIMONIO_DECRETO)
	public void insertarFechaTestimonioDecreto(Long prcId, Date valor);	
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_GESTORIA)	
	public void insertarFechaEnvioGestoria(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_FECHA_RECEPCION)
	public void insertarFechaRecepcion(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_HACIENDA)
	public void insertarFechaPresentacionHacienda(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_REGISTRO)
	public void insertarFechaPresentacionRegistro(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_FECHA_INSCRIPCION_TITULO)
	public void insertarFechaInscripcionTitulo(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_DECRETO_ADICION)
	public void insertarFechaEnvioDecretoAdicion(Long prcId, Date valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_SITUACION_TITULO)
	public void insertarSituacionTitulo(Long prcId, String valor);
	
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CONTABILIDAD)
	public void insertarFechaContabilidad(Long prcId, Date valor);
	
	/**
	 * Inserta gestoría
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_GESTORIA)
	public void insertarGestoria(Long prcId);
	
			
}
