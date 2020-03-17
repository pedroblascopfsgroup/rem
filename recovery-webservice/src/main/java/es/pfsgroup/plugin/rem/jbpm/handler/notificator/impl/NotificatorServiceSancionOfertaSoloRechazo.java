package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.List;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;

@Component
public class NotificatorServiceSancionOfertaSoloRechazo extends NotificatorServiceSancionOfertaGenerico implements NotificatorService{

	private static final String CODIGO_T013_FIRMA = "T013_FirmaPropietario";
	private static final String CODIGO_T013_RES_TANTEO = "T013_ResolucionTanteo";
	private static final String CODIGO_T013_RES_EXPEDIENTE = "T013_ResolucionExpediente";
	private static final String CODIGO_T013_RES_PBC = "T013_ResultadoPBC";
	private static final String CODIGO_T013_DEV_LLAVES = "T013_DevolucionLlaves";
	private static final String CODIGO_T017_RESPUESTA_OFERTANTE_PM = "T017_RespuestaOfertantePM";
	private static final String CODIGO_T017_RESOLUCION_PRO_MANZANA = "T017_ResolucionPROManzana";
	private static final String CODIGO_T017_RECOMENDACION_CES = "T017_RecomendCES";
	private static final String CODIGO_T017_PBC_RESERVA = "T017_PBCReserva";
	private static final String CODIGO_T017_RES_EXPEDIENTE = "T017_ResolucionExpediente";
	private static final String CODIGO_T017_PBC_VENTA = "T017_PBCVenta";
	private static final String CODIGO_T013_PBC_RESERVA = "T013_PBCReserva";
	private static final String COMBO_RESOLUCION = "comboRespuesta";

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
				CODIGO_T017_RESOLUCION_PRO_MANZANA,
				CODIGO_T017_RECOMENDACION_CES,
				CODIGO_T017_PBC_RESERVA,
				CODIGO_T017_RES_EXPEDIENTE,
				CODIGO_T017_PBC_VENTA,
				CODIGO_T013_PBC_RESERVA};
	}


	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		Boolean correoLlegadaTarea = false;
		Boolean aprueba = false;
		String codTareaActual = null;
		Boolean permiteRechazar = true;
		
		if(!Checks.esNulo(valores)) {
			for (TareaExternaValor valor : valores) {
				if (COMBO_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					aprueba = DDApruebaDeniega.CODIGO_APRUEBA.equals(valor.getValor()) ? true : false;
					break;
				}
			}
			
			if(CODIGO_T017_RESPUESTA_OFERTANTE_PM.equals(valores.get(0).getTareaExterna().getTareaProcedimiento().getCodigo()) && aprueba) {
				correoLlegadaTarea = true;
				codTareaActual = valores.get(0).getTareaExterna().getTareaProcedimiento().getCodigo();
			}
		}
		
		this.generaNotificacion(tramite, permiteRechazar, false, correoLlegadaTarea, codTareaActual);
	}

	public void notificatorFinSinTramite(Long idOferta) {
		this.generaNotificacionSinTramite(idOferta);
	}
}
