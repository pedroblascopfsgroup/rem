package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.List;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class NotificatorServiceSancionOfertaAceptacionYRechazo extends NotificatorServiceSancionOfertaGenerico implements NotificatorService{

	private static final String CODIGO_T013_RESPUESTA_OFERTANTE = "T013_RespuestaOfertante";
	private static final String CODIGO_T013_RATIFICACION_COMITE_EXTERNO = "T013_RatificacionComite";
	private static final String CODIGO_T017_RESPUESTA_OFERTANTE_CES = "T017_RespuestaOfertanteCES";

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { 
			CODIGO_T013_RESPUESTA_OFERTANTE, 
			CODIGO_T013_RATIFICACION_COMITE_EXTERNO,
			CODIGO_T017_RESPUESTA_OFERTANTE_CES
		};
	}

	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		this.generaNotificacion(tramite, true, true, false, null);
	}

	public void notificatorFinSinTramite(Long idOferta) {
		this.generaNotificacionSinTramite(idOferta);
	}
}
