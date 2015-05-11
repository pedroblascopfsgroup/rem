package es.pfsgroup.recovery.recobroWeb.accionesExtrajudiciales.controller.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.manager.api.RecobroAccionesExtrajudicialesManagerApi;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroAccionesExtrajudiciales;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDResultadoGestionTelefonica;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDTipoGestion;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.dto.AdecuacionesDto;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.manager.api.AdecuacionesApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.manager.CicloRecobroExpedienteApi;
import es.pfsgroup.recovery.recobroCommon.expediente.manager.ExpedienteRecobroApi;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpediente;
import es.pfsgroup.recovery.recobroWeb.accionesExtrajudiciales.controller.api.AccionesExtrajudicialesControllerApi;
import es.pfsgroup.recovery.recobroWeb.utils.RecobroWebConstants.AccionesExtrajudicialesConstants;

@SuppressWarnings("unchecked")
@Controller
public class AccionesExtrajudicialesController implements AccionesExtrajudicialesControllerApi {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;
	
	@Autowired
	private RecobroAccionesExtrajudicialesManagerApi accionesExjudApi;
	
	@Autowired
	private AdecuacionesApi adecuacionesApi;

	@RequestMapping
	public String abrirNuevaVentanaAccionesExpediente(ModelMap model, Long id) {

		RecobroAccionesExtrajudiciales acc = accionesExjudApi.getAccionExtrajudicialById(id);
		model.put("acc", acc);
		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_DETALLE_ACCION;
	}

	@RequestMapping
	public String abrirVentanaAccionesExpediente(ModelMap model) {

		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_LISTADO_ACCIONES;
	}

	@Override
	@RequestMapping
	public String getAccionesCicloRecobroContrato(RecobroAccionesExtrajudicialesDto dto, ModelMap model) {
		Page accionesCnt = accionesExjudApi.getPageAccionesCicloRecobroContrato(dto);
		model.put("accionesExjud", accionesCnt);
		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_CONTRATO_JSON;
	}

	@Override
	@RequestMapping
	public String getAccionesCicloRecobroPersona(RecobroAccionesExtrajudicialesDto dto, ModelMap model) {
		Page accionesPer = accionesExjudApi.getPageAccionesCicloRecobroPersona(dto);
		model.put("accionesExjud", accionesPer);
		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_CONTRATO_JSON;
	}

	@Override
	@RequestMapping
	public String getAccionesExpediente(RecobroAccionesExtrajudicialesExpedienteDto dto, ModelMap model) {
		Page accionesExjud = accionesExjudApi.getPageAccionesRecobroExpedientePorTipoUsuario(dto);
		model.put("accionesExjud", accionesExjud);
		
		
//		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
//		model.put("usuario", usuario);
//		
//		List<RecobroAgencia> agencias = proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgenciasDeUsuario(usuario.getId());
//		RecobroAgencia miAgencia= null;
//		
//		if (!Checks.esNulo(agencias) && !Checks.estaVacio(agencias)){
//			miAgencia=agencias.get(0);
//		}
//		
//		model.put("miAgencia", miAgencia);
//		model.put("esAgencia", accionesExjudApi.esAgencia(usuario.getId()));
		
		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_EXPEDIENTE_JSON;
	}

	@Override
	@RequestMapping
	public String getDetalleAccionesExpediente(Long idAccionExtrajudicial, ModelMap model) {
		RecobroAccionesExtrajudiciales accionExp = accionesExjudApi.getAccionExtrajudicial(idAccionExtrajudicial);
		model.put("accionExp", accionExp);
		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_EXPEDIENTE_DETALLE_JSON;
	}

	@RequestMapping
	public String getListadoCicloRecobroExpediente(Long idExpediente, ModelMap model) {

		CicloRecobroExpedienteDto dto = new CicloRecobroExpedienteDto();
		Page ciclosExp = proxyFactory.proxy(CicloRecobroExpedienteApi.class).getPageCicloRecobroExpediente(dto);
		List<CicloRecobroExpediente> listado = (List<CicloRecobroExpediente>) ciclosExp.getResults();
		model.put("listado", listado);

		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_DEFAULT_JSON;
	}

	@RequestMapping
	public String getListadoAgencias(ModelMap model) {

		List<RecobroAgencia> listado = proxyFactory.proxy(ExpedienteRecobroApi.class).getAgenciasRecobroUsuario();
		model.put("listado", listado);

		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_LISTADO_AGENCIAS;
	}

	@RequestMapping
	public String getListadoTipoGestion(ModelMap model) {

		List<RecobroDDTipoGestion> listado = accionesExjudApi.getListadoTipoGestion();
		model.put("listado", listado);

		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_DEFAULT_JSON;
	}

	@RequestMapping
	public String getListadoTipoResultado(ModelMap model) {

		List<RecobroDDResultadoGestionTelefonica> listado = accionesExjudApi.getListadoTipoResultado();
		model.put("listado", listado);

		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_DEFAULT_JSON;
	}

	@RequestMapping
	public String getListadoCiclosRecobroExpediente(Long idExpediente, ModelMap model) {

		List<CicloRecobroExpediente> listado = accionesExjudApi.getListadoCiclosRecobroExpediente(idExpediente);
		model.put("listado", listado);

		return AccionesExtrajudicialesConstants.RECOBROWEB_ACCIONESEXTRAJUDICIALES_CICLO_RECOBRO_EXPEDIENTE;
	}

	@RequestMapping
	public String getAdecuaciones(WebRequest request, ModelMap model) {
		Map params = request.getParameterMap();
		AdecuacionesDto dto = new AdecuacionesDto();
		String limit = null;
		String start = null;
		String idContrato = null;
		if(params.get("limit") != null){
			limit = ((String[])params.get("limit"))[0];
			dto.setLimit(Integer.valueOf(limit));
		}
		if(params.get("start") != null){
			start = ((String[])params.get("start"))[0];
			dto.setStart(Integer.valueOf(start));
		}
		if(params.get("idContrato") != null){
			idContrato = ((String[])params.get("idContrato"))[0];
			dto.setIdContrato(Long.valueOf(idContrato));
		}

		Page adecuaciones = adecuacionesApi.getListadoAdecuaciones(dto);
		model.put("adecuaciones", adecuaciones);

		return AccionesExtrajudicialesConstants.RECOBROWEB_ADECUACIONES_JSON;
	}

}
