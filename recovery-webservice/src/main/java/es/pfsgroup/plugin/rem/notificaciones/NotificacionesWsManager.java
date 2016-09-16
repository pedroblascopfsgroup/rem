package es.pfsgroup.plugin.rem.notificaciones;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.rest.dto.NotificacionDto;

@Service("notificacionesManager")
public class NotificacionesWsManager {

	@Autowired
	private GenericABMDao genericDao;

	/**
	 * Valida la notificacion
	 * 
	 * @param notificacion
	 * @return
	 */
	public List<String> validateNotificacionRequest(NotificacionDto notificacion) {
		List<String> errorsList = new ArrayList<String>();

		if (notificacion.getFechaAccion() == null) {
			errorsList.add("Fecha acción no puede ser null");
		}

		if (!Checks.esNulo(notificacion.getIdUsuarioRemAccion())) {
			Usuario user = (Usuario) genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "id", notificacion.getIdUsuarioRemAccion()));
			if (Checks.esNulo(user)) {
				errorsList.add("No existe el usuario en REM especificado en el campo IdUsuarioRemAccion: "
						+ notificacion.getIdUsuarioRemAccion());
			}
		} else {
			errorsList.add("IdUsuarioRemAccion no puede ser null");
		}

		if (notificacion.getCodTipoNotificacion() == null || (!notificacion.getCodTipoNotificacion().equals("N")
				&& !notificacion.getCodTipoNotificacion().equals("A"))) {
			errorsList.add("CodTipoNotificacion es obligatorio. Valores posibles: N,notificación y A,aviso");
		} else {
			if (notificacion.getCodTipoNotificacion().equals("N") && notificacion.getFechaRealizacion() == null) {
				errorsList.add("La fecha de realización es obligatoria para las notificaciones");
			} else if (notificacion.getCodTipoNotificacion().equals("A") && notificacion.getFechaRealizacion() != null) {
				errorsList.add("Los avisos no tiene fecha de realización");
			}
		}

		if (notificacion.getTitulo() == null || notificacion.getTitulo().isEmpty()) {
			errorsList.add("el campo titulo es obligatorio");
		}
		if (notificacion.getDescripcion() == null || notificacion.getDescripcion().isEmpty()) {
			errorsList.add("el campo titulo es obligatorio");
		}
		if (Checks.esNulo(notificacion.getIdActivoHaya())) {
			errorsList.add("el campo IdActivoHaya es obligatorio");
		}

		return errorsList;
	}

}
