package es.pfsgroup.plugin.precontencioso.expedienteJudicial.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDResultadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDResultadoSolicitudPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.ProcedimientoPcoGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDTipoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Controller
public class ExpedienteJudicialController {

	private static final String DEFAULT = "default";
	private static final String JSON_HISTORICO_ESTADOS = "plugin/precontencioso/historicoEstados/json/historicoEstadosJSON";
	private static final String JSON_BUSQUEDA_PROCEDIMIENTO = "plugin/precontencioso/busquedas/json/procedimientoPcoJSON";
	private static final String JSP_BUSQUEDA_PROCEDIMIENTO = "plugin/precontencioso/busquedas/buscadorProcedimientosPco";
	private static final String JSP_BUSQUEDA_ELEMENTOS_PRECONTENCIOSO = "plugin/precontencioso/busquedas/buscadorElementosPco";
	private static final String JSON_RESULTADO_FINALIZAR_PREPARACION = "plugin/precontencioso/acciones/json/resultadoFinalizarPreparacionJSON";

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

		// Pestaña burofax
		List<DDResultadoBurofaxPCO> resultadoBurofax = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDResultadoBurofaxPCO.class);

		model.put("resultadoBurofax", resultadoBurofax);
		return model;
	}

	@RequestMapping
	public String busquedaProcedimientos(FiltroBusquedaProcedimientoPcoDTO dto, ModelMap model) {

		List<ProcedimientoPCO> procedimientosPco = procedimientoPcoApi.busquedaProcedimientosPco(dto);
		List<ProcedimientoPcoGridDTO> expeditentesGrid = completarDatosBusquedaProcedimiento(procedimientosPco);

		model.put("procedimientosPco", expeditentesGrid);
		model.put("totalCount", expeditentesGrid.size());

		return JSON_BUSQUEDA_PROCEDIMIENTO;
	}

	private List<ProcedimientoPcoGridDTO> completarDatosBusquedaProcedimiento(List<ProcedimientoPCO> procedimientos) {
		List<ProcedimientoPcoGridDTO> out = new ArrayList<ProcedimientoPcoGridDTO>();

		for (ProcedimientoPCO procedimientoPco : procedimientos) {
			ProcedimientoPcoGridDTO expedienteGrid = new ProcedimientoPcoGridDTO();

			expedienteGrid.setCodigo(procedimientoPco.getProcedimiento().getId().toString());
			expedienteGrid.setNombreExpediente(procedimientoPco.getNombreExpJudicial());
			expedienteGrid.setEstadoExpediente(procedimientoPco.getEstadoActual().getDescripcion());
			//expedienteGrid.setDiasEnGestion();
			//expedienteGrid.setFechaEstado();

			if (procedimientoPco.getTipoProcPropuesto() != null) {
				expedienteGrid.setTipoProcPropuesto(procedimientoPco.getTipoProcPropuesto().getDescripcion());	
			}

			if (procedimientoPco.getTipoPreparacion() != null) {
				expedienteGrid.setTipoPreparacion(procedimientoPco.getTipoPreparacion().getDescripcion());
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

			out.add(expedienteGrid);
		}

		return out;
	}
}