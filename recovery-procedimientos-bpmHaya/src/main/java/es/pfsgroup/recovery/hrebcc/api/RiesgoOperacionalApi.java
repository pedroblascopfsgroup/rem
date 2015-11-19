package es.pfsgroup.recovery.hrebcc.api;

import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.model.DDRiesgoOperacional;

public interface RiesgoOperacionalApi {

	public void ActualizarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto);
	public DDRiesgoOperacional ObtenerRiesgoOperacionalContrato(Long cntId);
}
