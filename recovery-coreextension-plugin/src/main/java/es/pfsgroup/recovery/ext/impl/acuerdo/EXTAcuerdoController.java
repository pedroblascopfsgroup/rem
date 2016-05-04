package es.pfsgroup.recovery.ext.impl.acuerdo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.dto.BusquedaAcuerdosDTO;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;

@Controller
public class EXTAcuerdoController {

	private static final String LISTADO_BUSQUEDA_ACUERDOS = "plugin/coreextension/acuerdo/listadoAcuerdosJSON";

	
	@Autowired
	public ApiProxyFactory proxyFactory;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	
	/**
	 * Controlador que devuelve un JSON con la lista de acuerdos en base a los filtros utilizados en el buscador de acuerdos
	 * @param model
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String listBusquedaAcuerdos(ModelMap model, BusquedaAcuerdosDTO busquedaAcuerdosDTO){
		
		Page page = proxyFactory.proxy(coreextensionApi.class).listBusquedaAcuerdosData(busquedaAcuerdosDTO);
		model.put("pagina", page);
		
		return LISTADO_BUSQUEDA_ACUERDOS;
	}
	
//	<evaluate expression="executor.execute('mejacuerdomanager.getListTiposSolicitante')" result="flowScope.tiposSolicitante"/>
//    <evaluate expression="executor.execute('mejacuerdomanager.getListEstadosAcuerdo')" result="flowScope.estadosAcuerdo"/>	
//    <evaluate expression="executor.execute('usuarioManager.getZonasUsuarioLogado')" result="flowScope.zonas" />
//	<evaluate expression="executor.execute('mejacuerdo.getNiveles')" result="flowScope.niveles" />	
//	<evaluate expression="executor.execute('mejacuerdomanager.getListEntidadAcuerdo')" result="flowScope.listadoEntidadAcuerdo" />	
}
