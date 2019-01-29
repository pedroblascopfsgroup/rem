package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class NotificatorServiceSancionOfertaSoloAceptacion extends NotificatorServiceSancionOfertaGenerico implements NotificatorService{
	
	public static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
	
	@Autowired
	private NotificatorServiceGtam notificatorApi;

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_DEFINICION_OFERTA};
	}


	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		this.generaNotificacion(tramite, false, true);
		//gtam, solo si procede
		notificatorApi.notificatorFinTareaConValores(tramite, valores);
		
	}

	public void notificatorFinSinTramite(Long idOferta) {
		this.generaNotificacionSinTramite(idOferta);
	}

}
