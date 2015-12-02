package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.api.CambiosMasivosApi;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.dto.CambioMasivoGestoresPorAsuntosDtoImpl;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dto.PeticionCambioMasivoGestoresDtoImpl;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.model.PeticionCambioMasivoGestoresAsunto;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.recovery.api.UsuarioApi;

@Controller
public class CambiosGestoresController {
	
	public static final String GET_CAMBIOS_GESTORES_ASUNTO_JSON = "plugin/cambiosMasivosAsunto/asunto/cambiosGestoresHistoricoJSON";
	private static final String CAMBIOSGESTORES_HISTORICO_PAGE_KEY = "cambiosGestoresHistorico";
	
	public static final String GET_CAMBIOS_GESTORES_ASUNTO_PENDIENTE_JSON = "plugin/cambiosMasivosAsunto/asunto/cambiosGestoresPendienteJSON";
	private static final String CAMBIOSGESTORES_PENDIENTE_PAGE_KEY = "cambiosGestoresPendiente";
	
	private static final String JSP_VENTANA_CAMBIO_GESTORES_BUSCADOR_ASUNTOS = "plugin/cambiosMasivosAsunto/asunto/ventanaBuscadorAsunto";
	
	public static final String DEFAULT = "default";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@InitBinder
	protected void initBinder(WebDataBinder binder) {
	    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
	    binder.registerCustomEditor(Date.class, new CustomDateEditor(
	            dateFormat, false));
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getCambiosGestoresHistorico(@RequestParam(value = "idAsunto", required = true) Long idAsunto, ModelMap map) {
		map.put("idAsunto", idAsunto);
		List<? extends MEJRegistroInfo> lista = proxyFactory.proxy(CambiosMasivosApi.class).getCambiosGestoresHistoricoPaginados(idAsunto);
		map.put(CAMBIOSGESTORES_HISTORICO_PAGE_KEY, lista);
		return GET_CAMBIOS_GESTORES_ASUNTO_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getCambiosGestoresPendiente(@RequestParam(value = "idAsunto", required = true) Long idAsunto, ModelMap map) {
		map.put("idAsunto", idAsunto);
		List<PeticionCambioMasivoGestoresAsunto> lista = proxyFactory.proxy(CambiosMasivosApi.class).getCambiosGestoresPendientesPaginados(idAsunto);
		map.put(CAMBIOSGESTORES_PENDIENTE_PAGE_KEY, lista);
		return GET_CAMBIOS_GESTORES_ASUNTO_PENDIENTE_JSON;
	}
	
	@RequestMapping
	public String abreVentanaBuscadorAsuntos(@RequestParam(value = "listaAsuntos", required = true) List<Long> listaAsuntos,
			@RequestParam(value = "idDespacho", required = true) Long idDespacho, ModelMap map) {	
		List<EXTDDTipoGestor> tiposGestor = proxyFactory.proxy(CambioMasivoGestoresAsuntoApi.class).getTiposGestor();
		List<DespachoExterno> despachos = proxyFactory.proxy(CambioMasivoGestoresAsuntoApi.class).getTodosLosDespachos();
		map.put("tiposGestor", tiposGestor);
		map.put("despachos", despachos);
		map.put("listaAsuntos", listaAsuntos);
		map.put("idDespacho", idDespacho);
		return JSP_VENTANA_CAMBIO_GESTORES_BUSCADOR_ASUNTOS;
	}

	/**
	 * Mediante esta petici�n se anotan los cambios solicitados en una Tabla
	 * para su posterior proceso Batch
	 * 
	 * @param dto
	 *            Petici�n para el cambio masivo de Gestores
	 * @param request
	 * @return
	 */
	@RequestMapping
	public String anotarCambiosPendientesDesdeBuscadorDeAsuntos(CambioMasivoGestoresPorAsuntosDtoImpl dto, WebRequest request) {
		ponFechasEnDto(dto, request);

		Usuario logado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		dto.setSolicitante(logado);

		proxyFactory.proxy(CambiosMasivosApi.class).anotarCambiosPendientesPorAsuntos(dto);

		return DEFAULT;
	}
	
	private void ponFechasEnDto(CambioMasivoGestoresPorAsuntosDtoImpl dto, WebRequest request) {
		try {
			String fechaInicio = request.getParameter("fechaInicio");
			if (!Checks.esNulo(fechaInicio)) {
				dto.setFechaInicio(DateFormat.toDate(fechaInicio));
			}
			String fechaFin = request.getParameter("fechaFin");
			if (!Checks.esNulo(fechaFin)) {
				dto.setFechaFin(DateFormat.toDate(fechaFin));
			}
		} catch (ParseException e) {
		}
	}
}