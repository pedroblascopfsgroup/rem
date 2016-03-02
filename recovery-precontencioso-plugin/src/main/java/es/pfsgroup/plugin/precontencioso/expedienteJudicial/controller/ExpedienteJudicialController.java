package es.pfsgroup.plugin.precontencioso.expedienteJudicial.controller;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.dao.TipoProcedimientoDao;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;
import es.capgemini.pfs.core.api.plazaJuzgado.PlazaJuzgadoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDResultadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.api.DocumentoPCOApi;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDResultadoSolicitudPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.GestorTareasApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ActualizarProcedimientoPcoDtoInfo;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.ProcedimientoPcoGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDTipoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarDocumentoApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDEstadoLiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Controller
public class ExpedienteJudicialController {

	protected final Log logger = LogFactory.getLog(getClass());
	
	private static final String DEFAULT = "default";
	private static final String JSON_HISTORICO_ESTADOS = "plugin/precontencioso/historicoEstados/json/historicoEstadosJSON";
	private static final String JSON_BUSQUEDA_PROCEDIMIENTO = "plugin/precontencioso/busquedas/json/procedimientoPcoJSON";
	private static final String JSP_BUSQUEDA_PROCEDIMIENTO = "plugin/precontencioso/busquedas/buscadorProcedimientosPco";
	private static final String JSP_BUSQUEDA_ELEMENTOS_PRECONTENCIOSO = "plugin/precontencioso/busquedas/buscadorElementosPco";
	private static final String JSON_RESULTADO_FINALIZAR_PREPARACION = "plugin/precontencioso/acciones/json/resultadoFinalizarPreparacionJSON";
	private static final String JSON_TIPO_DESPACHO = "plugin/precontencioso/busquedas/json/tipoDespachoJSON";
	private static final String JSON_TIPO_USUARIO = "plugin/precontencioso/busquedas/json/tipoUsuarioJSON";
	private static final String JSON_ZONAS = "plugin/precontencioso/busquedas/json/listadoZonasJSON";
	private static final String LISTA_PROCEDIMIENTOS_JSON = "plugin/precontencioso/acciones/json/tipoProcedimientoJSON";
	private static final String OK_KO_RESPUESTA_JSON = "plugin/coreextension/OkRespuestaJSON";
	private static final String DOCUMENTO_INSTANCIA_REGISTRO = "plugin/precontencioso/generarDocs/documentoInstanciaRegistro";
	private static final String JSON_BIENES_PROCEDIMIENTO = "plugin/precontencioso/generarDocs/bienesProcedimientoJSON";
	private static final String JSON_RESPUESTA_SERVICIO = "plugin/precontencioso/generarDocs/resultadoOKJSON";
	private static final String JSP_DOWNLOAD_FILE = "plugin/geninformes/download";
	
	@Autowired
	ProcedimientoPcoApi procedimientoPcoApi;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GestorTareasApi gestorTareasApi;
	
	@Autowired
	private TipoProcedimientoDao tipoProcedimientoDao;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private GestorDespachoDao gestorDespachoDao;
	
	@Autowired
	private DocumentoPCOApi documentoPCOManager;
	
	@Autowired
	private ProcedimientoApi procedimientoApi; 
	
