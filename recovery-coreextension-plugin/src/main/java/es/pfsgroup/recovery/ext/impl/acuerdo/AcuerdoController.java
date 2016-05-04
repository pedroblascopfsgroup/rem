package es.pfsgroup.recovery.ext.impl.acuerdo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.tareaNotificacion.model.DDEntidadAcuerdo;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoManager;

@Controller
public class AcuerdoController {

	private static final String LISTADO_BUSQUEDA_ACUERDOS = "plugin/coreextension/acuerdo/listadoBusquedaAcuerdos";

	
	@Autowired
	public ApiProxyFactory proxyFactory;
	
	@Autowired
	private MEJAcuerdoManager mejAcuerdoManager;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	
	@RequestMapping
	public String listadoBusquedaAcuerdos(WebRequest request, ModelMap model) {
		rellenarFormBusqueda(model);
		return LISTADO_BUSQUEDA_ACUERDOS;
	}

	@SuppressWarnings("unchecked")
	private ModelMap rellenarFormBusqueda(ModelMap model) {
		List<DDSolicitante> tiposSolicitante = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDSolicitante.class);
		List<DDEstadoAcuerdo> estadosAcuerdo = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDEstadoAcuerdo.class);
		List<DDZona> zonas = usuarioManager.getZonasUsuarioLogado();
		List<Nivel> niveles = mejAcuerdoManager.getNiveles();
		List<DDEntidadAcuerdo> listadoEntidadAcuerdo = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDEntidadAcuerdo.class);
		
		model.put("tiposSolicitante", tiposSolicitante);
		model.put("estadosAcuerdo", estadosAcuerdo);
		model.put("zonas", zonas);
		model.put("niveles", niveles);
		model.put("listadoEntidadAcuerdo", listadoEntidadAcuerdo);
				
		return model;
	}
	
}
