package es.pfsgroup.recovery.recobroWeb.expediente.controller.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;


import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.contrato.dto.CicloRecobroContratoDto;
import es.pfsgroup.recovery.recobroCommon.contrato.manager.CicloRecobroContratoApi;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroContratoExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroPersonaExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.manager.CicloRecobroExpedienteApi;
import es.pfsgroup.recovery.recobroCommon.expediente.manager.ExpedienteRecobroApi;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.persona.model.CicloRecobroPersona;
import es.pfsgroup.recovery.recobroCommon.persona.dto.CicloRecobroPersonaDto;
import es.pfsgroup.recovery.recobroCommon.persona.manager.CicloRecobroPersonaApi;
import es.pfsgroup.recovery.recobroWeb.expediente.controller.api.CicloRecobroExpedienteControllerApi;
import es.pfsgroup.recovery.recobroWeb.utils.RecobroWebConstants.RecobroWebExpedienteConstants;

@Controller
public class CicloRecobroExpedienteController implements
		CicloRecobroExpedienteControllerApi {

	@Autowired
	private CicloRecobroExpedienteApi cicloRecobroExpApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Override
	@RequestMapping
	public String getCicloRecExp(CicloRecobroExpedienteDto dto, WebRequest request,
			ModelMap model) { 
		
		Page ciclosRecExp = cicloRecobroExpApi.getPageCicloRecobroExpedienteTipoUsuario(dto);
		model.put("ciclosRecExp", ciclosRecExp);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_CICLORECOBRO_EXPEDIENTE_JSON;
	}

	@Override
	@RequestMapping
	public String getCicloRecCnt(CicloRecobroContratoDto dto, WebRequest request,
			ModelMap model) {
		Page ciclosRecCnt = proxyFactory.proxy(CicloRecobroContratoApi.class).getPageCicloRecobroContrato(dto);
		model.put("ciclosRecCnt", ciclosRecCnt);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_CICLORECOBRO_CONTRATO_JSON;
	}

	@Override
	@RequestMapping
	public String getCicloRecPer(CicloRecobroPersonaDto dto, WebRequest request,
			ModelMap model) {
		Page ciclosRecPer = proxyFactory.proxy(CicloRecobroPersonaApi.class).getPageCicloRecobroPersona(dto);
		model.put("ciclosRecPer", ciclosRecPer);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_CICLORECOBRO_PERSONA_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	public String getClientesExpedienteRecobro(Long id, ModelMap map) {
		
		List<CicloRecobroPersonaExpedienteDto> clientes =cicloRecobroExpApi.dameListaMapeadaCiclosRecobroPersonaExpediente(id);
		
		map.put("clientes", clientes);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_CICLORECOBRO_PERSONAEXPEDIENTE_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	public String getCiclosRecobroPersonaExpediente(Long idExpediente,
			Long idPersona, ModelMap map) {
		List<CicloRecobroPersona> ciclosRecobroContrato = cicloRecobroExpApi.getListCiclosRecobroPersonaExpediente(idExpediente, idPersona);
		map.put("ciclosRecobroContrato", ciclosRecobroContrato);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_CICLORECOBRO_PERSONA_JSON ;
	}

	@Override
	@RequestMapping
	public String getContratosExpedienteRecobro(Long id, ModelMap map) {
		List<CicloRecobroContratoExpedienteDto> contratosRecobro = cicloRecobroExpApi.dameListaMapeadaCiclosRecobroContratoExpediente(id);
		map.put("contratosRecobro",contratosRecobro);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_CICLORECOBRO_CONTRATOEXPEDIENTE_JSON;
	}

}
