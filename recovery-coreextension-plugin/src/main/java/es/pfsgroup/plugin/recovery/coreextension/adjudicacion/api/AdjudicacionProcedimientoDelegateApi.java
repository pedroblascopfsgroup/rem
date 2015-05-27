package es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface AdjudicacionProcedimientoDelegateApi {
	public static final String BO_ADJUDICACION_COMPROBAR_BIEN_ASOCIADO_PRC = "es.pfsgroup.recovery.adjudicacion.comprobarBienAsociado";
	public static final String BO_ADJUDICACION_COMPROBAR_BIENES_ASOCIADO_PRC = "es.pfsgroup.recovery.adjudicacion.comprobarBienesAsociado";
	public static final String BO_ADJUDICACION_COMPROBAR_TIPO_CARGA_BIEN_INSCRITO = "es.pfsgroup.recovery.adjudicacion.comprobarTipoCargaBienInscrito";
	public static final String BO_ADJUDICACION_COMPROBAR_ESTADO_CARGAS_CANCELACION = "es.pfsgroup.recovery.adjudicacion.comprobarEstadoCargasCancelacion";
	public static final String BO_ADJUDICACION_COMPROBAR_ADJUNTO_PROPUESTA_CANCELACION_CARGAS = "es.pfsgroup.recovery.adjudicacion.comprobarAdjuntoPropuestaCancelacionCargas";
	public static final String BO_ADJUDICACION_COMPROBAR_ESTADO_CARGAS_PROPUESTA = "es.pfsgroup.recovery.adjudicacion.comprobarEstadoCargasPropuesta";
	public static final String BO_ADJUDICACION_COMPROBAR_ADJUNTO = "es.pfsgroup.recovery.adjudicacion.comprobarAdjunto";
	public static final String BO_ADJUDICACION_COMPROBAR_ADJUNTO_ASUNTO = "es.pfsgroup.recovery.adjudicacion.comprobarAdjuntoAsunto";
	public static final String BO_ADJUDICACION_OBTENER_TIPO_CARGA = "es.pfsgroup.recovery.adjudicacion.obtenerTipoCarga";
	public static final String BO_ADJUDICACION_COMPROBAR_GESTORIA_ASIGNADA_PRC = "es.pfsgroup.recovery.adjudicacion.comprobarGestoriaAsignadaPrc";
	public static final String BO_ADJUDICACION_COMPROBAR_GESTORIA_ASIGNADA_SANEAMIENTO_CARGAS_BIENES = "es.pfsgroup.recovery.adjudicacion.comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes";
	public static final String BO_ADJUDICACION_VIENE_DE_TRAMITE_POSESION = "es.pfsgroup.recovery.adjudicacion.vieneDeTramitePosesion";
	public static final String BO_ADJUDICACION_ESTAMOS_A_DOS_MESES = "es.pfsgroup.recovery.adjudicacion.estamosADosMeses";
	public static final String BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJUDICATARIA = "es.pfsgroup.recovery.adjudicacion.comprobarBienEntidadAdjudicataria";
	public static final String BO_ADJUDICACION_COMPROBAR_BIEN_SUJETO_IVA = "es.pfsgroup.recovery.adjudicacion.comprobarBienSujetoIVA";
	public static final String BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJ_TERCEROS= "es.pfsgroup.recovery.adjudicacion.comprobarBienEntidadAdjTerceros";
	public static final String BO_ADJUDICACION_COMPROBAR_FECHA_REVISION= "es.pfsgroup.recovery.adjudicacion.comprobarFechaRevision";
	public static final String BO_ADJUDICACION_EXISTE_BIEN_CON_ADJU_ENTIDAD= "es.pfsgroup.recovery.adjudicacion.existeBienConAdjuEntidad";
	public static final String BO_ADJUDICACION_ES_BIEN_CON_CESION_REMATE = "es.pfsgroup.recovery.adjudicacion.esBienConCesionRemate";
	public static final String BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJUDICATARIA_DECRETO = "es.pfsgroup.recovery.adjudicacion.comprobarBienEntidadAdjudicatariaDecreto";
	
	/**
	 * Método que comprueba si existe un adjunto x asociado al procedimiento
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_ADJUNTO)
	public Boolean comprobarAdjunto(Long prcId, String tipo);
	
	/**
	 * Método que comprueba si existe una entidad adjudicataria en eun bien
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_ADJUNTO_ASUNTO)
	public Boolean comprobarAdjuntoAsunto(Long asuId, String tipo);
	
	/**
	 * Método que comprueba si existe una entidad adjudicataria en eun bien
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJUDICATARIA)
	public Boolean comprobarBienEntidadAdjudicataria(Long bienId);
	
	/**
	 * Método que comprueba si existe una entidad adjudicataria en eun bien
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJ_TERCEROS)
	public Boolean comprobarBienEntidadAdjudicatariaTerceros(Long bienId);

	/**
	 * Método que comprueba si existe algún bien asociado al procedimiento.
	 * Puede tener más de uno.
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_BIEN_ASOCIADO_PRC)
	public Boolean comprobarBienAsociadoPrc(Long prcId);
	
		/**
	 * Método que comprueba si existe algún bien asociado al procedimiento.
	 * Puede tener más de uno.
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_BIENES_ASOCIADO_PRC)
	public Boolean comprobarBienesAsociadoPrc(Long prcId);

	/**
	 * Método que comprueba si por cada carga del bien asociado al
	 * procedimiento, tiene indicado el tipo de carga. En caso de no existir una
	 * carga del bien, debe estar así específicado en la ficha de las cargas del
	 * bien
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_TIPO_CARGA_BIEN_INSCRITO)
	public Boolean comprobarTipoCargaBienInscrito(Long prcId);

	/**
	 * Método que comprueba el estado de todas las cargas del bien inscrito. El
	 * estado de todas las cargas marcadas de tipo “Registral” en el bien
	 * inscrito, deben quedar todas en situación Cancelada.
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_ESTADO_CARGAS_CANCELACION)
	public Boolean comprobarEstadoCargasCancelacion(Long prcId);

	/**
	 * Método que comprueba si existe adjunto el documento propuesta cancelacion
	 * cargas
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_ADJUNTO_PROPUESTA_CANCELACION_CARGAS)
	public Boolean comprobarAdjuntoPropuestaCancelacionCargas(Long prcId);

	/**
	 * la gestoría deberá informar el estado en que haya quedado cada una de las
	 * cargas económicas gestionadas en el procedimiento. Los estados posibles
	 * serán Cancelada o Rechazada
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_ESTADO_CARGAS_PROPUESTA)
	public Boolean comprobarEstadoCargasPropuesta(Long prcId);

	/**
	 * Método que devuelve los tipos de cargas de un procedimiento. Si solo
	 * tiene tiene cargas regitrales: registrales; Si es de tipo economica:
	 * ambos; Si no tiene cargas: noCargas
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_OBTENER_TIPO_CARGA)
	public String obtenerTipoCarga(Long prcId);
	
	
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_GESTORIA_ASIGNADA_PRC)
	public Boolean comprobarGestoriaAsignadaPrc(Long prcId);
	
	
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_GESTORIA_ASIGNADA_SANEAMIENTO_CARGAS_BIENES)
	public Boolean comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes(Long prcId);

	/**
	 * Método que debe indicar si el trámite actual viene derivado desde un
	 * trámite de posesión.
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_VIENE_DE_TRAMITE_POSESION)
	public Boolean vieneDeTramitePosesion(Long prcId);
	

	/**
	 * Método que calcula si nos encontramos a menos de dos meses de la fecha
	 * que se haya indicado en la tarea ...
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_ESTAMOS_A_DOS_MESES)
	public Boolean estamosADosMeses(Long prcId);
	

	/**
	 * Método que comprueba que las cargas tengan fecha revisión rellenada
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_FECHA_REVISION)
	public Boolean comprobarFechaRevision(Long prcId);


	/**
	 * Método que comprueba si alguna de las cargas es adjudicada a entidad
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_EXISTE_BIEN_CON_ADJU_ENTIDAD)
	public Boolean existeBienConAdjudicacionE(Long prcId);

	/**
	 * Método que comprueba si el bien tiene cesión de remate
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_ES_BIEN_CON_CESION_REMATE)
	public Boolean esBienConCesionRemate(Long bieId);
	
	/**
	 * Metodo que comprueba si un bien esta sujeto a IVA/IGIC
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_BIEN_SUJETO_IVA)
	public String comprobarBienSujetoIVA(Long prcId);
	
	/**
	 * Metodo que comprueba si un bien es adjudicable con decreto
	 * @param bienId
	 * @return
	 */
	@BusinessOperationDefinition(BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJUDICATARIA_DECRETO)
	Boolean comprobarBienEntidadAdjudicatariaConDecreto(Long bienId);

}