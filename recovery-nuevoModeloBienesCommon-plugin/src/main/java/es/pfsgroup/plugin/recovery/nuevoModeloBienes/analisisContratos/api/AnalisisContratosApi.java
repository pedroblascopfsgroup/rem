package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto.AnalisisContratosBienesDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto.AnalisisContratosDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model.AnalisisContratos;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model.NMBAnalisisContratosBien;

public interface AnalisisContratosApi {

	public static final String BO_NMB_ANALISIS_CONTRATOS_GET_CONTRATO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.getAnalisisContratos";
	public static final String BO_NMB_ANALISIS_CONTRATOS_GET_BIEN = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.getAnalisisContratosBien";
	public static final String BO_NMB_ANALISIS_CONTRATOS_LISTADO_DTO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.getListadoAnalisisContratosPaginado";
	public static final String BO_NMB_ANALISIS_CONTRATOS_LISTADO_POR_PROCEDIMIENTO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.getListadoAnalisisContratosPorProcedimiento";
	public static final String BO_NMB_ANALISIS_CONTRATOS_LISTADO_POR_ASUNTO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.getListadoAnalisisContratosPorAsunto";
	public static final String BO_NMB_ANALISIS_CONTRATOS_GUARDAR_AC = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.guardarAnalisisContratos";
	public static final String BO_NMB_ANALISIS_CONTRATOS_GUARDAR_AC_BIEN = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.guardarAnalisisContratosBien";
    public static final String BO_NMB_ANALISIS_CONTRATOS_LISTADO_BIENES = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.getBienes";
    public static final String BO_NMB_ANALISIS_CONTRATOS_GUARDAR_AC_DTO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.guardarAnalisisContratosDto";
    public static final String BO_NMB_ANALISIS_CONTRATOS_BIENES_GUARDAR_AC = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.guardarAnalisisContratosBienes";
	
    public static final String BO_NMB_ANALISIS_CONTRATOS_BPM_ABC = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.bpmGetValoresRamas";
    public static final String BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_A ="es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.bpmDameContratosConIniciarEjecucionA";
    public static final String BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_B ="es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.bpmDameContratosConIniciarEjecucionB";
    public static final String BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_C1 ="es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.bpmDameContratosConIniciarEjecucionC1";
    public static final String BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_C2 ="es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.bpmDameContratosConIniciarEjecucionC2";
    		
    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_GET_CONTRATO)
    AnalisisContratos getAnalisisContrato(Long id);

    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_GET_BIEN)
    NMBAnalisisContratosBien getAnalisisContratoBien(Long id);
    
    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_LISTADO_DTO)
    List<AnalisisContratos> getListadoAnalisisContratos(Long idAsunto);

	@BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_LISTADO_POR_PROCEDIMIENTO)
	List<AnalisisContratos> getListadoAnalisisContratosPorProcedimiento(Long idAsunto);

	@BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_LISTADO_POR_ASUNTO)
	List<AnalisisContratos> getListadoAnalisisContratosPorAsunto(Long idAsunto);
    
	@BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_LISTADO_BIENES)
	List<NMBAnalisisContratosBien> getBienesContratos(Long cntId);

    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_GUARDAR_AC)
    void guardar(AnalisisContratos analisisContratos);

    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_GUARDAR_AC_BIEN)
    void guardar(NMBAnalisisContratosBien analisisContratosBien);

    ////// FUNCIONES PARA BPM //////////////
    
    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_BPM_ABC)
	Boolean[] bpmGetValoresRamas(Long idAsunto);
    
    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_A)
    List<Long> bpmDameContratosConIniciarEjecucionA(Long idProcedimiento);

    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_A)
    List<Long> bpmDameContratosConIniciarEjecucionB(Long idProcedimiento);

    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_A)
    List<Long> bpmDameContratosConIniciarEjecucionC1(Long idProcedimiento);

    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_A)
    List<Long> bpmDameContratosConIniciarEjecucionC2(Long idProcedimiento);

    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_GUARDAR_AC_DTO)
    void guardarAnalisisContratos(AnalisisContratosDto dto);
    
    @BusinessOperationDefinition(BO_NMB_ANALISIS_CONTRATOS_BIENES_GUARDAR_AC)
    void guardarAnalisisContratosBienes(AnalisisContratosBienesDto dto);
}
