package es.pfsgroup.plugin.rem.jbpm.handler.notificator;

import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.impl.ActivoDaoImpl;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoEmailReserva;
import es.pfsgroup.plugin.rem.model.DtoEmailReservaDatosActivos;
import es.pfsgroup.plugin.rem.model.DtoEmailReservaDatosCompradores;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

public abstract class AbstractNotificatorService {

	private static final String FROM = "agendaMultifuncion.mail.from";

	@Resource
	private Properties appProperties;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GestorActivoApi gestorActivoManager;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	private static final String STR_MISSING_VALUE = "---";

	protected final Log logger = LogFactory.getLog(getClass());

	private String generateFechaTrabajo(Trabajo trabajo) {
		String fecha = null;
		DateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
		DateFormat formatoFechaHora = new SimpleDateFormat("dd/MM/yyyy hh:mm aaa");

		if (!Checks.esNulo(trabajo.getFechaHoraConcreta()))
			fecha = formatoFechaHora.format(trabajo.getFechaHoraConcreta());
		else if (!Checks.esNulo(trabajo.getFechaTope()))
			fecha = formatoFecha.format(trabajo.getFechaTope());
		return fecha == null ? "" : fecha;
	}

	public String generateDireccion(Activo activo) {
		String direccion = "";

		try {
			direccion = (!Checks.esNulo(activo.getLocalizacionActual().getTipoVia())
					? activo.getLocalizacionActual().getTipoVia().getDescripcion()
					: "")
					+ " "
					+ (!Checks.esNulo(activo.getLocalizacionActual().getDireccion())
							? activo.getLocalizacionActual().getDireccion()
							: "")
					+ " "
					+ (!Checks.esNulo(activo.getLocalizacionActual().getNumeroDomicilio())
							? activo.getLocalizacionActual().getNumeroDomicilio()
							: "")
					+ " "
					+ (!Checks.esNulo(activo.getLocalizacionActual().getEscalera())
							? activo.getLocalizacionActual().getEscalera()
							: "")
					+ " "
					+ (!Checks.esNulo(activo.getLocalizacionActual().getPiso())
							? activo.getLocalizacionActual().getPiso()
							: "")
					+ " "
					+ (!Checks.esNulo(activo.getLocalizacionActual().getPuerta())
							? activo.getLocalizacionActual().getPuerta()
							: "")
					+ " "
					+ (!Checks.esNulo(activo.getLocalizacionActual().getCodPostal())
							? activo.getLocalizacionActual().getCodPostal()
							: "")
					+ " "
					+ (!Checks.esNulo(activo.getLocalizacionActual().getProvincia())
							? activo.getLocalizacionActual().getProvincia().getDescripcion()
							: "");
		} catch (Exception e) {
			logger.error("error generando direccion", e);
		}
		return (!Checks.esNulo(direccion) ? direccion : "");
	}

	public String generateTextoNoResponder() {
		String notificacionAutomatica = "<td style=\"vertical-align:middle;text-align:center;color:#0a94d6;font-size:x-small;font-weight:bold;padding:0px;border-collapse:collapse;margin-bottom:25px\"> ESTE MENSAJE ES UNA NOTIFICACIÓN AUTOMÁTICA. NO RESPONDA A ESTE CORREO.</td>";
		return notificacionAutomatica;
	}

	// TODO: Cambiar código HTML para cambiar el formato de envio del correo.
	protected String generateCuerpoCorreoOld(String contenido) {
		String cuerpo = "<table cellspacing='0' cellpadding='0' border='0' width='100%' style='border-collapse:collapse;border-spacing:0;border-collapse:separate'>"
				+ "<tbody><tr>" + this.generateTextoNoResponder() + "</tr>"
				+ "<tr><td style='padding:0px;border-collapse:collapse;border-left:0;border-right:0;border-top:0;border-bottom:0;padding:0 15px 0 16px;background-color:#fff;border-bottom:none;padding-bottom:0'>"
				+ " <table cellspacing='0' cellpadding='0' border='0' width='100%' style='border-collapse:collapse;font-family:Arial,sans-serif;font-size:14px;line-height:20px'>"
				+ "<tbody><tr>" + "<td style='padding:0px;border-collapse:collapse;padding:0 0 10px 0'>" + contenido
				+ "" + "</tr>" + "</tbody></table>" + "</td>" + "</tr>" + "</tbody></table>";
		return cuerpo;
	}

