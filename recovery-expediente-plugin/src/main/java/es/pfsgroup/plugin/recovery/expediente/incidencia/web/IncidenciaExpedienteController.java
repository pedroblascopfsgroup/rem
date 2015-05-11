package es.pfsgroup.plugin.recovery.expediente.incidencia.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.expediente.incidencia.api.IncidenciaExpedienteApi;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.DtoFiltroIncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.DtoIncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.SituacionIncidencia;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.TipoIncidencia;

/**
 * Controlador que atiende las peticiones de las pantallas de incidencias
 * expedientes.
 * 
 */
@Controller
public class IncidenciaExpedienteController {

	static final String DEFAULT_JSON = "plugin/expediente/defaultJSON";
	static final String INCIDENCIAS_JSON = "plugin/expediente/incidenciaExpediente/listaIncidenciasJSON";
	static final String NUEVA_INCIDENCIA = "plugin/expediente/incidenciaExpediente/nuevaIncidenciaExpediente";
	static final String GESTION_INCIDENCIAS = "plugin/expediente/incidenciaExpediente/tabIncidenciaExpediente";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoIncidenciaExpediente(ModelMap model, DtoFiltroIncidenciaExpediente dto) {

		Page listado = proxyFactory.proxy(IncidenciaExpedienteApi.class).getListadoIncidenciaExpedienteUsuario(dto);
		model.put("listado", listado);
		
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		model.put("usuario", usuario);
		
		model.put("esProveedor", proxyFactory.proxy(IncidenciaExpedienteApi.class).esGestorRecobroExpediente(usuario, dto.getIdExpediente()));

		return INCIDENCIAS_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirNuevaVentanaIncidenciaExpediente(ModelMap model, Long id) {

		model.put("id", id);
		return NUEVA_INCIDENCIA;
	}

	@RequestMapping
	public String abrirVentanaIncidenciaExpediente(ModelMap model) {

		return GESTION_INCIDENCIAS;
	}

	@RequestMapping
	public String guardarIncidencia(ModelMap model, DtoIncidenciaExpediente dto) {

		proxyFactory.proxy(IncidenciaExpedienteApi.class).crearIncidencia(dto);

		return "default";
	}

	@RequestMapping
	public String borrarIncidencia(ModelMap model, Long id) {

		proxyFactory.proxy(IncidenciaExpedienteApi.class).borrarIncidencia(id);

		return "default";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoPersonasExpediente(ModelMap model, Long id) {

		List<Persona> listado = proxyFactory.proxy(IncidenciaExpedienteApi.class).getListadoPersonasExpediente(id);
		model.put("listado", listado);

		return DEFAULT_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoContratosExpediente(ModelMap model, Long id) {

		List<Contrato> listado = proxyFactory.proxy(IncidenciaExpedienteApi.class).getListadoContratosExpediente(id);
		model.put("listado", listado);

		return DEFAULT_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoTiposIncidencia(ModelMap model) {

		List<TipoIncidencia> listado = proxyFactory.proxy(IncidenciaExpedienteApi.class).getListadoTiposIncidencia();
		model.put("listado", listado);

		return DEFAULT_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoSituacionIncidencia(ModelMap model) {

		List<SituacionIncidencia> listado = proxyFactory.proxy(IncidenciaExpedienteApi.class).getListadoSituacionIncidencia();
		model.put("listado", listado);

		return DEFAULT_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoProveedores(ModelMap model) {

		List<DespachoExterno> listado = proxyFactory.proxy(IncidenciaExpedienteApi.class).getListadoProveedoresUsuario();
		model.put("listado", listado);

		return DEFAULT_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String tienePerfilProveedor(ModelMap model) {

		Usuario usu = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		Boolean esProveedor = proxyFactory.proxy(IncidenciaExpedienteApi.class).esGestorRecobro(usu);
		model.put("esProveedor", esProveedor);

		return "default";
	}
	
	@RequestMapping
	public String updateIncidencia(ModelMap model, Long id, Long idSituacionIncidencia) {

		proxyFactory.proxy(IncidenciaExpedienteApi.class).updateIncidencia(id,idSituacionIncidencia);

		return "default";
	}

}
