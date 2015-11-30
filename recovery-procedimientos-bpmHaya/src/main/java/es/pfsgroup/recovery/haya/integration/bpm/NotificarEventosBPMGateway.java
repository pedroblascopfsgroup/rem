package es.pfsgroup.recovery.haya.integration.bpm;

import org.springframework.integration.annotation.Gateway;
import org.springframework.integration.annotation.Header;

import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.integration.TypePayload;

public interface NotificarEventosBPMGateway {

	@Gateway
	void enviar(Convenio convenio,
			@Header(TypePayload.HEADER_MSG_TYPE) String type
			, @Header(TypePayload.HEADER_MSG_ENTIDAD) Long entidad
			);

	@Gateway
	void enviar(ActualizarRiesgoOperacionalDto riesgoOperacional,
			@Header(TypePayload.HEADER_MSG_TYPE) String type
			, @Header(TypePayload.HEADER_MSG_ENTIDAD) Long entidad);	
}
