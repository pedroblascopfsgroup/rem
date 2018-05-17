package es.pfsgroup.plugin.rem.updaterstate;

import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface UpdaterStateOfertaApi {
	
	public static final String CODIGO_TRAMITE_FINALIZADO = "11";
	
	/**
	 * Cambia los estados de la oferta, el expediente comercial, la reserva y el tramite dependiendo de la resolución de la devolución de la reserva
	 * @param codigoDevolucionReserva
	 * @param tramite
	 * @param oferta
	 * @param expedienteComercial
	 * @param codigoTramiteFinalizado
	 * @return 
	 */
	public void updaterStateDevolucionReserva(String codigoDevolucionReserva, ActivoTramite tramite, Oferta oferta, ExpedienteComercial expedienteComercial);
}
