package es.pfsgroup.recovery.recobroConfig.procesosFacturacion.controller.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.HtmlUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.facturacion.manager.api.RecobroModeloFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dto.RecobroProcesosFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api.RecobroProcesosFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroDDEstadoProcesoFacturable;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacion;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.serder.EditModelosFacturacionSubcarterasItem;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonProcesosFacturacionConstants;
import es.pfsgroup.recovery.recobroConfig.procesosFacturacion.controller.api.RecobroProcesosFacturacionControllerApi;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroProcesosFacturacionConstants;

/**
 * Clase creada para la controlar la parte web del modelo de facturación
 * @author Carlos
 *
 */
@Controller
public class RecobroProcesosFacturacionController implements RecobroProcesosFacturacionControllerApi {
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String openLauncher(ModelMap map) {
		return RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_LAUNCHER;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String abrirCalculo(ModelMap map) {
		String ultimoPeriodo =proxyFactory.proxy(RecobroProcesosFacturacionApi.class).buscaUltimoPeriodoFacturado();
		map.put("ESTADO_CANCELADO", RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_CANCELADO);
		map.put("ESTADO_LIBERADO", RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_LIBERADO);
		map.put("ESTADO_PROCESADO", RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PROCESADO);
		map.put("ESTADO_PENDIENTE", RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE);
		map.put("ESTADO_ERRORES", RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_CON_ERRORES);
		
		map.put("ultimoPeriodo", ultimoPeriodo);
		
		return RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_CALCULO;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String abrirRemesas(ModelMap map) {
		List<RecobroDDEstadoProcesoFacturable> recobroDDEstadoProceso =  proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDEstadoProcesoFacturable.class);
		map.put("ddEstadosProceso", recobroDDEstadoProceso);
		map.put("ESTADO_CANCELADO", RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_CANCELADO);
		map.put("ESTADO_LIBERADO", RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_LIBERADO);
		map.put("ESTADO_PROCESADO", RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PROCESADO);
		map.put("ESTADO_PENDIENTE", RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE);
		
		return RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_REMESAS;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String buscaProcesosFacturacion(RecobroProcesosFacturacionDto dto,
			ModelMap map) {
		Page procesosFacturacion = proxyFactory.proxy(RecobroProcesosFacturacionApi.class).buscarProcesos(dto);
		map.put("procesosFacturacion", procesosFacturacion);
		return RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_LISTA_PROCESOSFACTURACION_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String descargarFichero(Long idProcesoFacturacion, ModelMap map) {
		FileItem excelFileItem = proxyFactory.proxy(RecobroProcesosFacturacionApi.class).generarExcelProcesosFacturacion(idProcesoFacturacion);
		
		map.put("fileItem", excelFileItem);
		
		return RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_JSP_DOWNLOAD_FILE;
	}
	
	/**
	 * @{inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String cancelarProcesoFacturacion(@RequestParam(value = "idProcesoFacturacion", required = true) Long idProcesoFacturacion, ModelMap map) {
		proxyFactory.proxy(RecobroProcesosFacturacionApi.class).cancelarProcesoFacturacion(idProcesoFacturacion);
		return RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String listaSubcarterasProcesoFacturacion(@RequestParam(value = "idProcesoFacturacion", required = true) Long idProcesoFacturacion, ModelMap map) {
		RecobroProcesoFacturacion proceso = proxyFactory.proxy(RecobroProcesosFacturacionApi.class).getProcesoFacturacion(idProcesoFacturacion);
		if (!Checks.esNulo(proceso)){
			List<RecobroProcesoFacturacionSubcartera> subcarteras= proceso.getProcesoSubcarteras();
			map.put("subcarteras", subcarteras);
		}
		
		
		return RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERASFACTURACION_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String altaProdesoFacturacion(ModelMap map) {
		
		return RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_ALTA_PROCESOFACTURACION;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String saveProcesoFacturacion(RecobroProcesosFacturacionDto dto,
			ModelMap map) {
		proxyFactory.proxy(RecobroProcesosFacturacionApi.class).saveProcesoFacturacion(dto);
		
		return RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT ;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String liberarProcesoFacturacion(Long idProcesoFacturacion,
			ModelMap map) {
		
		proxyFactory.proxy(RecobroProcesosFacturacionApi.class).cambiaEstadoProcesoFacturacion(idProcesoFacturacion, RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_LIBERADO);
		
		return RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT ;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String borrarDetalleFacturacion(Long idDetalleFacturacion,
			ModelMap map) {
		proxyFactory.proxy(RecobroProcesosFacturacionApi.class).borrarDetalleFacturacion(idDetalleFacturacion);
		return RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT ;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String corregirModelosFacturacion(Long idProcesoFacturacion,
			ModelMap map) {
		List<RecobroModeloFacturacion> modelos = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getListModelosFacturacion();
		
		map.put("modelos", modelos);
		map.put("idProcesoFacturacion", idProcesoFacturacion);
		
		return RecobroProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_MODIFICARMODELOS ;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String saveModelosFacturacionSubcarteras(String subcarteras,
			ModelMap map) {
		
		if (!Checks.esNulo(subcarteras)){
			ObjectMapper mapper = new ObjectMapper();
			EditModelosFacturacionSubcarterasItem gridItems=null;
			try {
				String htmlSubcarteras = HtmlUtils.htmlUnescape(subcarteras);
				gridItems = mapper.readValue(htmlSubcarteras, EditModelosFacturacionSubcarterasItem.class);
				
			} catch (Exception e) {
				logger.error(e);				
				return null;
			}
			
			if (!Checks.esNulo(gridItems)){
				proxyFactory.proxy(RecobroProcesosFacturacionApi.class).guardarModelosFacturacionSubcarteras(gridItems);
			}
		}
		
		return RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT ;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String marcarPendienteProcesoFacturacion(Long idProcesoFacturacion,
			ModelMap map) {
		proxyFactory.proxy(RecobroProcesosFacturacionApi.class).cambiaEstadoProcesoFacturacion(idProcesoFacturacion, RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE);
		
		return RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT ;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	@Secured("ROLE_VER_PROC_FACTURACION")
	public String descargarFicheroReducido(Long idProcesoFacturacion, ModelMap map) {
		FileItem excelFileItem = proxyFactory.proxy(RecobroProcesosFacturacionApi.class).generarExcelProcesosFacturacionReducido(idProcesoFacturacion);
		
		map.put("fileItem", excelFileItem);
		
		return RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_JSP_DOWNLOAD_FILE;
	}	

}
