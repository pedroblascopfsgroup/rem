package es.pfsgroup.recovery.recobroConfig.facturacion.controller.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroDDTipoCobroDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionTramoCorrectorDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.manager.api.RecobroModeloFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroCorrectorFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroDDTipoCorrector;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTarifaCobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTramoFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.serder.RecobroTarifaCobroTramoItems;
import es.pfsgroup.recovery.recobroConfig.facturacion.controller.api.RecobroModeloFacturacionControllerApi;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroAgenciasConstants;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroEsquemasConstants;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroModeloFacturacionConstants;
import org.springframework.web.util.HtmlUtils;

/**
 * Clase creada para la controlar la parte web del modelo de facturación
 * @author Carlos
 *
 */
@Controller
public class RecobroModeloFacturacionController implements RecobroModeloFacturacionControllerApi {
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	private final Log logger = LogFactory.getLog(getClass());
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String openABMFacturacion(ModelMap map) {
		
		List<RecobroDDTipoCorrector> tiposDeCorrectores = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDTipoCorrector.class);
		map.put("ddTiposCorrector", tiposDeCorrectores);
		
		List<RecobroDDEstadoComponente> recobroDDEstados =  proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDEstadoComponente.class);
		map.put("ddEstados", recobroDDEstados);
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_FACTURACION;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String openLauncher(Long idModFact, ModelMap map) {
		map.put("idModFact", idModFact);
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_LAUNCHER;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String abrirGeneral(Long idModFact, ModelMap map) {
		RecobroModeloFacturacion modelo = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(idModFact);
		map.put("modelo", modelo);
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_GENERAL;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String abrirCobros(Long idModFact, ModelMap map) {
		map.put("idModFact", idModFact);
		RecobroModeloFacturacion modelo = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(idModFact);
		map.put("modelo", modelo);
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_COBROS;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String abrirTarifas(Long idModFact, ModelMap map) {
		List<RecobroTramoFacturacion> tramosFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getListTramosFacturacion(idModFact);
		map.put("numTramos", tramosFacturacion.size());
		map.put("tramos", tramosFacturacion);
		map.put("idModFact", idModFact);
		
		RecobroModeloFacturacion modelo = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(idModFact);
		map.put("modelo", modelo);
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_TARIFAS;
	}

	/**
	 * @{inhericDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String buscaCobros(RecobroDDTipoCobroDto dto, ModelMap map) {		
		dto.setFacturables(true);
		Page cobros = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getCobros(dto);
		map.put("cobros", cobros);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_LISTA_COBROS_JSON;
	}
	

	/**
	 * @{inhericDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String habilitarCobro(
			@RequestParam(value = "idModFact", required = true) Long idModFact,
			@RequestParam(value = "idTipoCobro", required = true) Long idTipoCobro,
			ModelMap map) {
		
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).habilitarCobro(idModFact,idTipoCobro);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}
	
	/**
	 * @{inhericDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String desHabilitarCobro(
			@RequestParam(value = "idModFact", required = true) Long idModFact,
			@RequestParam(value = "idTipoCobro", required = true) Long idTipoCobro,
			ModelMap map) {
		
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).desHabilitarCobro(idModFact,idTipoCobro);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * @{inhericDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String buscaModelosFacturacion(RecobroModeloFacturacionDto dto,
			ModelMap map) {
		Page modelosFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).buscarModelosFacturacion(dto);
		map.put("modelosFacturacion", modelosFacturacion);

		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_LISTA_MODELOSFACTURACION_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String buscaSubCarterasModeloFacturacion(@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map) {
		RecobroModeloFacturacion modeloFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(idModFact);
		if (!Checks.esNulo(modeloFacturacion)){
			List<RecobroSubCartera> subCarteras=modeloFacturacion.getSubCarteras();
			map.put("subCarteras", subCarteras);
		}
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERAS_ESQUEMA_JSON ;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String addModelosFacturacion(ModelMap map) {
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_ALTA_MOD_FACTURACION;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String guardaModeloFacturacion(RecobroModeloFacturacionDto dto,
			ModelMap map) {
		
		RecobroModeloFacturacion modelo = proxyFactory.proxy(RecobroModeloFacturacionApi.class).guardaModeloFacturacion(dto);
		map.put("modelo",modelo);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_MODELO_FACTURACION_JSON;
	}

	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String buscaTarifasConcepCobros(Long idModFact, Long idCobro, ModelMap map) {
		List<RecobroTarifaCobro> recobroTarifasCobro;
		recobroTarifasCobro = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getListTarifasCobro(idModFact, idCobro);
		map.put("numTramos", Checks.esNulo(recobroTarifasCobro.get(0).getTarifasCobrosTramos()) ? 0 : recobroTarifasCobro.get(0).getTarifasCobrosTramos().size());
		map.put("tarifasCobro", recobroTarifasCobro);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_LISTA_TARIFAS_COBROS_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String borrarModeloFacturacion(@RequestParam(value = "id", required = true) Long id, ModelMap map) {
		
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).borrarModeloFacturacion(id);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String editaModeloFacturacion(@RequestParam(value = "id", required = true) Long id, ModelMap map) {
		RecobroModeloFacturacion modelo = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(id);
		map.put("modelo", modelo);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_ALTA_MOD_FACTURACION;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String getTramosModeloFacturacion(Long id, ModelMap map) {
		RecobroModeloFacturacion modelo = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(id);
		List<RecobroTramoFacturacion> tramos=modelo.getTramosFacturacion();
		map.put("tramos", tramos);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_LISTA_TRAMOS_JSON;
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String addTramoFacturacion(Long idModFact, ModelMap map) {
		map.put("idModFact", idModFact);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_ADD_TRAMO_FACTURACION;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String borrarTramoFacturacion(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).borrarTramoFacturacion(id);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String guardarTramoFacturacion(RecobroModeloFacturacionDto dto,
			ModelMap map) {
		
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).guradarTramoFacturacion(dto);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String abrirCorrectores(Long idModFact, ModelMap map) {
		
		RecobroModeloFacturacion modeloFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(idModFact);
		map.put("modeloFacturacion", modeloFacturacion);
		map.put("idModFact", idModFact);
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_CORRECTORES;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String abrirListadoCorrectores(Long idModFact, ModelMap map) {
		
		RecobroModeloFacturacion modeloFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(idModFact);
		List<RecobroCorrectorFacturacion> tramosCorrectores = modeloFacturacion.getTramosCorrectores();
		map.put("tramosCorrectores", tramosCorrectores);
		
		if ( (!Checks.esNulo(modeloFacturacion.getTipoCorrector()))){
			if (modeloFacturacion.getTipoCorrector().getCodigo().equals(RecobroDDTipoCorrector.CORRECTO_TIPO_RANKING)){
				return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_LISTA_TRAMOS_CORRECTORES_RANKING_JSON;
			} else if (modeloFacturacion.getTipoCorrector().getCodigo().equals(RecobroDDTipoCorrector.CORRECTOR_TIPO_OBJETIVO)) {
				return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_LISTA_TRAMOS_CORRECTORES_OBJETIVO_JSON;	
			}
		}
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String abrirTramoCorrector(Long idModFact, Long idTramoCorrector, ModelMap map){
		
		RecobroCorrectorFacturacion correctoFacturacion = null;
		if (!Checks.esNulo(idTramoCorrector)){
			correctoFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getCorrectorFacturacion(idTramoCorrector);
		}
		
		RecobroModeloFacturacion modeloFacturacion = null;
		if (!Checks.esNulo(idModFact)){
			modeloFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(idModFact);
		}
		
		map.put("modeloFacturacion", modeloFacturacion);
		map.put("correctoFacturacion", correctoFacturacion);
		map.put("idTramoCorrector", idTramoCorrector);
		map.put("idModFact", idModFact);	
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_EDIT_TRAMO_CORRECTOR;
		
	}
	
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String editarTipoCorrector(Long idModFact, ModelMap map) {
		
		RecobroModeloFacturacion modeloFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(idModFact);
		List<RecobroDDTipoCorrector> tiposDeCorrectores = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDTipoCorrector.class);
		
		map.put("CORRECTOR_TIPO_OBJETIVO", RecobroDDTipoCorrector.CORRECTOR_TIPO_OBJETIVO);
		map.put("CORRECTOR_TIPO_RANKING", RecobroDDTipoCorrector.CORRECTO_TIPO_RANKING);
		map.put("modeloFacturacion", modeloFacturacion);
		map.put("idModFact", idModFact);
		map.put("tiposDeCorrectores", tiposDeCorrectores);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_EDIT_TIPO_CORRECTOR;
	}
	
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String guardarTramoCorrector(RecobroModeloFacturacionTramoCorrectorDto dto, ModelMap map) {
		
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).guardarTramoCorrector(dto);
		
		if (!Checks.esNulo(dto.getIdModFact())){
			RecobroModeloFacturacion modeloFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(dto.getIdModFact());
			map.put("modeloFacturacion", modeloFacturacion);
			map.put("idModFact", dto.getIdModFact());
		}
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;

	}
	
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String guardarTipoDeCorrector(RecobroModeloFacturacionDto dto, ModelMap map) {
		
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).guardarTipoDeCorrector(dto);
		
		if (!Checks.esNulo(dto.getId())){
			RecobroModeloFacturacion modeloFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(dto.getId());
			map.put("modeloFacturacion", modeloFacturacion);
			map.put("idModFact", dto.getId());
		}
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;

	}

	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String borrarTramoCorrector(Long idTramoCorrector, ModelMap map) {
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).borrarTramoCorrector(idTramoCorrector);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String abrirEditTarifas(Long idModFact, Long idCobro,
			ModelMap map) {
		List<RecobroTramoFacturacion> tramosFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getListTramosFacturacion(idModFact);
		DDSubtipoCobroPago tipoCobro = (DDSubtipoCobroPago) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionario(DDSubtipoCobroPago.class, idCobro);
		map.put("numTramos", tramosFacturacion.size());
		map.put("tramos", tramosFacturacion);
		map.put("idModFact", idModFact);
		map.put("tipoCobro", tipoCobro);
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_EDIT_TARIFAS;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String saveTarifas(String conceptos, ModelMap map) {
		if (!Checks.esNulo(conceptos)) {
			conceptos = HtmlUtils.htmlUnescape(conceptos);
			ObjectMapper mapper = new ObjectMapper();
			RecobroTarifaCobroTramoItems gridItems = null;
			try {
				gridItems = mapper.readValue(conceptos, RecobroTarifaCobroTramoItems.class);
			} catch (Exception e) {
				logger.error(e);				
				return null;
			}
			
			if (!Checks.esNulo(gridItems)) {
				proxyFactory.proxy(RecobroModeloFacturacionApi.class).guardaTarifasTramos(gridItems);
			}
		}
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String liberarModeloFacturacion(Long idModFact, ModelMap map) {
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).cambiaEstadoModeloFacturacion(idModFact, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_FACTURACION")
	public String copiarModeloFacturacion(Long idModFact, ModelMap map) {
		
		proxyFactory.proxy(RecobroModeloFacturacionApi.class).copiarModeloFacturacion(idModFact);
		
		return RecobroModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

}
