package es.pfsgroup.recovery.ext.impl.acuerdo;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.dao.DDTipoAcuerdoDao;
import es.capgemini.pfs.acuerdo.dto.DTOTerminosFiltro;
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.model.AcuerdoConfigAsuntoUsers;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.tareaNotificacion.model.DDEntidadAcuerdo;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoManager;

@Controller
public class AcuerdoController {

	private static final String LISTADO_BUSQUEDA_ACUERDOS = "plugin/coreextension/acuerdo/listadoBusquedaAcuerdos";
	private static final String JSON_RESPUESTA  ="generico/respuestaJSON";
	
	@Autowired
	public ApiProxyFactory proxyFactory;
	
	@Autowired
	private MEJAcuerdoManager mejAcuerdoManager;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private	AcuerdoDao acuerdoDao;
	
	@Autowired
	private	GenericABMDao genericDao;
	
	@Autowired
	private	DDTipoAcuerdoDao tipoAcuerdoDao;
	
	@Autowired
	private MEJAcuerdoApi mejAcuerdoApi;
	
	@Resource
	private MessageService messageService;
	
	@RequestMapping
	public String listadoBusquedaAcuerdos(WebRequest request, ModelMap model) {
		rellenarFormBusqueda(model);
		return LISTADO_BUSQUEDA_ACUERDOS;
	}

	@SuppressWarnings("unchecked")
	private ModelMap rellenarFormBusqueda(ModelMap model) {
		
		/*
		List<DDTipoDespachoExterno> tiposSolicitante = new ArrayList<DDTipoDespachoExterno>();
		DDTipoDespachoExterno tipoSol = (DDTipoDespachoExterno) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoDespachoExterno.class,DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
		tiposSolicitante.add(tipoSol);
		*/
		List<DDEstadoAcuerdo> estadosAcuerdo = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDEstadoAcuerdo.class);
		List<DDZona> zonas = usuarioManager.getZonasUsuarioLogado();
		List<Nivel> niveles = mejAcuerdoManager.getNiveles();
		List<DDEntidadAcuerdo> listadoEntidadAcuerdo = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDEntidadAcuerdo.class);		
		
		DDEntidadAcuerdo codigoEntidadAmbas = null;
		codigoEntidadAmbas=genericDao.get(DDEntidadAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEntidadAcuerdo.CODIGO_ENTIDAD_AMBAS));
		List<DDTipoAcuerdo> listado = tipoAcuerdoDao.buscarTipoAcuerdoPorEntidad(codigoEntidadAmbas,codigoEntidadAmbas);
		
		model.put("tiposTerminos", listado);
		//model.put("tiposSolicitante", tiposSolicitante);
		model.put("estadosAcuerdo", estadosAcuerdo);
		model.put("zonas", zonas);
		model.put("niveles", niveles);
		model.put("listadoEntidadAcuerdo", listadoEntidadAcuerdo);
				
		return model;
	}
	
	@SuppressWarnings("unchecked")
	private List<DDTipoDespachoExterno> getTipoDespachoByProponente(List<AcuerdoConfigAsuntoUsers> proponentes) {
		
		List<DDTipoDespachoExterno> tiposSolicitante = new ArrayList<DDTipoDespachoExterno>();
		for(int i=1;i<proponentes.size();i++)
		{
			DDTipoDespachoExterno tipoSol = (DDTipoDespachoExterno) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDTipoDespachoExterno.class,proponentes.get(0).getId());
			tiposSolicitante.add(tipoSol);
		}
		return tiposSolicitante;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String crearAcuerdo(DtoAcuerdo dto, ModelMap model) {
		Long idAcuerdo = mejAcuerdoApi.guardarAcuerdo(dto);
		if(Checks.esNulo(idAcuerdo)){
			model.put("respuesta", messageService.getMessage("plugin.mejoras.acuerdos.crear.usuario.no.tiene.despacho",null));
		}
		return JSON_RESPUESTA;
	}
	
}
