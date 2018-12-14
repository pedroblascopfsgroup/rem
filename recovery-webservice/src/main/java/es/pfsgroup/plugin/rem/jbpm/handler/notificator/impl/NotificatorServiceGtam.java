package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

public class NotificatorServiceGtam extends NotificatorServiceSancionOfertaGenerico implements NotificatorService {

	private static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
	private static final String NPLREO_SUPPORT = "NPLREOSupport";
	private static final String MAILTRACKER_SUPPORT = "MailTracker";

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

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
		ExpedienteComercial expediente = getExpedienteComercial(tramite);
		Oferta oferta = expediente.getOferta();

		if (oferta != null && oferta.getActivoPrincipal() != null
				&& DDCartera.CODIGO_CARTERA_GIANTS.equals(oferta.getActivoPrincipal().getCartera())) {
			Usuario nPLREOSupport = genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "username", NPLREO_SUPPORT));
			Usuario mailTracker = genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "username", MAILTRACKER_SUPPORT));
			String titulo = "La Oferta #numoferta ha sido aceptada";
			String contenido = "<p> Le informamos que la citada propuesta ha sido CONTRAOFERTADA por un importe de #importeContraoferta.</p>"
					+ "<p> Quedamos a su disposición para cualquier consulta o aclaración.</p>"
					+ "<p> Saludos cordiales.</p>" + "<p> Fdo: #gestorTarea </p>" + "<p> Email: #mailGestorTarea </p>";

			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			mailsCC.add(this.getCorreoFrom());

			List<Usuario> usuarios = new ArrayList<Usuario>();
			if (!Checks.esNulo(nPLREOSupport)) {
				usuarios.add(nPLREOSupport);
			}
			if (!Checks.esNulo(mailTracker)) {
				usuarios.add(mailTracker);
			}

			mailsPara = getEmailsNotificacion(usuarios);

			titulo = titulo.replace("#numoferta", oferta.getNumOferta().toString());

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}

	}

	private List<String> getEmailsNotificacion(List<Usuario> usuarios) {
		List<String> mailsPara = new ArrayList<String>();
		for (Usuario usuario : usuarios) {
			if (usuario != null && !Checks.esNulo(usuario.getEmail())) {
				mailsPara.add(usuario.getEmail());
			}
		}
		return mailsPara;
	}

	private ExpedienteComercial getExpedienteComercial(ActivoTramite tramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(tramite.getId());

		if (activoTramite == null) {
			return null;
		}

		Trabajo trabajo = activoTramite.getTrabajo();

		if (trabajo == null) {
			return null;
		}

		ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());

		if (expediente == null) {
			return null;
		}

		return expediente;
	}

}
