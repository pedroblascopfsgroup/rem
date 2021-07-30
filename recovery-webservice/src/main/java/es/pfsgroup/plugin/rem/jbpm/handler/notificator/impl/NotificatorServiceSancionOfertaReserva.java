package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class NotificatorServiceSancionOfertaReserva extends NotificatorServiceSancionOfertaGenerico implements NotificatorService{
	
	public static final String CODIGO_T017_OBTENCION_CONTRATO_RESERVA = "T017_ObtencionContratoReserva";
	private static final String FECHA_FIRMA = "fechaFirma";
	private static final String COMBO_QUITAR = "comboQuitar";
	SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_OBTENCION_CONTRATO_RESERVA};
	}


	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		Date fechaFirma = null;
		
		for(TareaExternaValor valor: valores) {
			if (COMBO_QUITAR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.NO.equals(valor.getValor())) {
					if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						try {
							fechaFirma = formato.parse(valor.getValor());
						} catch (ParseException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
		
		this.generaNotificacionReserva(tramite, fechaFirma);
		
	}

}
