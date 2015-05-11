package es.pfsgroup.recovery.recobroWeb.accionesExtrajudiciales.controller.api;

import java.util.Map;

import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesExpedienteDto;

public interface ExportarCSVRecobroControllerApi {

	public String getAccionesExpedienteCSV(RecobroAccionesExtrajudicialesExpedienteDto dto, Map<String, Object> model);
}
