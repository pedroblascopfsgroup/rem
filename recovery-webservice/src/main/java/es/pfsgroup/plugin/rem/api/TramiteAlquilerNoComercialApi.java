package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.DtoTiposAlquilerNoComercial;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface TramiteAlquilerNoComercialApi {
	
	Boolean existeTareaT018Scoring(TareaExterna tareaExterna);

	String getCodigoSubtipoOfertaByIdExpediente(Long idExpediente);

	DtoTiposAlquilerNoComercial getInfoCaminosAlquilerNoComercial(Long idExpediente);

	String avanzaScoringBC(TareaExterna tareaExterna, String codigo);

	boolean existeExpedienteComercialByNumExpediente(TareaExterna tareaExterna, String expedienteAnterior);

	boolean isExpedienteFirmado(TareaExterna tareaExterna, String expedienteAnterior);

	boolean isTramiteT018Aprobado(List<String> tareasActivas);

	boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco);
	
	String avanzaAprobarPbcAlquiler(TareaExterna tareaExterna);

	boolean isExpedienteDelMismoActivo(TareaExterna tareaExterna, String expedienteAnterior);

	String avanzaScoring(TareaExterna tareaExterna, String comboReqAnalisisTec);
	
	boolean esAlquilerSocial (TareaExterna tareaExterna);
	
	boolean esSubrogacionCompraVenta (TareaExterna tareaExterna);
	
	boolean noEsSubrogacion (TareaExterna tareaExterna);
	
	boolean esRenovacion (TareaExterna tareaExterna);
	
	boolean esSubrogacionHipoteca (TareaExterna tareaExterna);
		
	boolean conAdenda(TareaExterna tareaExterna, String tipoAdenda);
	
	boolean esCarteraConcentrada(TareaExterna tareaExterna);
	
	boolean isAdendaVacio(TareaExterna tareaExterna);
	
	boolean firmaMenosTresVeces(TareaExterna tareaExterna);

	void saveHistoricoFirmaAdenda(DtoTareasFormalizacion dto, Oferta oferta);

	boolean modificarFianza(ExpedienteComercial eco);
	
	boolean rechazaMenosTresVeces(TareaExterna tareaExterna);

	boolean estanCamposRellenosParaFormalizacion(ExpedienteComercial eco);

	boolean estanCamposParaDefinicionOfertaRellenos(ExpedienteComercial eco);
}

