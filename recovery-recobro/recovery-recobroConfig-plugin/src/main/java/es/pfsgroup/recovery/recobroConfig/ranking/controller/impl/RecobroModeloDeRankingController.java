package es.pfsgroup.recovery.recobroConfig.ranking.controller.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloDeRankingDto;
import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloRankingVariableDto;
import es.pfsgroup.recovery.recobroCommon.ranking.manager.api.RecobroModeloDeRankingApi;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroDDVariableRanking;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloRankingVariable;
import es.pfsgroup.recovery.recobroConfig.ranking.controller.api.RecobroModeloDeRankingControllerApi;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroAgenciasConstants;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroModeloDeRankingConstants;

@Controller
public class RecobroModeloDeRankingController implements RecobroModeloDeRankingControllerApi{
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String openABMModeloRanking(ModelMap map) {
		List<RecobroDDVariableRanking> variables = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDVariableRanking.class);
		
		List<RecobroDDEstadoComponente> recobroDDEstados =  proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDEstadoComponente.class);
		map.put("ddEstados", recobroDDEstados);
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		map.put("variables", variables);
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		
		return RecobroModeloDeRankingConstants.PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_MODELO_RANKING;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String borrarModeloRanking(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroModeloDeRankingApi.class).borrarModeloDeRanking(id);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String editModeloRanking(Long idModelo, ModelMap map) {
		RecobroModeloDeRanking modelo = proxyFactory.proxy(RecobroModeloDeRankingApi.class).getModeloDeRanking(idModelo);
		
		map.put("modeloRanking", modelo);
		return RecobroModeloDeRankingConstants.PLUGIN_RECOBROCONFIG_OPEN_ALTA_MODELO_RANKING;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String buscaModelosRanking(RecobroModeloDeRankingDto dto,
			ModelMap map) {
		Page modelosRanking = proxyFactory.proxy(RecobroModeloDeRankingApi.class).buscarModelosRanking(dto);
		map.put("modelosRanking", modelosRanking);
		
		return RecobroModeloDeRankingConstants.PLUGIN_RECOBROCONFIG_LISTA_MODELO_RANKING_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String altaModeloRanking(ModelMap map) {
		return RecobroModeloDeRankingConstants.PLUGIN_RECOBROCONFIG_OPEN_ALTA_MODELO_RANKING;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String borrarVariableModeloRanking(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroModeloDeRankingApi.class).borrarVariableModeloRanking(id);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String addVariableRankingModelo(Long idModelo, ModelMap map) {
		List<RecobroDDVariableRanking> tiposVariables=proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDVariableRanking.class);
		
		map.put("idModelo", idModelo);
		map.put("tiposVariables", tiposVariables);
		
		return RecobroModeloDeRankingConstants.PLUGIN_RECOBROCONFIG_OPEN_ADD_VARIABLEMODELO_RANKING;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String editarVariableModelo(@RequestParam(value = "idVariable", required = true) Long idVariable, ModelMap map) {
		List<RecobroDDVariableRanking> tiposVariables=proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDVariableRanking.class);
		RecobroModeloRankingVariable variable = proxyFactory.proxy(RecobroModeloDeRankingApi.class).getModeloRankingVariable(idVariable);
		
		map.put("idModelo", variable.getModeloDeRanking().getId());
		map.put("tiposVariables", tiposVariables);
		map.put("variable", variable);
		
		return RecobroModeloDeRankingConstants.PLUGIN_RECOBROCONFIG_OPEN_ADD_VARIABLEMODELO_RANKING;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String buscaVariablesRanking(Long idModelo, ModelMap map) {
		RecobroModeloDeRanking modelo = proxyFactory.proxy(RecobroModeloDeRankingApi.class).getModeloDeRanking(idModelo);
		if (!Checks.esNulo(modelo)){
			List<RecobroModeloRankingVariable> variables = modelo.getModeloRankingVariables();
			map.put("variables", variables);
		}
		return RecobroModeloDeRankingConstants.PLUGIN_RECOBROCONFIG_LISTA_VARIABLES_MODELO_RANKING_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String saveModeloRanking(RecobroModeloDeRankingDto dto, ModelMap map) {
		proxyFactory.proxy(RecobroModeloDeRankingApi.class).saveModeloRanking(dto);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String saveVariableModelo(RecobroModeloRankingVariableDto dto,
			ModelMap map) {
		proxyFactory.proxy(RecobroModeloDeRankingApi.class).asociarVariableRankingModelo(dto);
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String copiarModeloRanking(Long idModelo, ModelMap map) {
		proxyFactory.proxy(RecobroModeloDeRankingApi.class).copiarModeloRanking(idModelo);
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_RANKING")
	public String liberarModeloRanking(Long idModelo, ModelMap map) {
		
		proxyFactory.proxy(RecobroModeloDeRankingApi.class).cambiaEstadoModelo (idModelo, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

}
