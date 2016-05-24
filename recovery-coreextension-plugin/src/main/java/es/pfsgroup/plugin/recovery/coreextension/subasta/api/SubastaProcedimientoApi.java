package es.pfsgroup.plugin.recovery.coreextension.subasta.api;

import java.util.List;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public interface SubastaProcedimientoApi {

	public static final String BO_SUBASTA_CAMBIA_ESTADO_SUBASTA = "es.pfsgroup.recovery.subasta.cambiaEstadoSubasta";
	public static final String BO_SUBASTA_COMPROBAR_MINIMO_BIEN_LOTE = "es.pfsgroup.recovery.subasta.comprobarMinimoBienLote";
	public static final String BO_SUBASTA_COSTAS_LETRADO_SUPERIOR_PRINCIPAL = "es.pfsgroup.recovery.subasta.costasLetraduSuperiorPrincipal";
	public static final String BO_SUBASTA_COMPROBAR_ADJUNTO_INFORME_SUBASTA = "es.pfsgroup.recovery.subasta.comprobarAdjuntoInformeSubasta";
	public static final String BO_SUBASTA_COMPROBAR_INFORMACION_COMPLETA_INSTRUCCIONES = "es.pfsgroup.recovery.subasta.comprobarInformacionCompletaInstrucciones";
	public static final String BO_SUBASTA_COMPROBAR_LOTES_CONTIENEN_INSTRUCCIONES = "es.pfsgroup.recovery.subasta.comprobarLotesContienenInstrucciones";
	public static final String BO_SUBASTA_COMPROBAR_CADUCIDAD_BIENES_LOTE = "es.pfsgroup.recovery.subasta.comprobarCaducidadBienesLote";
	public static final String BO_SUBASTA_COMPROBAR_ADJUNTO_ACTA_SUBASTA = "es.pfsgroup.recovery.subasta.comprobarActaSubasta";
	public static final String BO_SUBASTA_COMPROBAR_INFO_BIEN = "es.pfsgroup.recovery.subasta.comprobarInfoBien";
	public static final String BO_SUBASTA_OBTENER_SUB_BY_PRC_ID = "es.pfsgroup.recovery.subasta.obtenerSubastaByPrcId";
	public static final String BO_SUBASTA_OBTENER_VALORES_TAREA_BY_TEX_ID = "es.pfsgroup.recovery.subasta.obtenerValoresTareaByTexId";
	public static final String BO_SUBASTA_IS_DEMANDADO_PER_JURIDICA= "es.pfsgroup.recovery.subasta.isDemandadoPerJuridica";
	public static final String BO_SUBASTA_OBTENER_PROPIEDAD_ASUNTO= "es.pfsgroup.recovery.subasta.obtenerPropiedadAsunto";
	public static final String BO_SUBASTA_BPM_GET_VALORES_RAMAS_CELEBRACION = "es.pfsgroup.recovery.subasta.bpmGetValoresRamasCelebracion";
	public static final String BO_SUBASTA_BPM_DAME_TIPO_SUBASTA = "es.pfsgroup.recovery.subasta.bpmDameTipoSubasta";
	public static final String BO_SUBASTA_BPM_PREPARAR_DECIDIR_PROPUESTA_SUBASTA = "es.pfsgroup.recovery.subasta.bpmDecidirPropuestaSubasta";
	public static final String BO_SUBASTA_COMPROBAR_PROV_LOC_FIN_BIEN = "es.pfsgroup.recovery.subasta.comprobarProvLocFinBien";
	public static final String BO_SUBASTA_COMPROBAR_COSTAS_LETRADO_VIVIENDA_HABITUAL = "es.pfsgroup.recovery.subasta.comprobarCostasLetradoViviendaHabitual";
	public static final String BO_SUBASTA_NO_VIVIENDA_HABITUAL_TERCEROS = "es.pfsgroup.recovery.subasta.isNotViviendaHabitualAdjTerceros";
	
	@BusinessOperationDefinition(BO_SUBASTA_CAMBIA_ESTADO_SUBASTA)
	public void cambiaEstadoSubasta(Long subId, String estado);

	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_MINIMO_BIEN_LOTE)
	public boolean comprobarMinimoBienLote(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_COSTAS_LETRADO_SUPERIOR_PRINCIPAL)
	public boolean comprobarCostasLetradoSuperiorPrincipal(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_ADJUNTO_INFORME_SUBASTA)
	public boolean comprobarAdjuntoInformeSubasta(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_INFORMACION_COMPLETA_INSTRUCCIONES)
	public boolean comprobarInformacionCompletaInstrucciones(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_LOTES_CONTIENEN_INSTRUCCIONES)
	public boolean comprobarLotesContienenInstrucciones(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_CADUCIDAD_BIENES_LOTE)
	public boolean comprobarCaducidadBienesLote(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_ADJUNTO_ACTA_SUBASTA)
	public boolean comprobarAdjuntoActaSubasta(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_INFO_BIEN)
	public boolean comprobarInfoBien(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_OBTENER_SUB_BY_PRC_ID)
	public Subasta obtenerSubastaByPrcId(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_OBTENER_VALORES_TAREA_BY_TEX_ID)
	public List<EXTTareaExternaValor> obtenerValoresTareaByTexId(Long texId);
	
	@BusinessOperationDefinition(BO_SUBASTA_IS_DEMANDADO_PER_JURIDICA)
	public boolean comprobarIsDemandadoPerJuridica(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_OBTENER_PROPIEDAD_ASUNTO)
	public String obtenerPropiedadAsunto(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_BPM_GET_VALORES_RAMAS_CELEBRACION)
	public Boolean[] bpmGetValoresRamasCelebracion(Procedimiento prc, TareaExterna tex);

	@BusinessOperationDefinition(BO_SUBASTA_BPM_DAME_TIPO_SUBASTA)
	public String dameTipoSubasta(Long prcId);

	@BusinessOperationDefinition(BO_SUBASTA_BPM_PREPARAR_DECIDIR_PROPUESTA_SUBASTA)
	public String decidirPrepararPropuestaSubasta(Long prcId);
	
	@BusinessOperationDefinition(BO_SUBASTA_COMPROBAR_PROV_LOC_FIN_BIEN)
	public boolean comprobarProvLocFinBien(Long prcId);
	
	@BusinessOperation(BO_SUBASTA_COMPROBAR_COSTAS_LETRADO_VIVIENDA_HABITUAL)
	public boolean comprobarCostasLetradoViviendaHabitual(Long prcId, Long texId);
	
	@BusinessOperationDefinition(BO_SUBASTA_NO_VIVIENDA_HABITUAL_TERCEROS)
	public boolean isNotViviendaHabitualAdjTerceros(Long prcId);
	
	public void determinarTipoSubasta(Subasta sub);
}
