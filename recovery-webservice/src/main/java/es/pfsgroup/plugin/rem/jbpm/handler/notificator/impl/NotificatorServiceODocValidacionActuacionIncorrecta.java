package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;

@Component
public class NotificatorServiceODocValidacionActuacionIncorrecta extends AbstractNotificatorService implements NotificatorService {

	private static final String COMBO_DOCUMENTO_CORRECTO = "comboCorreccion";

	private static final String CODIGO_T002_VALIDACION_ACTUACION = "T002_ValidacionActuacion";

	@Autowired
	private GenericAdapter genericAdapter;


	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T002_VALIDACION_ACTUACION };
	}

	@Override
	public void notificator(ActivoTramite tramite) {

	}

	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {

		for (TareaExternaValor valor : valores) {
			if (COMBO_DOCUMENTO_CORRECTO.equals(valor.getNombre()) && "01".equals(valor.getValor())) {
				return;
			}
		}

		if (!Checks.esNulo(tramite.getTrabajo().getProveedorContacto().getUsuario()) && !Checks.esNulo(tramite.getTrabajo().getProveedorContacto().getUsuario().getEmail())) {

			// Notificacion al proveedor
			Usuario proveedor = null;
			if (!Checks.esNulo(tramite.getTrabajo())) {
				proveedor = tramite.getTrabajo().getProveedorContacto().getUsuario();
			}

			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();

			String correos = proveedor.getEmail();
			Collections.addAll(mailsPara, correos.split(";"));
			mailsCC.add(this.getCorreoFrom());

			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion()) ? (tramite.getTrabajo().getDescripcion() + " - ") : "";

			dtoSendNotificator.setTitulo("Notificación obtención incorrecta de documento en REM");
			String contenido = "<p>La ejecución del encargo cuyos datos figuran en el cuadro superior no ha sido validada satisfactoriamente por el siguiente motivo: 'MOTIVO INCORRECCIÓN SELECCIONADO EN LA TAREA'. Por favor, entre en la aplicación REM y realice la tarea correspondiente. Gracias.</p>";
			String titulo = "Notificación obtención incorrecta de documento en REM (" + descripcionTrabajo + "Nº Trabajo " + dtoSendNotificator.getNumTrabajo() + ")";

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
	}

}
