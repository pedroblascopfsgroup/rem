package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestor.GestorExpedienteComercialManager;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Component
public class NotificatorServicePBCResultado extends AbstractNotificatorService implements NotificatorService {

	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private GestorExpedienteComercialManager gestorExpedienteComercialManager;

	@Autowired
	private GestorActivoApi gestorActivoManager;

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_RESULTADO_PBC };
	}

	@Override
	public void notificator(ActivoTramite tramite) {
		return;
	}

	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {

		String pbcEstado = "denegada";

		for (TareaExternaValor valor : valores) {
			if (COMBO_RESULTADO.equals(valor.getNombre()) && "01".equals(valor.getValor())) {
				pbcEstado = "aprobada";
			}
		}

		ExpedienteComercial expediente = getExpedienteComercial(tramite);

		if (expediente == null) {
			return;
		}

		Oferta oferta = expediente.getOferta();

		if (oferta == null) {
			return;
		}

		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

		String titulo = "Resolución PBC&FT del expediente " + expediente.getNumExpediente();

		dtoSendNotificator.setTitulo(titulo);

		String contenido = String.format("<p>Le informamos que la autorización PBC&FT de la oferta %s se ha resuelto como %s.</p>", oferta.getNumOferta(), pbcEstado);

		List<String> mailsPara = getEmailsToSend(expediente, oferta);
		List<String> mailsCC = new ArrayList<String>();

		mailsCC.add(this.getCorreoFrom());

		genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));

	}

	private List<String> getEmailsToSend(ExpedienteComercial expediente, Oferta oferta) {
		Usuario preescriptor = ofertaApi.getUsuarioPreescriptor(oferta);
		Usuario gestoriaFormalizacion = gestorExpedienteComercialManager.getGestorByExpedienteComercialYTipo(expediente, "GIAFORM");

		Usuario gestorComercial = null;
		Activo activo = oferta.getActivoPrincipal();

		if (!Checks.esNulo(oferta.getAgrupacion()) && !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion() != null)) {
			if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo()) && oferta.getAgrupacion() instanceof ActivoLoteComercial) {
				ActivoLoteComercial activoLoteComercial = (ActivoLoteComercial) oferta.getAgrupacion();
				gestorComercial = activoLoteComercial.getUsuarioGestorComercial();
			} else {
				// Lote Restringido
				gestorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, "GCOM");
			}
		} else {
			// Activo
			gestorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, "GCOM");
		}

		List<String> mailsPara = new ArrayList<String>();

		if (preescriptor != null && !Checks.esNulo(preescriptor.getEmail())) {
			mailsPara.add(preescriptor.getEmail());
		}

		if (gestoriaFormalizacion != null && !Checks.esNulo(gestoriaFormalizacion.getEmail())) {
			mailsPara.add(gestoriaFormalizacion.getEmail());
		}

		if (gestorComercial != null && !Checks.esNulo(gestorComercial.getEmail())) {
			mailsPara.add(gestorComercial.getEmail());
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

		ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByTrabajo(trabajo.getId());

		if (expediente == null) {
			return null;
		}

		return expediente;
	}

}