	protected String generateCuerpoCorreoNotificacionAutomatica(String contenido) {
		String cuerpo = "<table cellspacing='0' cellpadding='0' border='0' width='100%' style='border-collapse:collapse;border-spacing:0;border-collapse:separate'>"
				+ "<tbody>"
				+ "<tr><td style='padding:0px;border-collapse:collapse;border-left:0;border-right:0;border-top:0;border-bottom:0;padding:0 15px 0 16px;background-color:#fff;border-bottom:none;padding-bottom:0'>"
				+ " <table cellspacing='0' cellpadding='0' border='0' width='100%' style='border-collapse:collapse;font-family:Arial,sans-serif;font-size:14px;line-height:20px'>"
				+ "<tbody><tr>" + "<td style='padding:0px;border-collapse:collapse;padding:0 0 10px 0'>" + contenido
				+ "" + "</tr>" + "</tbody></table>" + "</td>" + "<tr>" + this.generateTextoNoResponder() + "</tr>"
				+ "</tr>" + "</tbody></table>";
		return cuerpo;
	}

	protected String generateCuerpo(DtoSendNotificator dtoSendNotificator, String contenido) {
		String cuerpo = "<html>" + "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + "<html>"
				+ "<head>" + "<META http-equiv='Content-Type' content='text/html; charset=utf-8'>" + "</head>"
				+ "<body>" + "	<div>" + "		<div style='font-family: Arial,&amp; amp;'>"
				+ "			<div style='border-radius: 12px 12px 0px 0px; background: #b7ddf0; width: 300px; height: 60px; display: table'>"
				+ "				<img src='" + this.getUrlImagenes() + "ico_notificacion.png' "
				+ "					style='display: table-cell; padding: 12px; display: inline-block' />"
				+ "				<div style='font-size: 20px; vertical-align: top; color: #333; display: table-cell; padding: 12px'> "
				+ dtoSendNotificator.getTitulo() + "</div>" + "			</div>"
				+ "			<div style='background: #b7ddf0; width: 785px; min-height: 600px; border-radius: 0px 20px 20px 20px; padding: 20px'>"
				+ "				<div style='background: #054664; width: 600px; height: 375px; border-radius: 20px; color: #fff; display: inline-block'>"
				+ "					<div style='display: table; margin: 20px;'>";

		if (dtoSendNotificator.getNumTrabajo() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_trabajos.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Nº Trabajo:<strong>" + dtoSendNotificator.getNumTrabajo()
					+ "</strong>" + "							</div>" + "						</div>";
		}

		if (dtoSendNotificator.getTipoContrato() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_tipo.png' />"
					+ "							</div>"
					+ "						<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Tipo de trabajo: <strong>" + dtoSendNotificator.getTipoContrato()
					+ "</strong>" + "							</div>" + "						</div>";
		}

		if (dtoSendNotificator.getFechaFinalizacion() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_fecha.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Fecha finalización trabajo: <strong>"
					+ dtoSendNotificator.getFechaFinalizacion() + "</strong>" + "							</div>"
					+ "						</div>";
		}
		if (dtoSendNotificator.getProvincia() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_direccion.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Provincia: <strong>" + dtoSendNotificator.getProvincia()
					+ "</strong>" + "							</div>" + "						</div>";
		}
		if (dtoSendNotificator.getMunicipio() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_direccion.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Localidad: <strong>" + dtoSendNotificator.getMunicipio()
					+ "</strong>" + "							</div>" + "						</div>";
		}
		cuerpo = cuerpo + "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='" + this.getUrlImagenes() + "ico_activos.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Nº Activo: <strong>" + dtoSendNotificator.getNumActivo() + "</strong>"
				+ "							</div>" + "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='" + this.getUrlImagenes() + "ico_direccion.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Dirección: <strong>" + dtoSendNotificator.getDireccion() + "</strong>"
				+ "							</div>" + "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='" + this.getUrlImagenes() + "ico_agrupaciones.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Nº Agrupación: <strong>"
				+ (!Checks.esNulo(dtoSendNotificator.getNumAgrupacion()) ? dtoSendNotificator.getNumAgrupacion() : "-")
				+ "</strong>" + "							</div>" + "						</div>"
				+ "					</div>" + "				</div>"
				+ "				<div style='display: inline-block; width: 140px; vertical-align: top'>"
				+ "					<img src='" + this.getUrlImagenes() + "logo_haya.png' "
				+ "						style='display: block; margin: 30px auto' /> " + "					<img src='"
				+ this.getUrlImagenes() + "logo_rem.png' "
				+ "						style='display: block; margin: 30px auto' /> " + "				</div>"
				+ "				<div style='background: #fff; color: #333; border-radius: 20px; padding: 25px; line-height: 22px; text-align: justify; margin-top: 20px; font-size: 16px'>"
				+ contenido + "				</div>"
				+ "				<div style='color: #333; margin: 23px 0px 0px 65px; font-size: 16px; display: table;'>"
				+ "					<div style='display: table-cell'>" + "						<img src='"
				+ this.getUrlImagenes() + "ico_advertencia.png' />" + "					</div>"
				+ "					<div style='display: table-cell; vertical-align: middle; padding: 5px;'>"
				+ "						Este mensaje es una notificación automática. No responda a este correo.</div>"
				+ "				</div>" + "			</div>" + "		</div>" + "</body>" + "</html>";

		return cuerpo;
	}

