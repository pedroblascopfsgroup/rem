package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores;


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
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dto.PeticionCambioMasivoGestoresDtoImpl;
import es.pfsgroup.recovery.api.UsuarioApi;

/**
 * Este controller recibe las peticiones de cambios maisvos de gestores del
 * Asunto
 * 
 * @author bruno
 * 
 */
@Controller
public class CambioMasivoGestoresAsuntoController {

	public static final String DEFAULT = "default";

	private static final String JSP_VENTANA_PETICION = "plugin/cambiosMasivosAsunto/cambiogestores/ventana";

	private static final String JSON_COMPROBAR = "plugin/cambiosMasivosAsunto/cambiogestores/countJSON";

	private static final String JSON_GESTORES = "asuntos/listadoGestoresJSON";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;
	
	@InitBinder
	protected void initBinder(WebDataBinder binder) {
	    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
	    binder.registerCustomEditor(Date.class, new CustomDateEditor(
	            dateFormat, false));
	}
	

	@RequestMapping
	public String abreVentana(ModelMap model) {
		List<EXTDDTipoGestor> tiposGestor = proxyFactory.proxy(CambioMasivoGestoresAsuntoApi.class).getTiposGestor();
		//List<DespachoExterno> despachos = proxyFactory.proxy(CambioMasivoGestoresAsuntoApi.class).getTodosLosDespachos();

		model.put("tiposGestor", tiposGestor);
		// model.put("despachos", despachos);
		return JSP_VENTANA_PETICION;
	}
	
//	/**
//     * Metodo que devuelve los usuarios para el instant de usuarios
//     * @param query
//     * @param model
//     * @return
//     */
//    @SuppressWarnings("unchecked")
//    @RequestMapping
//    public String getUsuariosInstant(String query, ModelMap model) {
//        model.put("data", proxyFactory.proxy(CambioMasivoGestoresAsuntoApi.class).getUsuarios(query));
//        return "plugin/agendaMultifuncion/json/listaUsuariosJSON";
//    }

	@RequestMapping
	public String comprobarCambiosPendientes(PeticionCambioMasivoGestoresDtoImpl dto, ModelMap model, WebRequest request) {
		
		ponFechasEnDto(dto, request);

		Usuario logado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		dto.setSolicitante(logado);

		int count = proxyFactory.proxy(CambioMasivoGestoresAsuntoApi.class).comprobarCambiosPendientes(dto);
		model.put("count", count);

		return JSON_COMPROBAR;
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
	public String anotarCambiosPendientes(PeticionCambioMasivoGestoresDtoImpl dto, WebRequest request) {
		ponFechasEnDto(dto, request);

		Usuario logado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		dto.setSolicitante(logado);

		proxyFactory.proxy(CambioMasivoGestoresAsuntoApi.class).anotarCambiosPendientes(dto);

		return DEFAULT;
	}
	
	/**
	 * Busca gestores asociados a Asuntos como un tipo de Gestor y en un despacho
	 * 
	 * @param despacho
	 * @param tipoGestor
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String buscaGestoresByDespachoTipoGestor(Long despacho, Long tipoGestor, ModelMap model){
		List<GestorDespacho> gestores = proxyFactory.proxy(CambioMasivoGestoresAsuntoApi.class).buscaGestoresByDespachoTipoGestor(despacho, tipoGestor);
		model.put("gestores", gestores);
		return JSON_GESTORES;
	}

	private void ponFechasEnDto(PeticionCambioMasivoGestoresDtoImpl dto, WebRequest request) {
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