	@Autowired(required = false)
	private GenerarDocumentoApi generarDocumentoApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String comprobarFinalizacionPosible(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {
		boolean finalizado = procedimientoPcoApi.comprobarFinalizarPreparacionExpedienteJudicialPorProcedimientoId(idProcedimiento);
		model.put("finalizado", finalizado);
		return JSON_RESULTADO_FINALIZAR_PREPARACION;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String finalizarPreparacion(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {
		boolean finalizado = procedimientoPcoApi.finalizarPreparacionExpedienteJudicialPorProcedimientoId(idProcedimiento);
		if (finalizado) {
			proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(idProcedimiento, DDEstadoPreparacionPCO.PREPARADO);
		}
		model.put("finalizado", finalizado);
		return JSON_RESULTADO_FINALIZAR_PREPARACION;
	}

	@RequestMapping
	public String devolverPreparacion(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {
		procedimientoPcoApi.devolverPreparacionPorProcedimientoId(idProcedimiento);
//		proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(idProcedimiento, DDEstadoPreparacionPCO.PREPARACION);
		return DEFAULT;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getHistoricoEstadosPorProcedimientoId(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {

		List<HistoricoEstadoProcedimientoDTO> historicoEstados = procedimientoPcoApi.getEstadosPorIdProcedimiento(idProcedimiento);
		model.put("historicoEstados", historicoEstados);

		return JSON_HISTORICO_ESTADOS;
	}

	@RequestMapping
	public String abrirBusquedaProcedimiento(WebRequest request, ModelMap model) {
		rellenarFormBusquedaPCO(model);
		return JSP_BUSQUEDA_PROCEDIMIENTO;
	}

	@RequestMapping
	public String abrirBusquedaElementosPco(WebRequest request, ModelMap model) {	
		rellenarFormBusquedaPCO(model);
		return JSP_BUSQUEDA_ELEMENTOS_PRECONTENCIOSO;
	}	

	@SuppressWarnings("unchecked")
	private ModelMap rellenarFormBusquedaPCO(ModelMap model) {
		// General - Expediente judicial
		List<TipoProcedimiento> tipoProcedimientoProcpuesto = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(TipoProcedimiento.class);
		List<DDTipoPreparacionPCO> tipoPreparacion = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDTipoPreparacionPCO.class);
		List<DDSiNo> ddsino = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDSiNo.class);

		model.put("tipoProcedimientoProcpuesto", tipoProcedimientoProcpuesto);
		model.put("tipoPreparacion", tipoPreparacion);
		model.put("ddSiNo", ddsino);

		// Pestaña persona y contrato
		List<DDTipoProductoEntidad> tipoProducto = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDTipoProductoEntidad.class); 
		List<DDEstadoPreparacionPCO> estadoPreparacion = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDEstadoPreparacionPCO.class);

		model.put("estadoPreparacion", estadoPreparacion);
		model.put("tipoProducto", tipoProducto);

		// Pestaña documentos
		List<DDTipoFicheroAdjunto> tipoDocumento = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDTipoFicheroAdjunto.class);
		List<DDEstadoDocumentoPCO> estadoDocumento = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDEstadoDocumentoPCO.class);
		List<DDResultadoSolicitudPCO> resultadoSolicitud = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDResultadoSolicitudPCO.class);

		model.put("tipoDocumento", tipoDocumento);
		model.put("estadoDocumento", estadoDocumento);
		model.put("resultadoSolicitud", resultadoSolicitud);

