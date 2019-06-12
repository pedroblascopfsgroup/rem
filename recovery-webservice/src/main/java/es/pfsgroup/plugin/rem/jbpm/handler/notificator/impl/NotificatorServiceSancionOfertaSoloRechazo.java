package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.List;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class NotificatorServiceSancionOfertaSoloRechazo extends NotificatorServiceSancionOfertaGenerico implements NotificatorService{

	private static final String CODIGO_T013_FIRMA = "T013_FirmaPropietario";
	private static final String CODIGO_T013_RES_TANTEO = "T013_ResolucionTanteo";
	private static final String CODIGO_T013_RES_EXPEDIENTE = "T013_ResolucionExpediente";
	private static final String CODIGO_T013_RES_PBC = "T013_ResultadoPBC";
	private static final String CODIGO_T013_DEV_LLAVES = "T013_DevolucionLlaves";
	private static final String CODIGO_T017_RESPUESTA_OFERTANTE_PM = "T017_RespuestaOfertantePM";
	private static final String CODIGO_T017_RESOLUCION_PRO_MANZANA = "T017_ResolucionPROManzana";

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] {
				CODIGO_T013_FIRMA, 
				CODIGO_T013_RES_TANTEO, 
				CODIGO_T013_RES_EXPEDIENTE, 
				CODIGO_T013_RES_PBC, 
				CODIGO_T013_DEV_LLAVES,
				CODIGO_T017_RESPUESTA_OFERTANTE_PM,
				CODIGO_T017_RESOLUCION_PRO_MANZANA };
	}


	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		this.generaNotificacion(tramite, true, false);
	}

	public void notificatorFinSinTramite(Long idOferta) {
		this.generaNotificacionSinTramite(idOferta);
	}
}
