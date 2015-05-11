package es.pfsgroup.recovery.recobroConfig.esquema.controller.impl;


import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.tags.HtmlEscapeTag;
import org.springframework.web.util.HtmlUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDTipoGestion;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api.RecobroAgenciaApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroCarteraEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroSubcarAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroSubcarteraDto;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroCarteraEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroSubCarteraApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDAmbitoExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDModeloTransicion;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoGestionCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoRepartoSubcartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSimulacionEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraRanking;
import es.pfsgroup.recovery.recobroCommon.esquema.serder.recobroSubCarAgencias.RecobroSubcarteraAgenciasGrid;
import es.pfsgroup.recovery.recobroCommon.facturacion.manager.api.RecobroModeloFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.manager.api.RecobroItinerarioApi;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.manager.api.RecobroPoliticaDeAcuerdosApi;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroCommon.ranking.manager.api.RecobroModeloDeRankingApi;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonEsquemasConstants;
import es.pfsgroup.recovery.recobroConfig.esquema.controller.api.RecobroEsquemaControllerApi;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroAgenciasConstants;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroEsquemasConstants;

/**
 * Clase creada para la controlar la parte web del módulo de configuración de Esquemas de Agencias de Recobro
 * @author diana
 *
 */
@Controller
public class RecobroEsquemaController implements RecobroEsquemaControllerApi {
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	private final Log logger = LogFactory.getLog(getClass());
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String openABMEsquema(ModelMap map) {
		List<RecobroDDEstadoEsquema> ddEstadosEsquema = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDEstadoEsquema.class);
		map.put("ddEstadosEsquema", ddEstadosEsquema);
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION);
		map.put("ESTADO_LIBERADO", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO);
		map.put("ESTADO_SIMULADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO);
		map.put("ESTADO_PENDIENTESIMULAR", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR);
		map.put("ESTADO_EXTINCION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_EXTINCION);
		map.put("ESTADO_DESACTIVADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DESACTIVADO);
		 
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_ESQUEMAS;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String buscaRecobroEsquema(RecobroEsquemaDto dto, ModelMap map) {
		Page esquemas = proxyFactory.proxy(RecobroEsquemaApi.class).buscarRecobroEsquema(dto);
		
		map.put("esquemas", esquemas);
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_LISTA_ESQUEMAS_JSON;
	}


	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String borrarRecobroEsquema(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroEsquemaApi.class).borrarRecobroEsquema(id);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String abrirRecobroEsquema(Long idEsquema, String botonPulsado, ModelMap map) {
		RecobroSimulacionEsquema esquemaSimulacion = proxyFactory.proxy(RecobroEsquemaApi.class).getSimulacion(idEsquema);
		map.put("sinSimulacion",Checks.esNulo(esquemaSimulacion));		
		map.put("idEsquema", idEsquema);		
		map.put("ultimaVersionDelEsquema", proxyFactory.proxy(RecobroEsquemaApi.class).ultimaVersionDelEsquema(idEsquema));
		map.put("botonPulsado", botonPulsado);
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_ABRIR_ESQUEMA;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String guardarRecobroEsquema(RecobroEsquemaDto dto, ModelMap map) {
		
		proxyFactory.proxy(RecobroEsquemaApi.class).guardarRecobroEsquema(dto);
		
		if (!Checks.esNulo(dto.getId())){
			RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(Long.valueOf(dto.getId()));
			map.put("esquema", esquema);
		}
		
		return "default";
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String buscaCarterasEsquema(Long idEsquema, ModelMap map) {
		RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(idEsquema);
		List<RecobroCarteraEsquema> carterasEsquema = esquema.getCarterasEsquema();
		
		map.put("carterasEsquema", carterasEsquema);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_LISTA_CARTERAS_ESQUEMA_JSON ;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String abrirConformarCarteras(Long idEsquema, boolean ultimaVersionDelEsquema, ModelMap map) {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(idEsquema);
		Boolean esVersionDelEsquemaliberado =proxyFactory.proxy(RecobroEsquemaApi.class).esVersionDelEsquemaliberado(esquema);
		
		map.put("idEsquema", idEsquema);
		map.put("ultimaVersionDelEsquema", ultimaVersionDelEsquema);
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION);
		map.put("ESTADO_LIBERADO", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO);
		map.put("ESTADO_SIMULADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO);
		map.put("ESTADO_PENDIENTESIMULAR", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR);
		map.put("ESTADO_EXTINCION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_EXTINCION);
		map.put("ESTADO_DESACTIVADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DESACTIVADO);
		map.put("esVersionDelEsquemaliberado", esVersionDelEsquemaliberado);
		map.put("esquema", esquema);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_ABRIR_CONFORMAR_CARTERAS;
	}


	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String abrirFichaEsquema(Long idEsquema, boolean ultimaVersionDelEsquema, ModelMap map) {
		
		RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(idEsquema);
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Boolean enEstadoCorrectoLiberar = proxyFactory.proxy(RecobroEsquemaApi.class).compruebaEstadoCorrectoLiberar(idEsquema);
		
		map.put("esquema", esquema);
		map.put("COD_ESTADO_ESQUEMA_PENDIENTESIMULAR", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR);
		map.put("ultimaVersionDelEsquema", ultimaVersionDelEsquema);
		// Formateo de las fechas para mostrarlas
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		if (!Checks.esNulo(esquema.getFechaAlta()))
			map.put("fechaAltaFormat", format.format(esquema.getFechaAlta()));
		if (!Checks.esNulo(esquema.getFechaLiberacion()))
			map.put("fechaLiberacionFormat", format.format(esquema.getFechaLiberacion()));
		if (!Checks.esNulo(esquema.getFechaFinTransicion()))
			map.put("fechaFinTransFormat", format.format(esquema.getFechaFinTransicion()));
		
		
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION);
		map.put("ESTADO_LIBERADO", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO);
		map.put("ESTADO_SIMULADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO);
		map.put("ESTADO_PENDIENTESIMULAR", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR);
		map.put("ESTADO_EXTINCION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_EXTINCION);
		map.put("ESTADO_DESACTIVADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DESACTIVADO);
		map.put("enEstadoCorrectoLiberar", enEstadoCorrectoLiberar);
		
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_ABRIR_FICHA_ESQUEMA;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String editarRecobroEsquema(Long idEsquema, ModelMap map){
		
		
		RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(idEsquema);
		Boolean esVersionDelEsquemaliberado = proxyFactory.proxy(RecobroEsquemaApi.class).esVersionDelEsquemaliberado(esquema);
		
		List<RecobroDDEstadoEsquema> estadosEsquema = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDEstadoEsquema.class);
		List<RecobroDDModeloTransicion> modelosTranscion = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDModeloTransicion.class);
		
		map.put("esquema", esquema);
		map.put("ddEstadosEsquema", estadosEsquema);
		map.put("ddModeloTransicion", modelosTranscion);
		map.put("esVersionDelEsquemaliberado", esVersionDelEsquemaliberado);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_EDITAR_ESQUEMA;
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String cambiarEstadoRecobroEsquema(Long idEsquema, String codEstado, ModelMap map){
		
		if (!Checks.esNulo(idEsquema) && !Checks.esNulo(codEstado)){
			proxyFactory.proxy(RecobroEsquemaApi.class).cambiarEstadoRecobroEsquema(idEsquema, codEstado);
		}
		
		map.put("idEsquema", idEsquema);
		
		return "default";
		
	}
	
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String abrirFrmCarteraEsquema(Long idEsquema, Long idCartera, Long idCarteraEsquema, ModelMap map) {
		List<RecobroDDTipoCarteraEsquema> ddTiposCartera = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDTipoCarteraEsquema.class);
		List<RecobroDDTipoGestionCartera> ddTiposGestion = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDTipoGestionCartera.class);
		List<RecobroDDAmbitoExpedienteRecobro> ddAmbitoExpediente = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDAmbitoExpedienteRecobro.class);
		RecobroDDTipoGestionCartera sinGestion = (RecobroDDTipoGestionCartera) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDTipoGestionCartera.class, RecobroDDTipoGestionCartera.CODIGO_TIPO_SIN_GESTION);
//		RecobroCartera cartera = proxyFactory.proxy(RecobroCarteraApi.class).getCartera(idCartera);

		RecobroCarteraEsquema carteraEsquema = new RecobroCarteraEsquema();
		int maxPrioridad = 1;
		int selPrioridad = -1;
		int nuevo = 1;
		
		
		if (!Checks.esNulo(idCarteraEsquema)) {
			carteraEsquema = proxyFactory.proxy(RecobroCarteraEsquemaApi.class).getRecobroCarteraEsquema(idCarteraEsquema);
			if (!Checks.esNulo(carteraEsquema)) {
				selPrioridad = carteraEsquema.getPrioridad();
				idEsquema = carteraEsquema.getEsquema().getId();
			}
			
			nuevo = 0;
		}
		
		
		if (!Checks.esNulo(idEsquema)) {
			RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(idEsquema);
			if (!Checks.esNulo(esquema)) {
				maxPrioridad = esquema.getCarterasEsquema().size()+nuevo;
				if (selPrioridad == -1) {
					selPrioridad = maxPrioridad;
				}
			}
		}
		
		map.put("idEsquema", idEsquema);
		map.put("idCartera", idCartera);
		map.put("carteraEsquema", carteraEsquema);
		map.put("ddTiposCartera", ddTiposCartera);
		map.put("ddTiposGestion", ddTiposGestion);
		map.put("ddAmbitoExpediente", ddAmbitoExpediente);
		map.put("maxPrioridad", maxPrioridad);
		map.put("selPrioridad", selPrioridad);
		map.put("sinGestion", sinGestion);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_ABRIR_FRM_CARTERA_ESQUEMA;
	}


	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String saveCarteraEsquema(RecobroCarteraEsquemaDto dto, ModelMap map) {
		proxyFactory.proxy(RecobroCarteraEsquemaApi.class).guardarRecobroCarteraEsquema(dto);
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String borrarRecobroCarteraEsquema(Long idCarteraEsquema, ModelMap map) {
		proxyFactory.proxy(RecobroCarteraEsquemaApi.class).borrarRecobroCarteraEsquema(idCarteraEsquema);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}
	
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String openFacturacion(Long idEsquema, boolean ultimaVersionDelEsquema, ModelMap map) {
		RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(idEsquema);
		Boolean esVersionDelEsquemaliberado =proxyFactory.proxy(RecobroEsquemaApi.class).esVersionDelEsquemaliberado(esquema);
		
		map.put("idEsquema", idEsquema);
		map.put("ultimaVersionDelEsquema", ultimaVersionDelEsquema);
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION);
		map.put("ESTADO_LIBERADO", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO);
		map.put("ESTADO_SIMULADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO);
		map.put("ESTADO_PENDIENTESIMULAR", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR);
		map.put("ESTADO_EXTINCION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_EXTINCION);
		map.put("ESTADO_DESACTIVADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DESACTIVADO);
		map.put("esquema", esquema);
		map.put("ultimaVersionDelEsquema", ultimaVersionDelEsquema);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_ABRIR_FACTURACION_ESQUEMA;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String buscaSubCarterasCarteraEsquema(Long idCarteraEsquema,
			ModelMap map) {

		List<? extends RecobroSubCartera> subCarteras=proxyFactory.proxy(RecobroEsquemaApi.class).getSubcarterasCarteraEsquema(idCarteraEsquema);
		map.put("subCarteras", subCarteras);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERAS_ESQUEMA_JSON;
		
		
	}

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String cambiarModeloGestion(Long idSubCartera, ModelMap map) {
		List<RecobroModeloFacturacion> modelosFacturacion = proxyFactory.proxy(RecobroModeloFacturacionApi.class).getListModelosFacturacion();
		RecobroSubCartera subcartera=proxyFactory.proxy(RecobroSubCarteraApi.class).getRecobroSubCartera(idSubCartera);
		List<RecobroItinerarioMetasVolantes> itinerariosMetasVolantes = proxyFactory.proxy(RecobroItinerarioApi.class).getItinerariosMetasVolantes();
		List<RecobroPoliticaDeAcuerdos> listaPoliticasDeAcuerdo = proxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class).getListaPoliticasDeAcuerdo();
		List<RecobroModeloDeRanking> listaModelosDeRanking = proxyFactory.proxy(RecobroModeloDeRankingApi.class).getListaModelosDeRanking();
		
		map.put("politicasDeAcuerdo", listaPoliticasDeAcuerdo);
		map.put("itinerariosMetasVolantes", itinerariosMetasVolantes);
		map.put("modelosDeRanking", listaModelosDeRanking);
		map.put("modelosFacturacion", modelosFacturacion);
		map.put("subcartera", subcartera);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_EDIT_FACTURACION_SUBCARTERA;
	}

	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String guardarModelosSubcartera(RecobroSubcarteraDto dto, ModelMap map) {
		proxyFactory.proxy(RecobroEsquemaApi.class).guardarModelosSubcartera(dto);
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String abrirRepartoSubcarteras(@RequestParam(value = "idEsquema", required = true) Long idEsquema, 
			boolean ultimaVersionDelEsquema, ModelMap map) {
		
		RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(idEsquema);
		Boolean esVersionDelEsquemaliberado =proxyFactory.proxy(RecobroEsquemaApi.class).esVersionDelEsquemaliberado(esquema);
		
		map.put("idEsquema", idEsquema);
		map.put("REP_ESTATICO", RecobroCommonEsquemasConstants.RCF_REPARTO_SUBCARTERAS_ESTATICO);
		map.put("SIN_GESTION", RecobroDDTipoGestionCartera.CODIGO_TIPO_SIN_GESTION);
		map.put("REP_DINAMICO", RecobroCommonEsquemasConstants.RCF_REPARTO_SUBCARTERAS_DINAMICO);
		map.put("ultimaVersionDelEsquema", ultimaVersionDelEsquema);
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION);
		map.put("ESTADO_LIBERADO", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO);
		map.put("ESTADO_SIMULADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO);
		map.put("ESTADO_PENDIENTESIMULAR", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR);
		map.put("ESTADO_EXTINCION", RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_EXTINCION);
		map.put("ESTADO_DESACTIVADO",  RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DESACTIVADO);
		map.put("esVersionDelEsquemaliberado",  esVersionDelEsquemaliberado);
		map.put("esquema", esquema);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_ABRIR_REPARTO_SUBCARTERA;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String abrirFrmRepartoAgencias(Long idCarteraEsquema, Long idSubCartera, String codTipoReparto, ModelMap map) {
		RecobroDDTipoRepartoSubcartera ddTipoReparto;
		
		List<RecobroAgencia> agencias = proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgencias();
		
		RecobroSubCartera subCartera = new RecobroSubCartera();		
		if (!Checks.esNulo(idSubCartera)) {
			subCartera = proxyFactory.proxy(RecobroSubCarteraApi.class).getRecobroSubCartera(idSubCartera);
			
			ddTipoReparto = subCartera.getTipoRepartoSubcartera();
			if (Checks.esNulo(idCarteraEsquema)){
				idCarteraEsquema=subCartera.getCarteraEsquema().getId();
			}
		} else {
			idSubCartera = -1L;
			
			ddTipoReparto = (RecobroDDTipoRepartoSubcartera) proxyFactory.proxy(DiccionarioApi.class).
					dameValorDiccionarioByCod(RecobroDDTipoRepartoSubcartera.class, codTipoReparto);
		}
		
		map.put("idCarteraEsquema", idCarteraEsquema);
		map.put("idSubCartera", idSubCartera);
		map.put("subCartera", subCartera);
		map.put("agencias", agencias);
		map.put("ddTipoReparto", ddTipoReparto);	
		map.put("REP_ESTATICO", RecobroCommonEsquemasConstants.RCF_REPARTO_SUBCARTERAS_ESTATICO);
		map.put("REP_DINAMICO", RecobroCommonEsquemasConstants.RCF_REPARTO_SUBCARTERAS_DINAMICO);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_SUBCARTERAS_ABRIR_REPARTOAGENCIAS;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String abrirFrmRepartoAgenciasVisualizar(Long idCarteraEsquema, Long idSubCartera, String codTipoReparto,boolean disable, ModelMap map) {
		RecobroDDTipoRepartoSubcartera ddTipoReparto;
		
		List<RecobroAgencia> agencias = proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgencias();
		
		RecobroSubCartera subCartera = new RecobroSubCartera();		
		if (!Checks.esNulo(idSubCartera)) {
			subCartera = proxyFactory.proxy(RecobroSubCarteraApi.class).getRecobroSubCartera(idSubCartera);
			
			ddTipoReparto = subCartera.getTipoRepartoSubcartera();
			if (Checks.esNulo(idCarteraEsquema)){
				idCarteraEsquema=subCartera.getCarteraEsquema().getId();
			}
		} else {
			idSubCartera = -1L;
			
			ddTipoReparto = (RecobroDDTipoRepartoSubcartera) proxyFactory.proxy(DiccionarioApi.class).
					dameValorDiccionarioByCod(RecobroDDTipoRepartoSubcartera.class, codTipoReparto);
		}
		
		map.put("idCarteraEsquema", idCarteraEsquema);
		map.put("idSubCartera", idSubCartera);
		map.put("subCartera", subCartera);
		map.put("agencias", agencias);
		map.put("disable", disable);
		map.put("ddTipoReparto", ddTipoReparto);	
		map.put("REP_ESTATICO", RecobroCommonEsquemasConstants.RCF_REPARTO_SUBCARTERAS_ESTATICO);
		map.put("REP_DINAMICO", RecobroCommonEsquemasConstants.RCF_REPARTO_SUBCARTERAS_DINAMICO);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_SUBCARTERAS_ABRIR_REPARTOAGENCIAS;
	}
	
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String buscaSubCarterasAgencias(Long idSubCartera, ModelMap map) {

 		List<? extends RecobroSubcarteraAgencia> subCarteraAgencias=proxyFactory.proxy(RecobroEsquemaApi.class).getSubCarterasAgencias(idSubCartera);
		map.put("subCarAgencias", subCarteraAgencias);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERAS_AGENCIA_JSON;
		
		
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String buscaSubCarterasRanking(Long idSubCartera, ModelMap map) {

 		List<? extends RecobroSubcarteraRanking> subCarteraRanking=proxyFactory.proxy(RecobroEsquemaApi.class).getSubCarterasRanking(idSubCartera);
		map.put("subCarRanking", subCarteraRanking);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERAS_RANKING_JSON;
		
		
	}	

	/**
	 * 
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String saveSubCartera(RecobroSubcarAgenciaDto dto, ModelMap map) {
		if (!Checks.esNulo(dto.getReparto())) {
			ObjectMapper mapper = new ObjectMapper();
			RecobroSubcarteraAgenciasGrid gridItems = null;
			try {
				dto.setReparto(HtmlUtils.htmlUnescape(dto.getReparto()));
				gridItems = mapper.readValue(dto.getReparto(), RecobroSubcarteraAgenciasGrid.class);
			} catch (Exception e) {
				logger.error(e);
				return null;
			}
			
			if (!Checks.esNulo(gridItems)) {
				proxyFactory.proxy(RecobroEsquemaApi.class).guardarAgenciasSubcartera(dto, gridItems);
			}
			
			return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
		}
		return null;
	}
	

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String borrarRepartoSubCartera(Long idSubCartera, ModelMap map) {
		proxyFactory.proxy(RecobroSubCarteraApi.class).borrarSubCartera(idSubCartera);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String openSimulacion(Long idEsquema, ModelMap map) {
		RecobroSimulacionEsquema esquemaSimulacion = proxyFactory.proxy(RecobroEsquemaApi.class).getSimulacion(idEsquema);
		map.put("idEsquema", idEsquema);
		map.put("simulacion", esquemaSimulacion);
		
		if (!Checks.esNulo(esquemaSimulacion)) {
			// Formateo de las fechas para mostrarlas
			SimpleDateFormat formatFecha = new SimpleDateFormat("dd/MM/yyyy");
			SimpleDateFormat formatHora = new SimpleDateFormat("HH:mm");
			
			if (!Checks.esNulo(esquemaSimulacion.getFechaPeticion()))
				map.put("fechaPeticionFormat", formatFecha.format(esquemaSimulacion.getFechaPeticion()));
			if (!Checks.esNulo(esquemaSimulacion.getFechaResultado()))
				map.put("fechaResultadoFormat", formatFecha.format(esquemaSimulacion.getFechaResultado()));
	
			if (!Checks.esNulo(esquemaSimulacion.getFechaPeticion()))
				map.put("horaPeticionFormat", formatHora.format(esquemaSimulacion.getFechaPeticion()));
			if (!Checks.esNulo(esquemaSimulacion.getFechaResultado()))
				map.put("horaResultadoFormat", formatHora.format(esquemaSimulacion.getFechaResultado()));
		}
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_OPEN_SIMULACION;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String descargarFichero(Long idEsquema, String tipoFichero, ModelMap map) {
		FileItem fichero = proxyFactory.proxy(RecobroEsquemaApi.class).getFicheroSimulacion(idEsquema, tipoFichero);
		
		map.put("fileItem", fichero);
		
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_JSP_DOWNLOAD_FILE;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String copiarEsquema(Long idEsquema, ModelMap map) {
		
		proxyFactory.proxy(RecobroEsquemaApi.class).copiaEsquema(idEsquema, true);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String getUltimaVersionEsquema(Long idEsquema, ModelMap map) {
		RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getUltimaVersionDelEsquema(idEsquema);
		map.put("esquema", esquema);
		return RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_ESQUEMA_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String liberarEsquemaRecobro(Long idEsquema, ModelMap map) {
		
		proxyFactory.proxy(RecobroEsquemaApi.class).cambiarEstadoRecobroEsquema(idEsquema, RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTELIBERAR);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_ESQUEMA")
	public String cambiarEstadoDefinicion(Long idEsquema, ModelMap map) {
		proxyFactory.proxy(RecobroEsquemaApi.class).cambiarEstadoRecobroEsquema(idEsquema, RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION);
		
		return RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT;
	}

}