		// Pestaña liquidaciones
		List<DDEstadoLiquidacionPCO> estadoLiquidacion = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDEstadoLiquidacionPCO.class);
		model.put("estadoLiquidacion", estadoLiquidacion);

		// Pestaña burofax
		List<DDResultadoBurofaxPCO> resultadoBurofax = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDResultadoBurofaxPCO.class);
		model.put("resultadoBurofax", resultadoBurofax);

		List<Nivel> ddJerarquia = procedimientoPcoApi.getNiveles();
		model.put("ddJerarquia", ddJerarquia);
		
		List<EXTDDTipoGestor> ddListadoGestores = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(EXTDDTipoGestor.class);
		model.put("ddListadoGestores", ddListadoGestores);
				
		return model;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoDespachoData(ModelMap model, Long idTipoGestor, 
			@RequestParam(value="incluirBorrados", required=false) Boolean incluirBorrados){
		
		List<DespachoExterno> listadoDespachos = proxyFactory.proxy(coreextensionApi.class).getListAllDespachos(idTipoGestor, incluirBorrados);
		
		model.put("listadoDespachos", listadoDespachos);
		return JSON_TIPO_DESPACHO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getZonasPorNivel(ModelMap model, Long idJerarquia){
		List<DDZona> ddZonas = proxyFactory.proxy(EXTAsuntoApi.class).getZonasPorNivel(idJerarquia.intValue());
		model.put("ddZonas", ddZonas);
		return JSON_ZONAS;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListUsuariosData(ModelMap model, Long idTipoDespacho,
			@RequestParam(value="incluirBorrados", required=false) Boolean incluirBorrados){
		
		incluirBorrados = incluirBorrados != null ? incluirBorrados : false;
		
		List<Usuario> listadoUsuarios = proxyFactory.proxy(coreextensionApi.class).getListAllUsuariosData(idTipoDespacho, incluirBorrados);
		model.put("listadoUsuarios", listadoUsuarios);
		
		return JSON_TIPO_USUARIO;
	}


	@SuppressWarnings("unchecked")
	@RequestMapping
	public String busquedaProcedimientos(FiltroBusquedaProcedimientoPcoDTO filter, ModelMap model) {
		List<ProcedimientoPcoGridDTO> procedimientosPcoGrid = procedimientoPcoApi.busquedaProcedimientosPcoPorFiltro(filter);

		model.put("procedimientosPco", procedimientosPcoGrid);

		Integer totalCount = procedimientoPcoApi.countBusquedaProcedimientosPorFiltro(filter);
		model.put("totalCount", totalCount);

		return JSON_BUSQUEDA_PROCEDIMIENTO;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String busquedaElementosPco(FiltroBusquedaProcedimientoPcoDTO filter, ModelMap model) {
		List<ProcedimientoPcoGridDTO> elementosGrid = new ArrayList<ProcedimientoPcoGridDTO>();

		// DOCUMENTO - LIQUIDACION - BUROFAX
		if (FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_DOCUMENTO.equals(filter.getTipoBusqueda())) {
			elementosGrid = procedimientoPcoApi.busquedaSolicitudesDocumentoPorFiltro(filter);
		} else if (FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_LIQUIDACION.equals(filter.getTipoBusqueda())) {
			elementosGrid = procedimientoPcoApi.busquedaLiquidacionesPorFiltro(filter);
		} else if (FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_BUROFAX.equals(filter.getTipoBusqueda())) {
			elementosGrid = procedimientoPcoApi.busquedaBurofaxPorFiltro(filter);
		}

		model.put("procedimientosPco", elementosGrid);

		Integer totalCount = procedimientoPcoApi.countBusquedaElementosPorFiltro(filter);
		model.put("totalCount", totalCount);

		return JSON_BUSQUEDA_PROCEDIMIENTO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editar(@RequestParam(value = "id", required = true) Long id, ModelMap map){
		Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(id);
		map.put("procedimiento", procedimiento);
		
		List<DDTipoReclamacion> tiposReclamacion = proxyFactory.proxy(ProcedimientoApi.class).getTiposReclamacion();
		map.put("tiposReclamacion", tiposReclamacion);
		
		List<TipoPlaza> plazas = proxyFactory.proxy(PlazaJuzgadoApi.class).listaPlazas();
		map.put("plazas",plazas);
		
		ProcedimientoPCODTO pcoDto = proxyFactory.proxy(ProcedimientoPcoApi.class).getPrecontenciosoPorProcedimientoId(id);
		map.put("pcoDto",pcoDto);
		
		return "plugin/precontencioso/tabs/editaCabeceraProcedimientoPco";
		
	}
	
	@RequestMapping
	public String saveDatosPrc(WebRequest request){
		ActualizarProcedimientoPcoDtoInfo dto = creaDTOParaActualizar(request);
		proxyFactory.proxy(ProcedimientoPcoApi.class).actualizaProcedimiento(dto);
		return DEFAULT;
	}
	
	private ActualizarProcedimientoPcoDtoInfo creaDTOParaActualizar(
			final WebRequest request) {
		return DynamicDtoUtils.create(ActualizarProcedimientoPcoDtoInfo.class, request);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String crearTareaEspecial(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {
		
		boolean finalizado = false;
		
		String tipoTarea = "PCO_RegResultadoExped";
		
		finalizado = gestorTareasApi.crearTareaEspecial(idProcedimiento, tipoTarea);
		model.put("finalizado", finalizado);
		
		return JSON_RESULTADO_FINALIZAR_PREPARACION;
		
	}


	@SuppressWarnings("unchecked")
	@RequestMapping
	public String cancelarTareaEspecial(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {
		
		boolean finalizado = false;
		
		String tipoTarea = "PCO_RegResultadoExped";
		
		finalizado = gestorTareasApi.cancelarTareaEspecial(idProcedimiento, tipoTarea);
		model.put("finalizado", finalizado);
		
		return JSON_RESULTADO_FINALIZAR_PREPARACION;
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String recalcularTareasEspeciales(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {
		
		boolean finalizado = true;

		try {
			gestorTareasApi.recalcularTareasPreparacionDocumental(idProcedimiento);
		} catch (Exception e) {
			finalizado=false;
			e.printStackTrace();
		}
		
		model.put("finalizado", finalizado);
		
		return JSON_RESULTADO_FINALIZAR_PREPARACION;
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getTiposProcedimientoAsignacionDeGestores(ModelMap model) {
		
		model.put("data", tipoProcedimientoDao.busquedaProcedimientosAsignacionDeGestores());
		return LISTA_PROCEDIMIENTOS_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getEsTareaPrecontenciosoEspecial(@RequestParam(value = "idTarea", required = true) Long idTarea, ModelMap model) {
		
		model.put("okko", gestorTareasApi.getEsTareaPrecontenciosoEspecial(idTarea));
		
		return OK_KO_RESPUESTA_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String exportarExcel(FiltroBusquedaProcedimientoPcoDTO filter, ModelMap model) 
	{
		filter.setStart(0);
		filter.setLimit(Integer.MAX_VALUE);
		
		List<ProcedimientoPcoGridDTO> procedimientosPcoGrid = procedimientoPcoApi.busquedaProcedimientosPcoPorFiltro(filter);

		
		model.put("expedientes", procedimientosPcoGrid);

		Integer totalCount = procedimientoPcoApi.countBusquedaProcedimientosPorFiltro(filter);
		model.put("totalCount", totalCount);

		return "reportXLS/plugin/precontencioso/expedientes/listaExpedientes";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String exportarExcelElementos(FiltroBusquedaProcedimientoPcoDTO filter, ModelMap model) {
		
		filter.setStart(0);
		filter.setLimit(Integer.MAX_VALUE);
		
		FileItem fExcel = procedimientoPcoApi.generarExcelExportacionElementos(filter);
		model.put("fileItem", fExcel);
		return "plugin/precontencioso/download";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String isExpedienteEditable(Long idProcedimiento, ModelMap map){
	
		boolean res = procedimientoPcoApi.isExpedienteEditable(idProcedimiento);		
		
		map.put("isEditable", res);
		return "plugin/precontencioso/acciones/json/expedienteEditableJSON";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String isGestoria(Long idProcedimiento, ModelMap map){
	
		Usuario userLogged = usuarioManager.getUsuarioLogado(); 
		List<GestorDespacho> listaGestorDespacho = documentoPCOManager.getGestorDespachoByUsuIdAndTipoDespacho(userLogged.getId(), DDTipoDespachoExterno.CODIGO_GESTORIA_PCO);
		
		map.put("esGestoria", !listaGestorDespacho.isEmpty());

		return "plugin/precontencioso/acciones/json/esGestoriaJSON";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String documentoInstanciaRegistro(ModelMap model) {
		return DOCUMENTO_INSTANCIA_REGISTRO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String bienesAsociadosProcedimiento(ModelMap model, @RequestParam(value = "id", required = true) Long idProcedimiento) {
		Procedimiento prc = procedimientoApi.getProcedimiento(idProcedimiento);
		List<ProcedimientoBien> listBienesPco = prc.getBienes();
		model.put("bienesPrc", listBienesPco);
		return JSON_BIENES_PROCEDIMIENTO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String instanciarDocumentoBienes(ModelMap model,
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			@RequestParam(value = "idsBien", required = true) String idsBien) {
		boolean resultadoOK = procedimientoPcoApi.instanciarDocumentoBienes(idProcedimiento, idsBien);
		model.put("resultadoOK", resultadoOK);
		return JSON_RESPUESTA_SERVICIO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarCertSaldo(@RequestParam(value = "idLiquidacion", required = true) Long idLiquidacion, 
			@RequestParam(value = "idPlantilla", required = true) Long idPlantilla, 
			@RequestParam(value = "codigoPropietaria", required = true) String codigoPropietaria,
			@RequestParam(value = "localidadFirma", required = true) String localidadFirma,
			@RequestParam(value = "notario", required = true) String notario,
			ModelMap model) {

		if (generarDocumentoApi == null) {
			logger.error("LiquidacionDocController.generarCertSaldo: No existe una implementacion para generarDocumentoApi");
			throw new BusinessOperationException("Not implemented generarDocumentoApi");
		}

		FileItem instanciaDocumento = generarDocumentoApi.generarCertificadoSaldo(idLiquidacion, idPlantilla, codigoPropietaria, localidadFirma, notario);
		model.put("fileItem", instanciaDocumento);

		return JSP_DOWNLOAD_FILE;

	}
}