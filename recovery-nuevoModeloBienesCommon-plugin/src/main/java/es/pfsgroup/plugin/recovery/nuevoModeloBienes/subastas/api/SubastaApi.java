package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api;

import java.util.List;
import java.util.Map;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.InformeValidacionCDDDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.AcuerdoCierreDeudaDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarLotesSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoValidacionCDD;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoValidacionNuse;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.DatosActaComiteBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.InformeSubastaLetradoBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.BienSubastaDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.EditarInformacionCierreDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.GuardarInstruccionesDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager.SubastaManager.ValorNodoTarea;

public interface SubastaApi {
	
	public static final String ACCION_EXCLUIR_BIEN = "EXCLUIR"; 
	public static final String ACCION_AGREGAR_BIEN = "AGREGAR";
	public static final String BO_NMB_SUBASTA_GET_FECHA_TASACION = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getCheckFechaTasacionSubasta";
	public static final String BO_NMB_SUBASTA_GET_CHECK_INF_LETRADO = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getCheckInfLetrado";
	public static final String BO_NMB_SUBASTA_GET_CHECK_INS_SUBASTA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getCheckInsSubasta";
	public static final String BO_NMB_SUBASTA_GET_CHECK_VALIDA_INS = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getCheckValidaIns";
	public static final String BO_NMB_SUBASTA_GET_FLAGS_SUBASTA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getFlagsSubasta";
	public static final String BO_NMB_SUBASTA_GET_BIENES_SUBASTA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getBienes";
	public static final String BO_NMB_SUBASTA_GET_BIENES_LOTE_SUBASTA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getBienesLoteSubasta";
	public static final String BO_NMB_SUBASTA_GET_DATOS_ACTA_COMITE = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getDatosActaComite";
	public static final String BO_NMB_SUBASTA_GET_SUBASTA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getSubasta";
	public static final String BO_NMB_SUBASTA_GUARDA_ACUERDO_CIERRE_DEUDA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.guardaBatchAcuerdoCierreDeuda";
	public static final String BO_NMB_SUBASTA_GUARDA_ACUERDO_CIERRE = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.guardaBatchAcuerdoCierre";
	public static final String BO_NMB_SUBASTA_INFORME_SUBASTA_LETRADO ="es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getInformeSubastasLetrado";
	public static final String CODIGO_TIPO_PROCEDIMIENTO_SUBASTA_BANKIA = "P401";
	public static final String CODIGO_TIPO_PROCEDIMIENTO_SUBASTA_SAREB = "P409";
	public static final String BO_NMB_SUBASTA_BUSCAR_LOTES_SUBASTA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarLoteSubasta";
	public static final String BO_NMB_SUBASTA_BUSCAR_LOTES_SUBASTA_EXCEL = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarLoteSubastaXLS";
	public static final String BO_NMB_SUBASTA_PASAR_LOTES_TRAS_PROPUESTO = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.marcarLotesEstadoTrasPropuesta";
	public static final String BO_NMB_SUBASTA_PASAR_LOTES_TRAS_VALIDAR = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.marcarLotesEstadoTrasValidar";
	public static final String BO_NMB_SUBASTA_PERMITE_SOLICITAR_TASACION = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.permiteSolicitarTasacion";
	public static final String BO_NMB_SUBASTA_EXPORTAR_BUSCADOR_SUBASTAS_EXCEL_COUNT = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarSubastasXLSCount";
	public static final String BO_NMB_SUBASTA_OBTENER_TAREAS_CIERRE_DEUDA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.obtenerTareasCierreDeuda";
	public static final String BO_NMB_SUBASTA_ACTUALIZAR_INFORMACION_CIERRE_DEUDA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.actualizarInformacionCierreDeuda";
	public static final String BO_NMB_SUBASTA_OBTENER_VALOR_NODO_PRC = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.obtenValorNodoPrc";
	public static final String BO_NMB_SUBASTA_TAREA_EXISTE_Y_FINALIZADA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.tareaExisteYFinalizada";
	public static final String BO_NMB_SUBASTA_EXISTE_REGISTRO_CIERRE_DEUDA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.existeRegistroCierreDeuda";
	public static final String BO_NMB_SUBASTA_FIND_REGISTRO_CIERRE_DEUDA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.findRegistroCierreDeuda";
	public static final String BO_NMB_SUBASTA_RELLENAR_INFORME_CDD = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.rellenarInformeValidacionCDD";	
	public static final String BO_NMB_SUBASTA_OBTEN_PROCEDIMIENTO_BIEN_DERIVADO = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.getProcedimientoBienByIdPadre";
	public static final String BO_NMB_SUBASTA_TAREA_EXISTE = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.tareaExiste";
	public static final String BO_NMB_SUBASTA_ELIMINAR_BATCH_ACUERDO_CIERRE_DEUDA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.eliminarBatchCierreDeudaAsunto";
	public static final String BO_NMB_SUBASTA_PARAMETRIZAR_LIMITE = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.parametrizarLimite";
	public static final String BO_NMB_GET_LIST_ERROR_PREVI_CDD_DATA = "plugin.nuevoModeloBienes.subastas.manager.SubastasManager.getListErrorPreviCDDData";
	public static final String BO_NMB_GET_LIST_ERROR_POST_CDD_DATA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.getListErrorPostCDDData";
	public static final String BO_NMB_SUBASTA_GENERAR_ENVIO_CIERRE_DEUDA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.generarEnvioCierreDeuda";
	public static final String BO_NMB_SUBASTA_OBTENER_CONTRATO = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.getContratoByNroContrato";
	public static final String BO_NMB_SUBASTA_OBTENER_RELACION_BIENES_CONTRATOS = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.getRelacionesContratosBienes";
	public static final String BO_OBTENER_SITUACION_CARGA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.getSituacionCarga";
	public static final String BO_OBTENER_SITUACION_CARGA_ECONOMICA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.getSituacionCargaEconomica";
	public static final String BO_OBTENER_TIPO_CARGA = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.getTipoCarga";
	public static final String BO_SUBIR_PLANTILLA_INSTRUCCIONES = "plugin.nuevoModeloBienes.subastas.manager.SubastaManager.upload";
	
	
	
	
	/**
	 * Obtiene las subastas de un asunto
	 * @param idAsunto
	 * @return
	 */
	List<Subasta> getSubastasAsunto(Long idAsunto);
	
