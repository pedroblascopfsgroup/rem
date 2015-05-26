package es.pfsgroup.plugin.recovery.coreextension.subasta.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface SubastaProcedimientoDelegateApi {
	
	public static final String BO_SUBASTA_COMPROBAR_OBRA_EN_CURSO = "es.pfsgroup.recovery.subasta.comprobarObraEncurso";
	public static final String BO_SUBASTA_COMPROBAR_BIEN_INFORMADO = "es.pfsgroup.recovery.subasta.comprobarBienInformado";
	public static final String BO_SUBASTA_TIENE_ALGUN_BIEN_CON_FICHA_SUBASTA = "es.pfsgroup.recovery.subasta.tieneAlgunBienConFichaSubasta";
	public static final String BO_SUBASTA_IMPORTE_ENTIDAD_ADJUDICACION_BIENES = "es.pfsgroup.recovery.subasta.importeEntidadAdjudicacionBienes";
	public static final String BO_SUBASTA_DECIDIR_REGISTRAR_ACTA_SUBASTA = "es.pfsgroup.recovery.subasta.decidirRegistrarActaSubasta";
	public static final String BO_SUBASTA_IS_BIEN_WITH_TIPO_SUBASTA= "es.pfsgroup.recovery.subasta.isTipoSubasta";
	public static final String BO_SUBASTA_OBTENER_INSTRUCCIONES_CESION_REMATE= "es.pfsgroup.recovery.subasta.obtenerInstruccionesCesionRemate";
	public static final String BO_SUBASTA_COMPROBAR_TIPO_SUBASTA_INFORMADO = "es.pfsgroup.recovery.subasta.comprobarTipoSubastaInformado";
	public static final String BO_SUBASTA_COMPROBAR_DUE_DILLIGENCE = "es.pfsgroup.recovery.subasta.comprobarDueDilligence";
	public static final String BO_SUBASTA_COMPROBAR_FECHA_RECEPCION_DUE_DILLIGENCE = "es.pfsgroup.recovery.subasta.comprobarFechaRecepcionDue";
	public static final String BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_PRE = "es.pfsgroup.recovery.subasta.validacionesCelebracionSubastaPRE";
	public static final String BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_POST = "es.pfsgroup.recovery.subasta.validacionesCelebracionSubastaPOST";
	public static final String BO_SUBASTA_VALIDACIONES_CONFIRMAR_TESTIMONIO_PRE = "es.pfsgroup.recovery.subasta.validacionesConfirmarTestimonioPRE";
	public static final String BO_SUBASTA_VALIDACIONES_CONFIRMAR_TESTIMONIO_POST = "es.pfsgroup.recovery.subasta.validacionesConfirmarTestimonioPOST";
	public static final String BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_ADJUDICACION = "es.pfsgroup.recovery.subasta.validacionesCelebracionSubastaAdjudicacion";
	public static final String BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_ADJUDICACION_DOC = "es.pfsgroup.recovery.subasta.validacionesCelebracionSubastaAdjudicacionDoc";
	public static final String BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_SAREB_POST = "es.pfsgroup.recovery.subasta.validacionesCelebracionSubastaSarebPOST";
	
	@BusinessOperationDefinition(BO_SUBASTA_IS_BIEN_WITH_TIPO_SUBASTA)
	public Boolean isTipoSubasta(Long bienId);
	
	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_OBRA_EN_CURSO)
	public boolean comprobarObraEnCurso(Long prcId);
	
	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_BIEN_INFORMADO)
	public boolean comprobarBienInformado(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_TIENE_ALGUN_BIEN_CON_FICHA_SUBASTA)
	boolean tieneAlgunBienConFichaSubasta2(Long prcId);
	
	@BusinessOperationDefinition(BO_SUBASTA_IMPORTE_ENTIDAD_ADJUDICACION_BIENES)
	boolean comprobarImporteEntidadAdjudicacionBienes(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_DECIDIR_REGISTRAR_ACTA_SUBASTA)
	public String decidirRegistrarActaSubasta(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_OBTENER_INSTRUCCIONES_CESION_REMATE)
	public String obtenerInstruccionesCesionRemate(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_TIPO_SUBASTA_INFORMADO)
	public boolean comprobarTipoSubastaInformado(Long prcId);
	
	//HAYA
	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_DUE_DILLIGENCE)
	public boolean comprobarDueDilligence(Long prcId);
	
	//HAYA
	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_FECHA_RECEPCION_DUE_DILLIGENCE)
	public boolean comprobarFechaRecepcionDue(Long prcId);
	
	//BANKIA
	@BusinessOperationDefinition(BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_PRE)
	public String validacionesCelebracionSubastaPRE(Long prcId);
	
	//BANKIA
	@BusinessOperationDefinition(BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_POST)
	public String validacionesCelebracionSubastaPOST(Long prcId);
	
	//BANKIA
	@BusinessOperationDefinition(BO_SUBASTA_VALIDACIONES_CONFIRMAR_TESTIMONIO_PRE)
	public String validacionesConfirmarTestimonioPRE(Long prcId);
	
	//BANKIA
	@BusinessOperationDefinition(BO_SUBASTA_VALIDACIONES_CONFIRMAR_TESTIMONIO_POST)
	public String validacionesConfirmarTestimonioPOST(Long prcId);
	
	//HAYA
	@BusinessOperationDefinition(BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_ADJUDICACION)
	boolean comprobarAdjudicacionBienesCelebracionSubasta(Long prcId);
	
	//HAYA
	@BusinessOperationDefinition(BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_ADJUDICACION_DOC)
	boolean comprobarAdjudicacionDocBienesCelebracionSubasta(Long prcId);
	
	//BANKIA
	@BusinessOperationDefinition(BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_SAREB_POST)
	public String validacionesCelebracionSubastaSarebPOST(Long prcId);

}
