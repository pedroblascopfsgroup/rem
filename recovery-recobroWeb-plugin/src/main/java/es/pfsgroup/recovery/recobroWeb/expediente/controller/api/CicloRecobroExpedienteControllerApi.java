package es.pfsgroup.recovery.recobroWeb.expediente.controller.api;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.recovery.recobroCommon.contrato.dto.CicloRecobroContratoDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.persona.dto.CicloRecobroPersonaDto;

public interface CicloRecobroExpedienteControllerApi {
	
	String getCicloRecExp(CicloRecobroExpedienteDto dto, WebRequest request, ModelMap model);
	
	String getCicloRecCnt(CicloRecobroContratoDto dto, WebRequest request, ModelMap model);

	String getCicloRecPer(CicloRecobroPersonaDto dto, WebRequest request, ModelMap model);
	
	/**
	 * Devuelve una lista de dtos de cliente donde está el cliente asociado al expediente 
	 * junto con una lista de ciclos de recobro de ese cliente para ese expediente
	 * @param id
	 * @param map
	 * @return
	 */
	String getClientesExpedienteRecobro(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Dado un id de persona y un id de expediente devuelve la lista de ciclos de recobro para esa persona en ese expediente
	 * @param idExpediente
	 * @param idPersona
	 * @param map
	 * @return
	 */
	String getCiclosRecobroPersonaExpediente(@RequestParam(value = "idExpediente", required = true) Long idExpediente,@RequestParam(value = "idPersona", required = true) Long idPersona, ModelMap map);
	
	/**
	 * Devuelve una lista de dtos de contrato donde están los contratos asociados al expediente 
	 * junto con una lista de ciclos de recobro de cada contrato para ese expediente
	 * @param idExpediente
	 * @param map
	 * @return
	 */
	String getContratosExpedienteRecobro(@RequestParam(value = "id", required = true) Long id, ModelMap map);
}