	/**
	 * Obtiene los lotes de una subasta
	 * @param idSubasta
	 * @return
	 */
	List<LoteSubasta> getLotesSubasta(Long idSubasta);
	
	/**
	 * Obtiene los bienes de una subasta y el lote al que pertencen.<br>
	 * Dependiendo de la accion devolverá unos bienes u otros:
	 * <p> - "AGREGAR": Devolverá los bienes del procedimiento que no estén incluidos en la subasta.</p>
	 * <p> - "EXCLUIR": Devolverá los bienes que están incluidos en la subasta</p>  
	 * @param idSubasta
	 * @param accion
	 * @return
	 */
	List<BienSubastaDTO> getBienesAgregarExcluir(Long idSubasta, String accion);

	/**
	 * Añade la relación del bien con el lote de la subasta elegida
	 * @param idSubasta
	 * @param arrBien
	 * @param arrLotes
	 */
	void agregarBienes(Long idSubasta, String[] arrBien, String[] arrLotes);

	/**
	 * Elimina la relación del bien y la subasta
	 * @param idSubasta
	 * @param arrBien
	 */
	void excluirBienes(Long idSubasta, String[] arrBien);
	
	/**
	 * Devuelve el lote
	 * @param idLote
	 * @return
	 */
	LoteSubasta getLoteSubasta(Long idLote);
	
