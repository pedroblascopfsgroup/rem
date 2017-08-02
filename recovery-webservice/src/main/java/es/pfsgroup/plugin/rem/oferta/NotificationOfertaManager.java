package es.pfsgroup.plugin.rem.oferta;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

/**
 * Notificacion por correo cuando una nueva oferta llegue
 * 
 * HREOS-2044
 */
@Service
public class NotificationOfertaManager extends AbstractNotificatorService {

	private final Log logger = LogFactory.getLog(this.getClass());

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private GestorActivoApi gestorActivoManager;

	/**
	 * Cada vez que llegue una oferta de un activo, 
	 * se enviará una notificación (correo) al gestor comercial correspondiente, 
	 * con independencia de que dicha oferta se muestre en el listado de ofertas del módulo comercial en el estado que corresponda (pendiente o congelada).
	 * 
	 * @param tramite
	 */
	public void sendNotification(Oferta oferta) {

		Usuario usuario = null;
		Activo activo = oferta.getActivoPrincipal();

		if (!Checks.esNulo(oferta.getAgrupacion()) && !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion() != null)) {
			if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo()) && oferta.getAgrupacion() instanceof ActivoLoteComercial) {
				ActivoLoteComercial activoLoteComercial = (ActivoLoteComercial) oferta.getAgrupacion();
				usuario = activoLoteComercial.getUsuarioGestorComercial();
			} else {
				// Lote Restringido
				usuario = gestorActivoManager.getGestorByActivoYTipo(activo, "GCOM");
			}
		} else {
			// por activo
			usuario = gestorActivoManager.getGestorByActivoYTipo(activo, "GCOM");
		}

		if (activo != null && usuario != null) {

			String titulo = "Solicitud de oferta para compra del inmueble con referencia: " + activo.getNumActivo();

			DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();

			dtoSendNotificator.setNumActivo(activo.getNumActivo());
			dtoSendNotificator.setDireccion(generateDireccion(activo));
			dtoSendNotificator.setTitulo(titulo);

			if(!Checks.esNulo(oferta.getAgrupacion())) {
				dtoSendNotificator.setNumAgrupacion(oferta.getAgrupacion().getNumAgrupRem());	
			}

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();

			mailsPara.add(usuario.getEmail());
			mailsCC.add(this.getCorreoFrom());

			String contenido = 
					String.format("<p>Ha recibido una nueva oferta con número identificador %s, a nombre de %s, por importe de %s €.</p>", 
							oferta.getNumOferta().toString(), oferta.getCliente().getNombreCompleto(), NumberFormat.getNumberInstance(new Locale("es", "ES")).format(oferta.getImporteOferta()));

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
	}

	
}