	protected String generateBody(DtoSendNotificator dtoSendNotificator, String contenido) {
		String cuerpo = "<html>" + "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + "<html>"
				+ "<head>" + "<META http-equiv='Content-Type' content='text/html; charset=utf-8'>" + "</head>"
				+ "<body>" + "	<div>" + "		<div style='font-family: Arial,&amp; amp;'>"
				+ "			<div style='border-radius: 12px 12px 0px 0px; background: #b7ddf0; width: 300px; height: 60px; display: table'>"
				+ "				<img src='" + this.getUrlImagenes() + "ico_notificacion.png' "
				+ "					style='display: table-cell; padding: 12px; display: inline-block' />"
				+ "				<div style='font-size: 20px; vertical-align: top; color: #333; display: table-cell; padding: 12px'> "
				+ dtoSendNotificator.getTitulo() + "</div>" + "			</div>"
				+ "			<div style='background: #b7ddf0; width: 785px; min-height: 600px; border-radius: 0px 20px 20px 20px; padding: 20px'>"
				+ "				<div style='background: #054664; width: 600px; height: 375px; border-radius: 20px; color: #fff; display: inline-block'>"
				+ "					<div style='display: table; margin: 20px;'>";

		if (dtoSendNotificator.getNumTrabajo() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_trabajos.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Job Number:<strong>" + dtoSendNotificator.getNumTrabajo()
					+ "</strong>" + "							</div>" + "						</div>";
		}

		if (dtoSendNotificator.getTipoContrato() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_tipo.png' />"
					+ "							</div>"
					+ "						<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Type of job: <strong>" + dtoSendNotificator.getTipoContrato()
					+ "</strong>" + "							</div>" + "						</div>";
		}

		if (dtoSendNotificator.getFechaFinalizacion() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_fecha.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Job end date: <strong>" + dtoSendNotificator.getFechaFinalizacion()
					+ "</strong>" + "							</div>" + "						</div>";
		}
		cuerpo = cuerpo + "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='" + this.getUrlImagenes() + "ico_activos.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Asset number: <strong>" + dtoSendNotificator.getNumActivo()
				+ "</strong>" + "							</div>" + "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='" + this.getUrlImagenes() + "ico_direccion.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Address: <strong>" + dtoSendNotificator.getDireccion() + "</strong>"
				+ "							</div>" + "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='" + this.getUrlImagenes() + "ico_agrupaciones.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Asset group number: <strong>"
				+ (!Checks.esNulo(dtoSendNotificator.getNumAgrupacion()) ? dtoSendNotificator.getNumAgrupacion() : "-")
				+ "</strong>" + "							</div>" + "						</div>"
				+ "					</div>" + "				</div>"
				+ "				<div style='display: inline-block; width: 140px; vertical-align: top'>"
				+ "					<img src='" + this.getUrlImagenes() + "logo_haya.png' "
				+ "						style='display: block; margin: 30px auto' /> " + "					<img src='"
				+ this.getUrlImagenes() + "logo_rem.png' "
				+ "						style='display: block; margin: 30px auto' /> " + "				</div>"
				+ "				<div style='background: #fff; color: #333; border-radius: 20px; padding: 25px; line-height: 22px; text-align: justify; margin-top: 20px; font-size: 16px'>"
				+ contenido + "				</div>"
				+ "				<div style='color: #333; margin: 23px 0px 0px 65px; font-size: 16px; display: table;'>"
				+ "					<div style='display: table-cell'>" + "						<img src='"
				+ this.getUrlImagenes() + "ico_advertencia.png' />" + "					</div>"
				+ "					<div style='display: table-cell; vertical-align: middle; padding: 5px;'>"
				+ "						This message is an automatic notification. Don't respond to this email.</div>"
				+ "				</div>" + "			</div>" + "		</div>" + "</body>" + "</html>";

		return cuerpo;
	}

