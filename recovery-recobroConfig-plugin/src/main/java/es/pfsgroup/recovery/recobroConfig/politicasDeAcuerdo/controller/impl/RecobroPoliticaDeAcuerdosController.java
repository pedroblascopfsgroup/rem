package es.pfsgroup.recovery.recobroConfig.politicasDeAcuerdo.controller.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.model.RecobroDDSubtipoPalanca;
import es.capgemini.pfs.acuerdo.model.RecobroDDTipoPalanca;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaAcuerdosPalancaDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaDeAcuerdosDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.manager.api.RecobroPoliticaDeAcuerdosApi;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaAcuerdosPalanca;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroConfig.politicasDeAcuerdo.controller.api.RecobroPoliticaDeAcuerdosControllerApi;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroAgenciasConstants;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroPoliticaDeAcuerdosConstants;

/**
 * Clase creada para la controlar la parte web del módulo de configuración de Políticas de acuerdos
 * @author diana
 *
 */
@Controller
public class RecobroPoliticaDeAcuerdosController implements RecobroPoliticaDeAcuerdosControllerApi{
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String openABMPoliticas(ModelMap map) {
		List<RecobroDDTipoPalanca> tiposPalancas = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDTipoPalanca.class);
		
		List<RecobroDDEstadoComponente> recobroDDEstados =  proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDEstadoComponente.class);
		map.put("ddEstados", recobroDDEstados);
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);		
		
		map.put("tiposPalancas", tiposPalancas);
		
		return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_POLITICAS;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String buscaPoliticasAcuerdos(RecobroPoliticaDeAcuerdosDto dto,
			ModelMap map) {
		
		Page politicas = proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).buscaPoliticas(dto);
		map.put("politicas", politicas);
		
		return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_LISTA_POLITICAS_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String borrarPoliticaAcuerdos(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).borrarPolitica(id);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String buscaPalancasPolitica(Long idPolitica, ModelMap map) {
		
		RecobroPoliticaDeAcuerdos politica = proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).getPoliticaDeAcuerdo(idPolitica);
		if (!Checks.esNulo(politica)){
			List<RecobroPoliticaAcuerdosPalanca> palancas = politica.getPoliticaAcuerdosPalancas();
			map.put("palancas", palancas);
		}
		
		return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_LISTA_PALANCASPOLITICA_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String altaPoliticaAcuerdos(ModelMap map) {
		
		return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_OPEN_ALTA_POLITICA;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String savePoliticaAcuerdos(RecobroPoliticaDeAcuerdosDto dto,
			ModelMap map) {
		
		Long idPolitica = proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).savePolitica(dto);
		if (Checks.esNulo(idPolitica)){
			RecobroPoliticaDeAcuerdos politica = proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).getPoliticaDeAcuerdo(idPolitica);
			map.put("politica", politica);
		}
		//return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_VERPOLITICA_JSON;
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String abrirPoliticaAcuerdos(Long idPolitica, ModelMap map) {
		RecobroPoliticaDeAcuerdos politica = proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).getPoliticaDeAcuerdo(idPolitica);
		map.put("politica", politica);
		
		return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_OPEN_POLITICA;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String editPoliticaAcuerdos(Long idPolitica, ModelMap map) {
		RecobroPoliticaDeAcuerdos politica = proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).getPoliticaDeAcuerdo(idPolitica);
		map.put("politica", politica);
		
		return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_OPEN_ALTA_POLITICA;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String addPalancaPolitica(Long idPolitica, ModelMap map) {
		
		List<RecobroDDTipoPalanca> tiposPalanca = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDTipoPalanca.class);
		List<DDSiNo> ddSiNo = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDSiNo.class);
		int maxPrioridad = calculaMaxPrioridadPolitica(idPolitica) ;
		
		map.put("tiposPalanca", tiposPalanca);
		map.put("ddSiNo", ddSiNo);
		map.put("maxPrioridad", maxPrioridad);
		map.put("idPolitica", idPolitica);
		
		return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_ADD_PALANCA_POLITICA;
	}

	private int calculaMaxPrioridadPolitica(Long idPolitica) {
		int maxPrioridad = 1;
		RecobroPoliticaDeAcuerdos politica = proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).getPoliticaDeAcuerdo(idPolitica);
		if (!Checks.esNulo(politica)){
			if (!Checks.esNulo(politica.getPoliticaAcuerdosPalancas()) && !Checks.estaVacio(politica.getPoliticaAcuerdosPalancas())){
				maxPrioridad=politica.getPoliticaAcuerdosPalancas().size()+1;
			}
		}
		return maxPrioridad;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String savePalancaPolitica(RecobroPoliticaAcuerdosPalancaDto dto,
			ModelMap map) {
		proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).guardaPalancaPolitica(dto);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String borrarPalancaPoliticaAcuerdos(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).borrarPalancaRecualculoPrioridades(id);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String getSubtiposPalanca(String codigoTipoPalanca, ModelMap map) {
		
		List<RecobroDDSubtipoPalanca> subpalancas = proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).getSubTiposPalanca(codigoTipoPalanca);
		
		map.put("subpalancas",subpalancas);
		
		return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_LISTASUBPALANCAS_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String editarPalancaPolitica(Long idPalanca, ModelMap map) {
		RecobroPoliticaAcuerdosPalanca palanca= proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).getPoliticaDeAcuerdosPalanca(idPalanca);
		List<RecobroDDTipoPalanca> tiposPalanca = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDTipoPalanca.class);
		List<DDSiNo> ddSiNo = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDSiNo.class);
		int maxPrioridad = calculaMaxPrioridadPolitica(palanca.getPoliticaAcuerdos().getId())-1;
		
		map.put("tiposPalanca", tiposPalanca);
		map.put("ddSiNo", ddSiNo);
		map.put("maxPrioridad", maxPrioridad);
		map.put("idPolitica", palanca.getPoliticaAcuerdos().getId());
		map.put("palanca", palanca);
		
		return RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_ADD_PALANCA_POLITICA;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String copiarPoliticaAcuerdos(Long id, ModelMap map) {
		
		proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).copiarPoliticaAcuerdos(id);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_POLITICAS")
	public String liberarPoliticaAcuerdos(Long id, ModelMap map) {
		
		proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).cambiarEstadoPoliticaAcuerdos(id, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}
	
	

}
