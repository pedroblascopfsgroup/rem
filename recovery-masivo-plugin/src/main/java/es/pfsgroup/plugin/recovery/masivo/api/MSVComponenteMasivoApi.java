package es.pfsgroup.plugin.recovery.masivo.api;

import java.util.List;

import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResultadoOperacionMasivaDto;

public interface MSVComponenteMasivoApi {
	
	public static final String MSV_BO_EJECUTA_OPERACION_MASIVA = "plugin.masivo.componentemasivo.ejecutaOperacionMasiva";

	@BusinessOperationDefinition(MSV_BO_EJECUTA_OPERACION_MASIVA)
	MSVResultadoOperacionMasivaDto ejecutaOperacionMasiva(List<Long> lista, String nombre,
			WebRequest request);

}
