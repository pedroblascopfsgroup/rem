package es.pfsgroup.recovery.recobroConfig.agenciasRecobro.controller.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cirbe.model.DDPais;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dto.RecobroAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api.RecobroAgenciaApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroConfig.agenciasRecobro.controller.api.RecobroAgenciaControllerApi;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroAgenciasConstants;

/**
 * Clase creada para la controlar la parte web del módulo de configuración de Agencias de Recobro
 * @author diana
 *
 */
@Controller
public class RecobroAgenciaController implements RecobroAgenciaControllerApi{
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;
		
	@Autowired
	private Executor executor;
	
	/**
	 * {@inheritDoc} 
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_AGENCIAS")
	public String buscarAgencia(RecobroAgenciaDto dto, ModelMap map) {
		Page listaAgenciasPaginada = proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgencias(dto);
		map.put("listaAgencias", listaAgenciasPaginada);
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_LISTA_AGENCIAS_JSON;
	}

	
	/**
	 * {@inheritDoc} 
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_AGENCIAS")
	public String crearAgencia(ModelMap map) {
		
		List<DDTipoVia> ddTipoVia = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDTipoVia.class) ;
		List<DDProvincia> ddProvincias =proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDProvincia.class) ;
		List<Localidad> ddPoblacion =proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionarioSinBorrado(Localidad.class);
		List<DDPais> ddPais = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDPais.class);
		
		Usuario u =proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		List<DespachoExterno> despachosExterno =  (List<DespachoExterno>) executor.execute("despachoExternoManager.getDespachosPorTipoZona", convertirEnStringComas(u.getZonas()), "AGER");
		
		map.put("ddTipoVia", ddTipoVia);
		map.put("ddProvincias", ddProvincias);
		map.put("ddPoblacion", ddPoblacion);
		map.put("ddPais", ddPais);
		map.put("despachosExterno", despachosExterno);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_ALTA_AGENCIA ;
	}

	private Object convertirEnStringComas(List<DDZona> zonas) {
		String r = null;
		for (DDZona z : zonas){
			if (!Checks.esNulo(r)){
				r = r + ',' + z.getCodigo();
			}else{
				r = z.getCodigo();
			}
		}
		return r;
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_AGENCIAS")
	public String borrarAgencia(@RequestParam(value = RecobroConfigConstants.RecobroAgenciasConstants.ID_AGENCIA, required = true) Long id, ModelMap map) {
		if (!Checks.esNulo(id)){
			proxyFactory.proxy(RecobroAgenciaApi.class).deleteAgencia(id);
		}
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_AGENCIAS")
	public String actualizarAgencia( @RequestParam(value = RecobroConfigConstants.RecobroAgenciasConstants.ID_AGENCIA, required = true) Long id, ModelMap map) {
		
		RecobroAgencia agencia= proxyFactory.proxy(RecobroAgenciaApi.class).getAgencia(id);
		map.put("agencia", agencia);
		
		List<DDTipoVia> ddTipoVia = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDTipoVia.class) ;
		List<DDProvincia> ddProvincias =proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDProvincia.class) ;
		List<Localidad> ddPoblacion =proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionarioSinBorrado(Localidad.class);
		List<DDPais> ddPais = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDPais.class);
		Usuario u =proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		List<DespachoExterno> despachosExterno =  (List<DespachoExterno>) executor.execute("despachoExternoManager.getDespachosPorTipoZona", convertirEnStringComas(u.getZonas()), DDTipoDespachoExterno.CODIGO_AGENCIA_RECOBRO);

		map.put("despachosExterno", despachosExterno);
		map.put("ddTipoVia", ddTipoVia);
		map.put("ddProvincias", ddProvincias);
		map.put("ddPoblacion", ddPoblacion);
		map.put("ddPais", ddPais);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_ALTA_AGENCIA ;
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_AGENCIAS")
	public String openABMAgencia(ModelMap map) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC,"nombre");
		List<RecobroEsquema> listaEsquemas = genericDao.getListOrdered(RecobroEsquema.class, order, filtro);
		map.put("listaEsquemas", listaEsquemas);

		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_AGENCIAS;
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_AGENCIAS")
	public String saveAgencia(RecobroAgenciaDto dto, ModelMap map) {
		proxyFactory.proxy(RecobroAgenciaApi.class).saveAgencia(dto);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_AGENCIAS")
	public String getLocalidadesByProvincia(Long idProvincia, ModelMap map) {
		List<Localidad> localidades= proxyFactory.proxy(DiccionarioApi.class).getLocalidadesByProvincia(idProvincia);
		map.put("localidades", localidades);
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_LISTA_LOCALIDADES_JSON ;
	}
	
	 /**
     * Devuelve la lista de gestores de un despacho.
     * @param lista de identificadores de despacho separados por coma
     * @return la lista de gestores.
     */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_AGENCIAS")
	public String getGestoresListadoDespachos(String listadoDespachos, ModelMap map) {
		
		List<Usuario> gestoresDespacho =  (List<Usuario>) executor.execute("despachoExternoManager.getGestoresListadoDespachos", listadoDespachos);
		map.put("usuarios", gestoresDespacho);
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_LISTA_USUARIOS_JSON ;
	}

}
