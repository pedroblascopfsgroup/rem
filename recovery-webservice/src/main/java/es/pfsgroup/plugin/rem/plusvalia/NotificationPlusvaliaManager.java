package es.pfsgroup.plugin.rem.plusvalia;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.usuarioRem.UsuarioRemApi;


@Service
public class NotificationPlusvaliaManager extends AbstractNotificatorService {
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UsuarioRemApi usuarioRemApiImpl;
	
	@Resource
	private Properties appProperties;

	/**
	 * Cada vez que una plusvalia pase a estado "Rechazado" se mandará un correo de solicitud de revisión del activo.
	 * 
	 * @param activo
	 */
	public void sendNotificationPlusvaliaRechazado(Activo activo, ExpedienteComercial eco) {
		
		ActivoTramite tramite = new ActivoTramite();
		tramite.setActivo(activo);
		
		ArrayList<String> mailsPara = new ArrayList<String>();
		ArrayList<String> mailsCC = new ArrayList<String>();
		
		usuarioRemApiImpl.rellenaListaCorreos(eco, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION, mailsPara, mailsCC, false);
		
			String asunto = "Solicitud de revisión del activo " + activo.getNumActivo();
			String cuerpo = "<p>Buenos días,</p>";

			cuerpo = cuerpo +"<p>Se ruega por favor revisar el aparatado de observaciones de gestión de plusvalías del\n" + 
					"activo " + activo.getNumActivo() + ", ya que puede existir errores en algunos de los siguientes conceptos:</p> ";
			
			cuerpo = cuerpo + "<ul>"  
					+ "  <li>Pago de Plusvalía</li>"  
					+ "  <li>Cambio de titularidad Catastral</li>"  
					+ "  <li>Comunicación de venta a la Comunidad de Propietarios</li>"  
					+ "</ul> ";
			
			cuerpo = cuerpo + "<p>Muchas gracias</p>";
			cuerpo = cuerpo + "<p></p>";
			cuerpo = cuerpo + "<p><em>Operaciones de Activos Inmobiliarios – Administración</em><br/>";
			cuerpo = cuerpo + "<em>Haya Real Estate</em><br/>";
			cuerpo = cuerpo + "<em>Calle Medina de Pomar 27, 28042 Madrid</em></p>";
			
			String cuerpoCorreo = generateCuerpo(asunto, cuerpo);
			
			genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpoCorreo);
	}
	
	/**
	 * Cada vez que una plusvalia pase a estado "Liquidación en curso" se mandará un correo de notificacion de venta del activo.
	 * 
	 * @param activo
	 */
	public void sendNotificationPlusvaliaLiquidacion(Activo activo, ExpedienteComercial expediente) {
		
		ActivoTramite tramite = new ActivoTramite();
		tramite.setActivo(activo);
		
		ArrayList<String> mailsPara = new ArrayList<String>();
		ArrayList<String> mailsCC = new ArrayList<String>();
		
		usuarioRemApiImpl.rellenaListaCorreos(expediente, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION, mailsPara, mailsCC, false);
		
			String asunto = "Notificación de venta del activo " + activo.getNumActivo();
			String cuerpo = "<p>Buenos días,</p>";
			
			Date fechaActual = new Date();
			cuerpo = cuerpo +"<p>Se ha realizado la venta del activo " + activo.getNumActivo() + " el día " + new SimpleDateFormat("dd/MM/yyyy").format(fechaActual) + ".</p> ";

			cuerpo = cuerpo + "<p>Se ruega por favor que procedan a realizar:</p>";
			
			cuerpo = cuerpo + "<ul>"  
					+ "  <li>Pago de Plusvalía</li>"  
					+ "  <li>Cambio de titularidad Catastral</li>"  
					+ "  <li>Comunicación de venta a la Comunidad de Propietarios</li>"  
					+ "</ul> ";
			
			cuerpo = cuerpo + "<p>Muchas gracias</p>";
			cuerpo = cuerpo + "<p></p>";
			cuerpo = cuerpo + "<p><em>Operaciones de Activos Inmobiliarios – Administración</em><br/>";
			cuerpo = cuerpo + "<em>Haya Real Estate</em><br/>";
			cuerpo = cuerpo + "<em>Calle Medina de Pomar 27, 28042 Madrid</em></p>";
			
			String cuerpoCorreo = generateCuerpo(asunto, cuerpo);
			
			genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpoCorreo);
	}
	
	protected String generateCuerpo(String asunto, String contenido) {
		String cuerpo = "<html>" + "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + "<html>"
				+ "<head>" + "<META http-equiv='Content-Type' content='text/html; charset=utf-8'>" + "</head>"
				+ "<body>" + "	<div>" + "		<div style='font-family: Arial,&amp; amp;'>"
				+ "			<div style='border-radius: 12px 12px 0px 0px; background: #b7ddf0; width: 300px; height: 60px; display: table'>"
				+ "				<img src='" + this.getUrlImagenes() + "ico_notificacion.png' "
				+ "					style='display: table-cell; padding: 12px; display: inline-block' />"
				+ "				<div style='font-size: 20px; vertical-align: top; color: #333; display: table-cell; padding: 12px'> "
				+ asunto + "</div>" + "			</div>"
				+ "			<div style='background: #b7ddf0; width: 785px; min-height: 600px; border-radius: 0px 20px 20px 20px; padding: 20px'>"
				+ "				<div style='background: #fff; color: #333; border-radius: 20px; padding: 25px; line-height: 22px; text-align: justify; margin-top: 20px; font-size: 16px'>"
				+ contenido + "				</div>"
				+ "				<div style='color: #333; margin: 23px 0px 0px 65px; font-size: 16px; display: table;'>"
				+ "					<div style='display: table-cell'>" + "						<img src='"
				+ this.getUrlImagenes() + "ico_advertencia.png' />" + "					</div>"
				+ "					<div style='display: table-cell; vertical-align: middle; padding: 5px;'>"
				+ "						Este mensaje es una notificación automática. No responda a este correo.</div>"
				+ "				</div>" + "				</div>" + "			</div>" + "		</div>" + "</body>" + "</html>";

		return cuerpo;
	}
	
	private String getUrlImagenes() {
		String url = appProperties.getProperty("url");

		return url + "/pfs/js/plugin/rem/resources/images/notificator/";
	}
	
}
