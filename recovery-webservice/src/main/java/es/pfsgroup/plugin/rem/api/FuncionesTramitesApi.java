package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesExpediente;
import es.pfsgroup.plugin.rem.model.DtoTabFianza;
import es.pfsgroup.plugin.rem.model.DtoTipoAlquiler;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoTareaPbc;
import es.pfsgroup.plugin.rem.model.VGridHistoricoReagendaciones;

public interface FuncionesTramitesApi {

	boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna);
	
	boolean isTramiteAprobado(ExpedienteComercial eco);

	void desactivarHistoricoPbc(Long idOferta, String codigoTipoTarea);

	HistoricoTareaPbc createHistoricoPbc(Long idOferta, String codigoTipoTarea);
	
	boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco);
	
	boolean tieneMasUnaTareaBloqueo(ExpedienteComercial eco, String codigoTarea);

	boolean tieneCampoClasificacionRelleno(TareaExterna tareaExterna);
	
	List<VGridHistoricoReagendaciones> getHistoricoReagendaciones(Long idExpediente);

	boolean checkIBANValido(TareaExterna tareaExterna, String numIban);

	boolean checkCuentasVirtualesAlquilerLibres(TareaExterna tareaExterna);

	boolean checkFechaAgendacionRelleno(Long idExpediente);

	DtoCondicionantesExpediente getFianzaExonerada(Long idExpediente);

	DtoTabFianza getDtoFianza(Long idExpediente);
	
	DtoTipoAlquiler getDtoTipoAlquiler(Long idExpediente);

	boolean seNecesitaCuentaVirtualAlquiler(TareaExterna tareaExterna);
}

