package es.pfsgroup.plugin.recovery.masivo.api.impl;

import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.recovery.masivo.api.MSVCodigoPostalPlazaApi;

@Service
public class MSVCodigoPostalPlazaManager implements MSVCodigoPostalPlazaApi {

	@Override
	@BusinessOperation(PLUGIN_MASIVO_OBTENER_PLAZA_DOMICILIO)
	public String obtenerPlazaAPartirDeDomicilio(Long idAsunto) {

		return "00000";
	}

	@Override
	public int getPrioridad() {
		return 0;
	}

}