	/**
	 * Guarda las instrucciones de un lote de la subasta
	 */
	void guardaInstruccionesLoteSubasta(GuardarInstruccionesDto dto);
	
	/**
	 * Obtiene los datos de la vista para generar el informe de subastas letrado
	 * @param idSubasta
	 * @return
	 */
	@BusinessOperationDefinition(BO_NMB_SUBASTA_INFORME_SUBASTA_LETRADO)
	InformeSubastaLetradoBean getInformeSubastasLetrado(Long idSubasta);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GET_FECHA_TASACION)
	Boolean getCheckFechaTasacionSubasta(Long idSubasta);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GET_CHECK_INF_LETRADO)
	Boolean getCheckInfLetrado(Long idSubasta);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GET_CHECK_INS_SUBASTA)
	Boolean getCheckInsSubasta(Long idSubasta);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GET_CHECK_VALIDA_INS)
	Boolean getCheckValidaIns(Long idSubasta);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GET_BIENES_SUBASTA)
	List<Bien> getBienesSubasta(Long idSubasta);	
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GET_BIENES_LOTE_SUBASTA)
	List<Bien> getBienesLoteSubasta(Long idLote);	
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GET_DATOS_ACTA_COMITE)
	List<DatosActaComiteBean> getDatosActaComite(NMBDtoBuscarLotesSubastas dto);	
	
    @BusinessOperationDefinition("SubastaManager.getTabs")
    public List<DynamicElement> getTabs(long idSubasta);
    
    @BusinessOperationDefinition("SubastaManager.getButtons")
	public List<DynamicElement> getButtons(long idSubasta);
	
	@BusinessOperationDefinition("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarSubastas")	
	public Page buscarSubastas(NMBDtoBuscarSubastas dto);	
	
	@BusinessOperationDefinition("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarSubastasXLS")
	public FileItem buscarSubastasXLS(NMBDtoBuscarSubastas dto);
	//public ModelMap buscarSubastasXLS(NMBDtoBuscarSubastas dto);
	//public List<Subasta> buscarSubastasXLS(NMBDtoBuscarSubastas dto);
	
	@BusinessOperationDefinition("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarTareasSubastaBankia")
	public List<TareaProcedimiento> buscarTareasSubastaBankia();

	@BusinessOperationDefinition("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarTareasSubastaSareb")
	public List<TareaProcedimiento> buscarTareasSubastaSareb();
	
	@BusinessOperationDefinition("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarBienesDeUnaSubasta")
	public List<NMBBien> getBienesDeUnaSubasta(Subasta subasta);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GET_SUBASTA)
	public Subasta getSubasta(Long idSubasta);

	@BusinessOperationDefinition(BO_NMB_SUBASTA_GUARDA_ACUERDO_CIERRE_DEUDA)
	public void guardaBatchAcuerdoCierreDeuda(BatchAcuerdoCierreDeuda autoCierreDeuda);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GUARDA_ACUERDO_CIERRE)
	public void guardaBatchAcuerdoCierre(Long asuId, Long prcId, Long bienId, Long resultadoValidacion, DDResultadoValidacionCDD motivoValidacion, String origen);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_BUSCAR_LOTES_SUBASTA)	
	public Page buscarLotesSubastas(NMBDtoBuscarLotesSubastas dto);	
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_BUSCAR_LOTES_SUBASTA_EXCEL)
	public FileItem buscarLotesSubastasXLS(NMBDtoBuscarLotesSubastas dto);

	@BusinessOperationDefinition(BO_NMB_SUBASTA_PASAR_LOTES_TRAS_PROPUESTO)
	public void marcarLotesEstadoTrasPropuesta(Subasta subasta);

	@BusinessOperationDefinition(BO_NMB_SUBASTA_PASAR_LOTES_TRAS_VALIDAR)
	public void marcarLotesEstadoTrasValidar(Subasta subasta, TareaExterna tarea, String decision);

	@BusinessOperationDefinition(BO_NMB_SUBASTA_PERMITE_SOLICITAR_TASACION)
	public Integer permiteSolicitarTasacion(Long id);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_EXPORTAR_BUSCADOR_SUBASTAS_EXCEL_COUNT)
	public Integer buscarSubastasXLSCount(NMBDtoBuscarSubastas dto);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_OBTENER_TAREAS_CIERRE_DEUDA)
	public Map<String, String> obtenerTareasCierreDeuda();
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_ACTUALIZAR_INFORMACION_CIERRE_DEUDA)
	public void actualizarInformacionCierreDeuda(EditarInformacionCierreDto dto);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_OBTENER_VALOR_NODO_PRC)
	ValorNodoTarea obtenValorNodoPrc(Procedimiento procedimiento, String nombreNodo, String valor);

	@BusinessOperationDefinition(BO_NMB_SUBASTA_TAREA_EXISTE_Y_FINALIZADA)
	boolean tareaExisteYFinalizada(Procedimiento procedimiento, String nombreNodo);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_EXISTE_REGISTRO_CIERRE_DEUDA)
	List<BatchAcuerdoCierreDeuda> findRegistroCierreDeuda(Long idSubasta, Long idBien);
	
	@BusinessOperation(BO_NMB_SUBASTA_FIND_REGISTRO_CIERRE_DEUDA)
	BatchAcuerdoCierreDeuda findRegistroCierreDeuda(AcuerdoCierreDeudaDto acuerdo);
		
	@BusinessOperationDefinition(BO_NMB_SUBASTA_OBTEN_PROCEDIMIENTO_BIEN_DERIVADO)
	Procedimiento getProcedimientoBienByIdPadre(NMBBien nmbBien, Subasta subasta, String tipoProcedimiento);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_TAREA_EXISTE)
	HistoricoProcedimiento tareaExiste(Procedimiento procedimiento, String nombreNodo);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_ELIMINAR_BATCH_ACUERDO_CIERRE_DEUDA)
	void eliminarBatchCierreDeudaAsunto(Long idAsunto);

	@BusinessOperationDefinition(BO_NMB_SUBASTA_PARAMETRIZAR_LIMITE)
	Parametrizacion parametrizarLimite(String nombreParametro);

	@BusinessOperationDefinition(BO_NMB_GET_LIST_ERROR_PREVI_CDD_DATA)
	List<DDResultadoValidacionCDD> getListErrorPreviCDDData();
	
	@BusinessOperationDefinition(BO_NMB_GET_LIST_ERROR_POST_CDD_DATA)
	List<DDResultadoValidacionNuse> getListErrorPostCDDData();
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_GENERAR_ENVIO_CIERRE_DEUDA)
	InformeValidacionCDDDto generarEnvioCierreDeuda(Subasta subasta, Long idBien, String origen);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_OBTENER_CONTRATO)
	Contrato getContratoByNroContrato(String nroContrato);
	
	@BusinessOperationDefinition(BO_NMB_SUBASTA_OBTENER_RELACION_BIENES_CONTRATOS)
	List<NMBContratoBien> getRelacionesContratosBienes(Long[] idBienes);
	
	@BusinessOperationDefinition(BO_OBTENER_SITUACION_CARGA)
	DDSituacionCarga getSituacionCarga(String codigo);
	
	@BusinessOperationDefinition(BO_OBTENER_SITUACION_CARGA_ECONOMICA)
	DDSituacionCarga getSituacionCargaEconomica(String codigo);
	
	@BusinessOperationDefinition(BO_OBTENER_TIPO_CARGA)
	DDTipoCarga getTipoCarga(String tipoCarga);
	
	@BusinessOperationDefinition(BO_SUBIR_PLANTILLA_INSTRUCCIONES)
	String upload(WebFileItem uploadForm);

	boolean comprobarLimiteXLS(NMBDtoBuscarSubastas b);
}
