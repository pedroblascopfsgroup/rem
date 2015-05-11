package es.pfsgroup.recovery.recobroConfig.cartera.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.cartera.api.RecobroCarteraApi;
import es.pfsgroup.recovery.recobroCommon.cartera.dto.RecobroDtoCartera;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.CarteraConstants;

@Controller
public class RecobroCarteraController implements RecobroCarteraControllerApi{

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	
	@Override
	@RequestMapping
	@Secured("ROLE_VER_CARTERAS")
	public String buscaCarteras(RecobroDtoCartera dto, ModelMap map) {
		
		Page listaCarteras = proxyFactory.proxy(RecobroCarteraApi.class).buscaCarteras(dto);
		map.put("listaCarteras", listaCarteras);
		
		return "plugin/recobroConfig/cartera/recobroListaCarterasJSON";
		
	}
	
	@Override
	@RequestMapping
	@Secured("ROLE_VER_CARTERAS")
	public String saveCartera(RecobroDtoCartera dto, ModelMap map) {
		proxyFactory.proxy(RecobroCarteraApi.class).altaCartera(dto);
		
		return "default";
	}
	
	@Override
	@RequestMapping
	@Secured({"ROLE_VER_CARTERAS", "ROLE_VER_ESQUEMA"})
	public String verCartera( @RequestParam(value = "id", required = true) Long id, ModelMap map) {
		RecobroCartera cartera = proxyFactory.proxy(RecobroCarteraApi.class).getCartera(id);
		
		map.put("cartera", cartera);
		
		return CarteraConstants.PLUGIN_RCF_CARTERA_OPEN ;
	}

	@Override
	@RequestMapping
	@Secured("ROLE_VER_CARTERAS")
	public String openABMCarteras(ModelMap map) {
		
		List<RecobroDDEstadoComponente> ddEstado = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDEstadoComponente.class);
		List<RecobroEsquema> listaEsquemas = proxyFactory.proxy(RecobroEsquemaApi.class).getListaEsquemas();
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);		
		
		map.put("ddEstado", ddEstado);
		map.put("listaEsquemas", listaEsquemas);
		return "plugin/recobroConfig/cartera/recobroListaCarteras";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_CARTERAS")
	public String copiarRecobroCartera(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroCarteraApi.class).copiarRecobroCartera(id);
		
		return "default";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_CARTERAS")
	public String liberarCartera(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroCarteraApi.class).cambiarEstadoCartera(id, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		return "default";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_CARTERAS")
	public String editaCartera(Long id, ModelMap map) {
		RecobroCartera cartera = proxyFactory.proxy(RecobroCarteraApi.class).getCartera(id);
		List<RuleDefinition> ddRegla = proxyFactory.proxy(DiccionarioApi.class).getReglas();
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);		
		
		
		map.put("cartera", cartera);
		map.put("ddRegla", ddRegla);
		return "plugin/recobroConfig/cartera/altaCartera";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_CARTERAS")
	public String borrarCartera(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroCarteraApi.class).eliminarCartera(id);
		
		return "default";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured({"ROLE_VER_CARTERAS", "ROLE_VER_ESQUEMA"})
	public String buscaCarterasDisponibles(RecobroDtoCartera dto, ModelMap map) {
		Page listaCarteras = proxyFactory.proxy(RecobroCarteraApi.class).buscaCarterasDisponibles(dto);
		map.put("listaCarteras", listaCarteras);
		
		return "plugin/recobroConfig/cartera/recobroListaCarterasJSON";
	}



	
}
