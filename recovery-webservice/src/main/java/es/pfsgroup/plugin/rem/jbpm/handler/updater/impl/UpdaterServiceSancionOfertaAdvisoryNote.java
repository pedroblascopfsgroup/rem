package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaAceptacionYRechazo;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public class UpdaterServiceSancionOfertaAdvisoryNote implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private NotificatorServiceSancionOfertaAceptacionYRechazo notificatorServiceSancionOfertaAceptacionYRechazo;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAdvisoryNote.class);

	private static final String CODIGO_T017_ADVISORY_NOTE = "T017_AdvisoryNote";
	private static final String FECHA_ENVIO_ADVISORY_NOTE = "fechaEnvio";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		if (!Checks.esNulo(ofertaAceptada) && !Checks.esNulo(expediente)) {
			for (TareaExternaValor valor : valores) {
				if (FECHA_ENVIO_ADVISORY_NOTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					try {
						expediente.setFechaEnvioAdvisoryNote(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						e.printStackTrace();
					}
				}
			}
		}
		//Generamos notificacion de llegada a la siguiente tarea
		notificatorServiceSancionOfertaAceptacionYRechazo.generaNotificacionLlegadaDesdeUpdater(tramite, true, CODIGO_T017_ADVISORY_NOTE);
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_ADVISORY_NOTE };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}