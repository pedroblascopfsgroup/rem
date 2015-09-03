package es.pfsgroup.plugin.precontencioso.expedienteJudicial.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;
import es.capgemini.pfs.core.api.plazaJuzgado.PlazaJuzgadoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDResultadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDResultadoSolicitudPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ActualizarProcedimientoPcoDtoInfo;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.BurofaxGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.DocumentoGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.LiquidacionGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.ProcedimientoPcoGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDTipoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDEstadoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Controller
public class ExpedienteJudicialController {

	private static final String DEFAULT = "default";
	private static final String JSON_HISTORICO_ESTADOS = "plugin/precontencioso/historicoEstados/json/historicoEstadosJSON";
	private static final String JSON_BUSQUEDA_PROCEDIMIENTO = "plugin/precontencioso/busquedas/json/procedimientoPcoJSON";
	private static final String JSP_BUSQUEDA_PROCEDIMIENTO = "plugin/precontencioso/busquedas/buscadorProcedimientosPco";
	private static final String JSP_BUSQUEDA_ELEMENTOS_PRECONTENCIOSO = "plugin/precontencioso/busquedas/buscadorElementosPco";
	private static final String JSON_RESULTADO_FINALIZAR_PREPARACION = "plugin/precontencioso/acciones/json/resultadoFinalizarPreparacionJSON";
	private static final String JSON_TIPO_DESPACHO = "plugin/precontencioso/busquedas/json/tipoDespachoJSON";
	private static final String JSON_TIPO_USUARIO = "plugin/precontencioso/busquedas/json/tipoUsuarioJSON";
	private static final String JSON_ZONAS = "plugin/precontencioso/busquedas/json/listadoZonasJSON";