	protected String generateBodyMailFichaComercial(DtoSendNotificator dtoSendNotificator, String contenido,
			String url) {
		String urlImages = url + "/pfs/js/plugin/rem/resources/images/notificator/";
		String cuerpo = "<html>" + "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + "<html>"
				+ "<head>" + "<META http-equiv='Content-Type' content='text/html; charset=utf-8'>" + "</head>"
				+ "<body>" + "	<div>" + "		<div style='font-family: Arial,&amp; amp;'>"
				+ "			<div style='border-radius: 12px 12px 0px 0px; background: #b7ddf0; width: 300px; height: 60px; display: table'>"
				+ "				<img src='" + urlImages + "ico_notificacion.png' "
				+ "					style='display: table-cell; padding: 12px; display: inline-block' />"
				+ "				<div style='font-size: 20px; vertical-align: top; color: #333; display: table-cell; padding: 12px'> "
				+ dtoSendNotificator.getTitulo() + "</div>" + "			</div>"
				+ "			<div style='background: #b7ddf0; width: 785px; min-height: 600px; border-radius: 0px 20px 20px 20px; padding: 20px'>"
				+ "				<div style='background: #054664; width: 600px; height: 375px; border-radius: 20px; color: #fff; display: inline-block'>"
				+ "					<div style='display: table; margin: 20px;'>";
		cuerpo = cuerpo + "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='" + urlImages + "ico_activos.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Asset number: <strong>" + dtoSendNotificator.getNumActivo()
				+ "</strong>" + "							</div>" + "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='" + urlImages + "ico_direccion.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Address: <strong>" + dtoSendNotificator.getDireccion() + "</strong>"
				+ "							</div>" + "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='" + urlImages + "ico_agrupaciones.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Asset group number: <strong>"
				+ (!Checks.esNulo(dtoSendNotificator.getNumAgrupacion()) ? dtoSendNotificator.getNumAgrupacion() : "-")
				+ "</strong>" + "							</div>" + "						</div>"
				+ "					</div>" + "				</div>"
				+ "				<div style='display: inline-block; width: 140px; vertical-align: top'>"
				+ "					<img src='" + urlImages + "logo_haya.png' "
				+ "						style='display: block; margin: 30px auto' /> " + "					<img src='"
				+ urlImages + "logo_rem.png' " + "						style='display: block; margin: 30px auto' /> "
				+ "				</div>"
				+ "				<div style='background: #fff; color: #333; border-radius: 20px; padding: 25px; line-height: 22px; text-align: justify; margin-top: 20px; font-size: 16px'>"
				+ contenido + "				</div>"
				+ "				<div style='color: #333; margin: 23px 0px 0px 65px; font-size: 16px; display: table;'>"
				+ "					<div style='display: table-cell'>" + "						<img src='" + urlImages
				+ "ico_advertencia.png' />" + "					</div>"
				+ "					<div style='display: table-cell; vertical-align: middle; padding: 5px;'>"
				+ "						This message is an automatic notification. Don't respond to this email.</div>"
				+ "				</div>" + "			</div>" + "		</div>" + "</body>" + "</html>";

		return cuerpo;
	}

	private String getUrlImagenes() {
		String url = appProperties.getProperty("url");

		return url + "/pfs/js/plugin/rem/resources/images/notificator/";
	}

	protected DtoSendNotificator rellenaDtoSendNotificator(ActivoTramite tramite) {
		return this.rellenaDtoSendNotificator(null, tramite);
	}

