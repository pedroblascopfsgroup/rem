package es.pfsgroup.plugin.rem.api.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.NotificacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;

@Service("notificacionManager")
public class NotificacionManager extends BusinessOperationOverrider<NotificacionApi> implements NotificacionApi {

	protected static final Log logger = LogFactory.getLog(NotificacionManager.class);

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private AnotacionApi anotacionApi;

	@Override
	public String managerName() {
		return "notificacionManager";
	}

	@Override
	public void enviarNotificacionPorActivosAdmisionGestion(ExpedienteComercial expediente){
		List<Activo> activos = new ArrayList<Activo>();
		
		ActivoAgrupacion agrupacion = expediente.getOferta().getAgrupacion();
		
		if(agrupacion != null){
			List<ActivoAgrupacionActivo> activosAgrupacion = agrupacion.getActivos();
			for(ActivoAgrupacionActivo aaa: activosAgrupacion){
				activos.add(aaa.getActivo());
			}
		}else{
			Activo activo = expediente.getOferta().getActivoPrincipal();
			activos.add(activo);
		}
		
		enviarNotificacionKOadmisionPorActivo(activos);
		enviarNotificacionKOgestionPorActivo(activos);
	}

	@Override
	public void enviarNotificacionKOadmisionPorActivo(List<Activo> activos) {
		//Evitamos realizar el check si activos es null
		if (activos == null || activos.size() == 0) {
			return;
		}

		for (Activo activo : activos) {

			if (activo.getAdmision() != null && activo.getAdmision() == false) {
				// Se crea una notificación.
				Notificacion notifAdmisionKO = new Notificacion();
				notifAdmisionKO.setIdActivo(activo.getId());
				Usuario gestor = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ADMISION);
				notifAdmisionKO.setDestinatario(gestor.getId());
				notifAdmisionKO.setTitulo("Revisar el estado de un activo con oferta aprobada");
				notifAdmisionKO.setDescripcion(
						"Se ha aprobado una oferta de venta asociada a este activo y no consta la conformidad de su departamento. Verifique que se han cumplimentado todos los campos básicos de la pestaña \"checking de información\" del activo, así como el estado documental del mismo.");
				notifAdmisionKO.setFecha(new Date());

				try {
					// Se envía la notificación.
					anotacionApi.saveNotificacion(notifAdmisionKO);
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
		}
	}

	@Override
	public void enviarNotificacionKOgestionPorActivo(List<Activo> activos) {
		//Evitamos realizar el check si activos es null
		if (activos == null || activos.size() == 0) {
			return;
		}

		for (Activo activo : activos) {
			if (activo.getGestion() != null && activo.getGestion() == false) {
				// Se crea una notificación.
				Notificacion notifGestionKO = new Notificacion();
				notifGestionKO.setIdActivo(activo.getId());
				Usuario gestor = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
				notifGestionKO.setDestinatario(gestor.getId());
				notifGestionKO.setTitulo("Revisar el estado de un activo con oferta aprobada");
				notifGestionKO.setDescripcion(
						"Se ha aprobado una oferta de venta asociada a este activo y no consta la conformidad de su departamento. Verifique el estado documental del mismo.");
				notifGestionKO.setFecha(new Date());
				
				try {
					// Se envía la notificación.
					anotacionApi.saveNotificacion(notifGestionKO);
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
		}
	}

}