	@Autowired
	ProcedimientoPcoApi procedimientoPcoApi;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@RequestMapping
	public String finalizarPreparacion(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {
		boolean finalizado = procedimientoPcoApi.finalizarPreparacionExpedienteJudicialPorProcedimientoId(idProcedimiento);
		model.put("finalizado", finalizado);
		return JSON_RESULTADO_FINALIZAR_PREPARACION;
	}

	@RequestMapping
	public String getHistoricoEstadosPorProcedimientoId(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {

		List<HistoricoEstadoProcedimientoDTO> historicoEstados = procedimientoPcoApi.getEstadosPorIdProcedimiento(idProcedimiento);
		model.put("historicoEstados", historicoEstados);

		return JSON_HISTORICO_ESTADOS;
	}

	@RequestMapping
	public String abrirBusquedaProcedimiento(WebRequest request, ModelMap model) {
		model = rellenarFormBusquedaPCO(model);
		model.put("ocultarTipoBusqueda", true);
		return JSP_BUSQUEDA_PROCEDIMIENTO;
	}
	
	@RequestMapping
	public String abrirBusquedaElementosPco(WebRequest request, ModelMap model) {	
		rellenarFormBusquedaPCO(model);
		model.put("ocultarTipoBusqueda", false);
		return JSP_BUSQUEDA_ELEMENTOS_PRECONTENCIOSO;
	}	
	
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


	@RequestMapping
	public String busquedaProcedimientos(FiltroBusquedaProcedimientoPcoDTO dto, ModelMap model) {
		List<ProcedimientoPCO> procedimientosPco = procedimientoPcoApi.busquedaProcedimientosPcoPorFiltro(dto);
		List<ProcedimientoPcoGridDTO> expeditentesGrid = completarDatosBusquedaProcedimientos(procedimientosPco);

		model.put("procedimientosPco", expeditentesGrid);
		model.put("totalCount", expeditentesGrid.size());

		return JSON_BUSQUEDA_PROCEDIMIENTO;
	}

	@RequestMapping
	public String busquedaElementosPco(FiltroBusquedaProcedimientoPcoDTO dto, ModelMap model) {
		List<ProcedimientoPcoGridDTO> expeditentesGrid = null;

		if (FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_DOCUMENTO.equals(dto.getTipoBusqueda())) {

		} else if (FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_LIQUIDACION.equals(dto.getTipoBusqueda())) {

			List<LiquidacionPCO> liquidacionesPco = procedimientoPcoApi.busquedaLiquidacionesPorFiltro(dto);
			//expeditentesGrid = completarDatosBusquedaProcedimientos(procedimientosPco);

		} else if (FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_BUROFAX.equals(dto.getTipoBusqueda())) {

			
		}

		return JSON_BUSQUEDA_PROCEDIMIENTO;
	}

	/**
	 * fill ProcedimientoPcoGridDTO from ProcedimientoPCO
	 * @param procedimientos
	 * @return
	 */
	private List<ProcedimientoPcoGridDTO> completarDatosBusquedaProcedimientos(List<ProcedimientoPCO> procedimientos) {
		List<ProcedimientoPcoGridDTO> out = new ArrayList<ProcedimientoPcoGridDTO>();

		for (ProcedimientoPCO procedimientoPco : procedimientos) {
			ProcedimientoPcoGridDTO procedimientoGrid = new ProcedimientoPcoGridDTO();

			procedimientoGrid.setCodigo(procedimientoPco.getProcedimiento().getId().toString());
			procedimientoGrid.setNombreExpediente(procedimientoPco.getNombreExpJudicial());
			procedimientoGrid.setEstadoExpediente(procedimientoPco.getEstadoActual().getDescripcion());
			//expedienteGrid.setDiasEnGestion();
			procedimientoGrid.setFechaEstado(procedimientoPco.getEstadoActualByHistorico().getFechaInicio());

			if (procedimientoPco.getTipoProcPropuesto() != null) {
				procedimientoGrid.setTipoProcPropuesto(procedimientoPco.getTipoProcPropuesto().getDescripcion());	
			}

			if (procedimientoPco.getTipoPreparacion() != null) {
				procedimientoGrid.setTipoPreparacion(procedimientoPco.getTipoPreparacion().getDescripcion());
			}

			//expedienteGrid.setFechaInicioPreparacion();
			//expedienteGrid.setDiasEnPreparacion();
			//expedienteGrid.setDocumentacionCompleta();
			//expedienteGrid.setTotalLiquidacion();
			//expedienteGrid.setNotificadoClientes();
			//expedienteGrid.setFechaEnvioLetrado();
			//expedienteGrid.setAceptadoLetrado();
			//expedienteGrid.setTodosDocumentos();
			//expedienteGrid.setTodasLiquidaciones();

			out.add(procedimientoGrid);
		}

		return out;
	}

	/**
	 * fill ProcedimientoPcoGridDTO from ProcedimientoPCO
	 * @param procedimientos
	 * @return
	 */
	private List<ProcedimientoPcoGridDTO> completarDatosBusquedaElementos(List<ProcedimientoPCO> procedimientos, String tipoElemento) {
		List<ProcedimientoPcoGridDTO> out = new ArrayList<ProcedimientoPcoGridDTO>();

		for (ProcedimientoPCO procedimientoPco : procedimientos) {
			ProcedimientoPcoGridDTO elementoGrid = new ProcedimientoPcoGridDTO();

			elementoGrid.setCodigo(procedimientoPco.getProcedimiento().getId().toString());
			elementoGrid.setNombreExpediente(procedimientoPco.getNombreExpJudicial());
			elementoGrid.setEstadoExpediente(procedimientoPco.getEstadoActual().getDescripcion());
			elementoGrid.setFechaEstado(procedimientoPco.getEstadoActualByHistorico().getFechaInicio());

			if (procedimientoPco.getTipoProcPropuesto() != null) {
				elementoGrid.setTipoProcPropuesto(procedimientoPco.getTipoProcPropuesto().getDescripcion());	
			}

			if (procedimientoPco.getTipoPreparacion() != null) {
				elementoGrid.setTipoPreparacion(procedimientoPco.getTipoPreparacion().getDescripcion());
			}

			out.add(elementoGrid);
		}

		return out;
	}

	private DocumentoGridDTO completarDatosDocumento(ProcedimientoPCO procedimientos) {
		DocumentoGridDTO documento = new DocumentoGridDTO();
		return documento;
	}

	private LiquidacionGridDTO completarDatosLiquidacion(ProcedimientoPCO procedimientos) {
		LiquidacionGridDTO liquidacion = new LiquidacionGridDTO();
		/*liquidacion.setContrato();
		liquidacion.setFechaRecepcion();
		liquidacion.setFechaConfirmacion();
		liquidacion.setFechaCierre();
		liquidacion.setTotal();*/
		return liquidacion;
	}

	private BurofaxGridDTO completarDatosBurofax(ProcedimientoPCO procedimientos) {
		BurofaxGridDTO burofax = new BurofaxGridDTO();
		return burofax;
	}
	
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
		return "default";
	}
	
	private ActualizarProcedimientoPcoDtoInfo creaDTOParaActualizar(
			final WebRequest request) {
		return DynamicDtoUtils.create(ActualizarProcedimientoPcoDtoInfo.class, request);
	}

}