	protected DtoSendNotificator rellenaDtoSendNotificator(Oferta oferta, ActivoTramite tramite) {
		DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();

		if (oferta != null) {
			dtoSendNotificator.setNumActivo(oferta.getActivoPrincipal().getNumActivo());
			dtoSendNotificator.setDireccion(this.generateDireccion(oferta.getActivoPrincipal()));
			if (oferta.getAgrupacion() != null) {
				dtoSendNotificator.setNumAgrupacion(oferta.getAgrupacion().getNumAgrupRem());
			}
		}

		if (tramite != null && !Checks.esNulo(tramite.getTrabajo())
				&& tramite.getTrabajo().getSubtipoTrabajo() != null) {
			dtoSendNotificator.setTipoContrato(tramite.getTrabajo().getSubtipoTrabajo().getDescripcion());
			dtoSendNotificator.setNumTrabajo(tramite.getTrabajo().getNumTrabajo());
			dtoSendNotificator.setFechaFinalizacion(this.generateFechaTrabajo(tramite.getTrabajo()));
			dtoSendNotificator.setNumActivo(tramite.getActivo().getNumActivo());
			if (!Checks.esNulo(tramite.getActivo().getDireccionCompleta())) {
				dtoSendNotificator.setDireccion(tramite.getActivo().getDireccionCompleta());
			}
			if (!Checks.esNulo(tramite.getActivo().getLocalidad())) {
				dtoSendNotificator.setMunicipio(tramite.getActivo().getLocalidad().getDescripcion());
			}
			if (!Checks.esNulo(tramite.getActivo().getLocalizacionActual().getProvincia())) {
				dtoSendNotificator
						.setProvincia(tramite.getActivo().getLocalizacionActual().getProvincia().getDescripcion());
			}
		}
		return dtoSendNotificator;
	}

	protected String getCorreoFrom() {
		return appProperties.getProperty(FROM);
	}

