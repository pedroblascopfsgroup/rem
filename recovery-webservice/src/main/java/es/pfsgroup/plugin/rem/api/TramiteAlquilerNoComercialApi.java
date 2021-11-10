package es.pfsgroup.plugin.rem.api;

import java.util.List;
import java.util.Map;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.DtoTiposAlquilerNoComercial;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

public interface TramiteAlquilerNoComercialApi {
	
	String avanzaAprobarPbcAlquiler(TareaExterna tareaExterna);

	String getCodigoSubtipoOfertaByIdExpediente(Long idExpediente);

	DtoTiposAlquilerNoComercial getInfoCaminosAlquilerNoComercial(Long idExpediente);

	String avanzaScoringBC(TareaExterna tareaExterna);

	boolean existeExpedienteComercialByNumExpediente(TareaExterna tareaExterna, String expedienteAnterior);

	boolean isExpedienteTipoAlquilerNoComercial(TareaExterna tareaExterna, String expedienteAnterior);

	boolean isExpedienteFirmado(TareaExterna tareaExterna, String expedienteAnterior);

	boolean isTramiteT018Aprobado(List<String> tareasActivas);

	boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco);
	
}

