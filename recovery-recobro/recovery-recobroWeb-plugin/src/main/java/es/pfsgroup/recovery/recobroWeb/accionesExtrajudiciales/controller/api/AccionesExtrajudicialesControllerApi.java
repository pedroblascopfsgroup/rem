package es.pfsgroup.recovery.recobroWeb.accionesExtrajudiciales.controller.api;

import org.springframework.ui.ModelMap;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.dto.AdecuacionesDto;

public interface AccionesExtrajudicialesControllerApi {
	
	String getAccionesCicloRecobroContrato(RecobroAccionesExtrajudicialesDto dto, ModelMap model);
	
	String getAccionesCicloRecobroPersona(RecobroAccionesExtrajudicialesDto dto, ModelMap model);	
	
	String getAccionesExpediente(RecobroAccionesExtrajudicialesExpedienteDto dto, ModelMap model);
	
	String getAdecuaciones(WebRequest request, ModelMap model);
	
	String getDetalleAccionesExpediente(Long id, ModelMap model);
	
}