	protected Boolean checkTrabajoCartera(Trabajo trabajo, String codigoCartera) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (codigoCartera.equals(primerActivo.getCartera().getCodigo()));
			}
		}

		return false;
	}

	public String creaCuerpoOfertaExpress(Oferta oferta) {

		Activo activo = oferta.getActivoPrincipal();
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());

		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		List<ActivoTramite> tramites = genericDao.getList(ActivoTramite.class, filterAct);

		Integer numTramites = tramites.size();

		ActivoTramite tramite = tramites.get(numTramites - 1);

		String codigoCartera = null;
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getCartera())) {
			codigoCartera = activo.getCartera().getCodigo();
		}

		if (expediente != null && Checks.esNulo(expediente.getReserva()) && oferta.getOfertaExpress()) {
			Filter filterReserva = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
			Reserva reserva = genericDao.get(Reserva.class, filterReserva);
			if (!Checks.esNulo(reserva)) {
				expediente.setReserva(reserva);
			}
		}

		String asunto = "Notificación de aprobación provisional de la oferta " + oferta.getNumOferta();
		String cuerpo = "<p>Nos complace comunicarle que la oferta " + oferta.getNumOferta() + " a nombre de "
				+ nombresOfertantesExpress(expediente) + " ha sido PROVISIONALMENTE ACEPTADA";

		if (DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)) {
			cuerpo = cuerpo + " hasta la formalización de las arras/reserva";
		}

		cuerpo = cuerpo
				+ ". Adjunto a este correo encontrará el documento con las instrucciones a seguir para la reserva y formalización";

		if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codigoCartera)) {
			cuerpo = cuerpo + ", así como la Ficha cliente a cumplimentar</p>";
		} else {
			cuerpo = cuerpo + ".</p>";
		}
		ActivoBancario activoBancario = genericDao.get(ActivoBancario.class,

				genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));

		if (!Checks.esNulo(expediente.getId()) && !Checks.esNulo(expediente.getReserva())
				&& !DDClaseActivoBancario.CODIGO_FINANCIERO.equals(activoBancario.getClaseActivo().getCodigo())) {
			String reservationKey = "";
			if (!Checks.esNulo(appProperties.getProperty("haya.reservation.pwd"))) {
				reservationKey = String.valueOf(expediente.getId())
						.concat(appProperties.getProperty("haya.reservation.pwd"));
				reservationKey = this.computeKey(reservationKey);
			}
			String reservationUrl = "";
			if (!Checks.esNulo(appProperties.getProperty("haya.reservation.url"))) {
				reservationUrl = appProperties.getProperty("haya.reservation.url");
			}

			if (DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)) {
				if (!DDSubtipoActivo.CODIGO_SUBTIPO_LOCAL_COMERCIAL.equals(activo.getSubtipoActivo().getCodigo())) {
					cuerpo = cuerpo + "<p>Pinche <a href=\"" + reservationUrl + expediente.getId() + "/"
							+ reservationKey + "/1\">aquí</a> para la descarga del contrato de reserva.</p>";
				}
			} else if (DDCartera.CODIGO_CARTERA_SAREB.equals(codigoCartera)) {
				if (DDSubtipoActivo.CODIGO_SUBTIPO_LOCAL_COMERCIAL.equals(activo.getSubtipoActivo().getCodigo())
						|| DDSubtipoActivo.CODIGO_SUBTIPO_NAVE_ADOSADA.equals(activo.getSubtipoActivo().getCodigo())
						|| DDSubtipoActivo.CODIGO_SUBTIPO_NAVE_AISLADA.equals(activo.getSubtipoActivo().getCodigo())
						|| DDSubtipoActivo.CODIGO_SUBTIPO_NO_URBAN_RUSTICO
								.equals(activo.getSubtipoActivo().getCodigo())) {

					cuerpo = cuerpo + "<p>Pinche <a href=\"" + reservationUrl + expediente.getId() + "/"
							+ reservationKey + "/1\">aquí</a> para la descarga del contrato de reserva.</p>";

				}
			} else {
				cuerpo = cuerpo + "<p>Pinche <a href=\"" + reservationUrl + expediente.getId() + "/" + reservationKey
						+ "/1\">aquí</a> para la descarga del contrato de reserva.</p>";
			}
		}

		cuerpo = cuerpo + "<p>Quedamos a su disposición para cualquier consulta o aclaración. Saludos cordiales.</p>";

		Usuario gestorComercial = null;

		if (!Checks.esNulo(oferta.getAgrupacion())
				&& !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion() != null)) {
			if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL
					.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())
					&& oferta.getAgrupacion() instanceof ActivoLoteComercial) {
				ActivoLoteComercial activoLoteComercial = (ActivoLoteComercial) oferta.getAgrupacion();
				gestorComercial = activoLoteComercial.getUsuarioGestorComercial();
			} else {
				// Lote Restringido
				gestorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, "GCOM");
			}
		} else {
			gestorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, "GCOM");
		}

		cuerpo = cuerpo + String.format("<p>Gestor comercial: %s </p>",
				(gestorComercial != null) ? gestorComercial.getApellidoNombre() : STR_MISSING_VALUE);
		cuerpo = cuerpo + String.format("<p>%s</p>",
				(gestorComercial != null) ? gestorComercial.getEmail() : STR_MISSING_VALUE);

		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(oferta, tramite);
		dtoSendNotificator.setTitulo(asunto);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);

		return cuerpoCorreo;

	}

	public String creaCuerpoPropuestaOferta(Oferta oferta) {
		Activo activo = oferta.getActivoPrincipal();
		DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();
		Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		List<ActivoTramite> tramites = genericDao.getList(ActivoTramite.class, filterAct);
		ActivoTramite tramite;

		String asunto = "Notificación de propuesta de la oferta " + oferta.getNumOferta();
		String cuerpo = "<p>Nos complace mandarle la información de la propuesta de oferta " + oferta.getNumOferta();

		cuerpo = cuerpo + ". Adjunto a este correo encontrará el documento con las información de la propuesta";

		cuerpo = cuerpo + ".</p>";

		Integer numTramites = tramites.size();

		if (!Checks.estaVacio(tramites)) {
			tramite = tramites.get(numTramites - 1);
			dtoSendNotificator = this.rellenaDtoSendNotificator(oferta, tramite);
			dtoSendNotificator.setTitulo(asunto);
		}

		cuerpo = cuerpo + "<p>Quedamos a su disposición para cualquier consulta o aclaración. Saludos cordiales.</p>";

		Usuario gestorComercial = null;

		gestorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, "GESTCOMALQ");

		cuerpo = cuerpo + String.format("<p>Gestor comercial: %s </p>",
				(gestorComercial != null) ? gestorComercial.getApellidoNombre() : STR_MISSING_VALUE);
		cuerpo = cuerpo + String.format("<p>%s</p>",
				(gestorComercial != null) ? gestorComercial.getEmail() : STR_MISSING_VALUE);

		String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);

		return cuerpoCorreo;

	}

	protected String computeKey(String key) {

		String result = "";
		try {
			byte[] bytesOfMessage = key.getBytes("UTF-8");

			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(bytesOfMessage);
			byte[] thedigest = md.digest();
			StringBuffer hexString = new StringBuffer();
			for (int i = 0; i < thedigest.length; i++) {
				if ((0xff & thedigest[i]) < 0x10) {
					hexString.append("0" + Integer.toHexString((0xFF & thedigest[i])));
				} else {
					hexString.append(Integer.toHexString(0xFF & thedigest[i]));
				}
			}
			result = hexString.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	protected String nombresOfertantes(ExpedienteComercial expediente) {
		String result = STR_MISSING_VALUE;
		if (expediente != null) {
			Filter filterComprador = genericDao.createFilter(FilterType.EQUALS, "expediente", expediente.getId());
			List<CompradorExpediente> compradoresExpediente = genericDao.getList(CompradorExpediente.class,
					filterComprador);

			if (compradoresExpediente != null) {
				StringBuilder ofertantes = null;
				for (CompradorExpediente ce : compradoresExpediente) {
					String fullName = getCompradorFullName(ce.getComprador());
					if (ofertantes != null) {
						ofertantes.append(" / " + fullName);
					} else {
						ofertantes = new StringBuilder(fullName);
					}
				}
				if (ofertantes != null) {
					result = ofertantes.toString();
				}
			}
		}
		return result;
	}

	protected String nombresOfertantesExpress(ExpedienteComercial expediente) {

		Filter filterComprador = genericDao.createFilter(FilterType.EQUALS, "expediente", expediente.getId());
		List<CompradorExpediente> compradoresExpediente = genericDao.getList(CompradorExpediente.class,
				filterComprador);

		if ((expediente != null) && (compradoresExpediente != null)) {
			StringBuilder ofertantes = null;
			for (CompradorExpediente ce : compradoresExpediente) {
				String fullName = getCompradorFullName(ce.getPrimaryKey().getComprador().getId());
				if (ofertantes != null) {
					ofertantes.append(" / " + fullName);
				} else {
					ofertantes = new StringBuilder(fullName);
				}
			}
			return (ofertantes != null) ? ofertantes.toString() : STR_MISSING_VALUE;
		} else {
			return STR_MISSING_VALUE;
		}
	}

	protected String getCompradorFullName(Long compradorId) {

		try {
			if (compradorId != null) {
				Comprador comprador = genericDao.get(Comprador.class,
						genericDao.createFilter(FilterType.EQUALS, "id", compradorId));
				if (comprador != null) {
					return comprador.getFullName();
				} else {
					return STR_MISSING_VALUE;
				}
			} else {
				return STR_MISSING_VALUE;
			}
		} catch (Exception e) {
			return STR_MISSING_VALUE;
		}
	}

	protected String generateBodyMailVenta(DtoEmailReserva dtoSendEmailReserva) {

		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		String tablaCompradores = generarTablaComprador(dtoSendEmailReserva.getListaEmailReservaCompradores());
		
		String tablaDatosActivos = generarTablaDatosActivos(dtoSendEmailReserva.getLisDtoEmailReservaDatosActivos());
		
		String cuerpo = "<html>" + "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + "<html>"
				+ "<head>" + "<META http-equiv='Content-Type' content='text/html; charset=utf-8'>" + "</head>"
				+ "<body>" + "	<div>" + "		<div style='font-family: Arial,&amp; amp;'>"
				+ "			<div style='border-radius: 12px 12px 0px 0px; background: #b7ddf0; width: 300px; height: 60px; display: table'>"
				+ "				<img src='" + this.getUrlImagenes() + "ico_notificacion.png' "
				+ "					style='display: table-cell; padding: 12px; display: inline-block' />"
				+ "				<div style='font-size: 20px; vertical-align: top; color: #333; display: table-cell; padding: 12px'> "
				+ dtoSendEmailReserva.getNumeroOferta() + "</div>" + "			</div>"
				+ "			<div style='background: #b7ddf0; width: 785px; min-height: 600px; border-radius: 0px 20px 20px 20px; padding: 20px'>"
				+ "				<div style='background: #054664; width: 600px; height: 375px; border-radius: 20px; color: #fff; display: inline-block'>"
				+ "					<div style='display: table; margin: 20px;'>";

		if (dtoSendEmailReserva.getNumeroOferta() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_trabajos.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Nº Oferta:<strong>" + dtoSendEmailReserva.getNumeroOferta()
					+ "</strong>" + "							</div>" + "						</div>";
		}

		if (dtoSendEmailReserva.getImporteOferta() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_tipo.png' />"
					+ "							</div>"
					+ "						<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								Importe oferta: <strong>" + dtoSendEmailReserva.getImporteOferta()
					+ "</strong>" + "							</div>" + "						</div>";
		}

		if (dtoSendEmailReserva.getImporteReserva() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_fecha.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								 Importe reserva: <strong>"
					+ dtoSendEmailReserva.getImporteReserva() + "</strong>" + "							</div>"
					+ "						</div>";
		}
		
		if (dtoSendEmailReserva.getFechaFirmaReserva() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_direccion.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								  Fecha firma reserva: <strong>"
					+ dateFormat.format(dtoSendEmailReserva.getFechaFirmaReserva()) + "</strong>" + "							</div>"
					+ "						</div>";
		}
		//Cambiar por fecha venta y añadir un boleano para saber cual utilizar fecha venta o fecha firma reserva segun el tipo de email
		if (dtoSendEmailReserva.getFechaVenta() != null) {
			cuerpo = cuerpo + "						<div style='display: table-row;'>"
					+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
					+ "								<img src='" + this.getUrlImagenes() + "ico_direccion.png' />"
					+ "							</div>"
					+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
					+ "								  Fecha venta: <strong>"
					+ dateFormat.format(dtoSendEmailReserva.getFechaVenta()) + "</strong>" + "							</div>"
					+ "						</div>";
		}

		cuerpo = cuerpo + "					</div>" + "				</div>"
				+ "				<div style='display: inline-block; width: 140px; vertical-align: top'>"
				+ "					<img src='" + this.getUrlImagenes() + "logo_haya.png' "
				+ "						style='display: block; margin: 30px auto' /> " + "					<img src='"
				+ this.getUrlImagenes() + "logo_rem.png' "
				+ "						style='display: block; margin: 30px auto' /> " + "				</div>"
				+ "				<div style='background: #fff; color: #333; border-radius: 20px; padding: 25px; line-height: 22px; text-align: justify; margin-top: 20px; font-size: 16px'>"
				+ "	" + tablaCompradores+"<br><br>" + tablaDatosActivos 
				+ "		</div>"
				+ "				<div style='color: #333; margin: 23px 0px 0px 65px; font-size: 16px; display: table;'>"
				+ "					<div style='display: table-cell'>" + "						<img src='"
				+ this.getUrlImagenes() + "ico_advertencia.png' />" + "					</div>"
				+ "					<div style='display: table-cell; vertical-align: middle; padding: 5px;'>"
				+ "						Este mensaje es una notificación automática. No responda a este correo.</div>"
				+ "				</div>" + "			</div>" + "		</div>" + "</body>" + "</html>";

		return cuerpo;
	}
	
	private String generarTablaComprador( List <DtoEmailReservaDatosCompradores> listaEmailReservaCompradores) {
		
		String tablaCompradores = " <table border='1' style='width: 100%;border: 1px solid black; border-collapse: collapse;'>"
				+ "<tr style='height: 20px; text-align: center;'>"
				+ "<td'><b>Comprador</b></td>" 
				+ "<td><b>Documento</b></td>"
				+ "</tr>";

		for (DtoEmailReservaDatosCompradores compradores : listaEmailReservaCompradores) {
			tablaCompradores = tablaCompradores + "<tr style='height: 20px;'>" 
					+ "<th> "+ compradores.getNombreCompleto() + "</th>" 
					+ "<th>" + compradores.getTipoDocumento() +": " + compradores.getDocumento() + "</th>"
					+ "</tr>";
		}
		tablaCompradores = tablaCompradores + " </table>";
		return tablaCompradores;
	}
	
	private String generarTablaDatosActivos( List <DtoEmailReservaDatosActivos> listaEmailReservaDatosActivos) {
			
			String tablaDatosActivos = " <table border='1' style='width: 100%;border: 1px solid black; border-collapse: collapse;'>"
					+ "<tr style='height: 20px; text-align: center;'>"
					+ "<td'><b>Id Haya</b></td>" 
					+ "<td><b>Sociedad Propietaria</b></td>"
					+ "<td><b>Linea Factura</b></td>"
					+ "<td><b>Finca Registrada</b></td>"
					+ "<td><b>% Participación</b></td>"
					+ "<td><b>Provincia</b></td>"
					+ "<td><b>Municipio</b></td>"
					+ "<td><b>Dirección</b></td>"
					+ "</tr>";
	
			for (DtoEmailReservaDatosActivos datosActivos : listaEmailReservaDatosActivos) {
				tablaDatosActivos = tablaDatosActivos + "<tr style='height: 20px;'>" 
						+ "<th> "	+ datosActivos.getId() + "</th>" 
						+ "<th>" + datosActivos.getSociedadPropietaria() + "</th>"
						+ "<th>" + datosActivos.getLineaFactura() + "</th>"
						+ "<th>" + datosActivos.getFincaRegistral() + "</th>"
						+ "<th>" + datosActivos.getParticipacion() + "</th>"
						+ "<th>" + datosActivos.getProvincia() + "</th>"
						+ "<th>" + datosActivos.getMunicipio() + "</th>"
						+ "<th>" + datosActivos.getDireccion()+ "</th>"								
						+ "</tr>";
			}
			tablaDatosActivos = tablaDatosActivos + " </table>";
			return tablaDatosActivos;
		}

}
