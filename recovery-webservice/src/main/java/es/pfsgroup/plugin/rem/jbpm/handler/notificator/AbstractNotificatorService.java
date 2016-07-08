package es.pfsgroup.plugin.rem.jbpm.handler.notificator;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.Trabajo;


public abstract class AbstractNotificatorService{
	
	private static final String FROM = "agendaMultifuncion.mail.from";
	
	@Resource
	private Properties appProperties;
	
	private String generateFechaTrabajo(Trabajo trabajo){
		String fecha = null;
		DateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
		DateFormat formatoFechaHora = new SimpleDateFormat("dd/MM/yyyy hh:mm aaa");
		
		if(!Checks.esNulo(trabajo.getFechaHoraConcreta()))
			fecha = formatoFechaHora.format(trabajo.getFechaHoraConcreta());
		else
			fecha = formatoFecha.format(trabajo.getFechaTope());
		return fecha;
	}
	
	private String generateDireccion(Activo activo){
		String direccion = (!Checks.esNulo(activo.getLocalizacionActual().getTipoVia())? activo.getLocalizacionActual().getTipoVia().getDescripcion() : "") + " "
				 		 + (!Checks.esNulo(activo.getLocalizacionActual().getDireccion())? activo.getLocalizacionActual().getDireccion() : "") + " "
				 		 + (!Checks.esNulo(activo.getLocalizacionActual().getNumeroDomicilio())? activo.getLocalizacionActual().getNumeroDomicilio() : "") + " "
				 		 + (!Checks.esNulo(activo.getLocalizacionActual().getEscalera())? activo.getLocalizacionActual().getEscalera() : "") + " "
				 		 + (!Checks.esNulo(activo.getLocalizacionActual().getPiso())? activo.getLocalizacionActual().getPiso() : "") + " "
				 		 + (!Checks.esNulo(activo.getLocalizacionActual().getPuerta())? activo.getLocalizacionActual().getPuerta() : "") + " "
				 		 + (!Checks.esNulo(activo.getLocalizacionActual().getPoblacion())? activo.getLocalizacionActual().getPoblacion() : "") + " "
				 		 + (!Checks.esNulo(activo.getLocalizacionActual().getProvincia())? activo.getLocalizacionActual().getProvincia().getDescripcion() : "");
		return (!Checks.esNulo(direccion)? direccion : "");
	}
	
	public String generateTextoNoResponder(){
		String notificacionAutomatica = "<td style=\"vertical-align:middle;text-align:center;color:#0a94d6;font-size:x-small;font-weight:bold;padding:0px;border-collapse:collapse;margin-bottom:25px\"> ESTE MENSAJE ES UNA NOTIFICACIÓN AUTOMÁTICA. NO RESPONDA A ESTE CORREO.</td>";
		return notificacionAutomatica;
	}
	
	
	//TODO: Cambiar código HTML para cambiar el formato de envio del correo.
	protected String generateCuerpoCorreoOld(String contenido){
		String cuerpo = "<table cellspacing='0' cellpadding='0' border='0' width='100%' style='border-collapse:collapse;border-spacing:0;border-collapse:separate'>"
			      + "<tbody><tr>"
			      + this.generateTextoNoResponder() + "</tr>"
			      + "<tr><td style='padding:0px;border-collapse:collapse;border-left:0;border-right:0;border-top:0;border-bottom:0;padding:0 15px 0 16px;background-color:#fff;border-bottom:none;padding-bottom:0'>"
			      + " <table cellspacing='0' cellpadding='0' border='0' width='100%' style='border-collapse:collapse;font-family:Arial,sans-serif;font-size:14px;line-height:20px'>"
			      + "<tbody><tr>"
			      + "<td style='padding:0px;border-collapse:collapse;padding:0 0 10px 0'>"
				  + contenido + ""
				  + "</tr>"
				  + "</tbody></table>"
				  + "</td>"
				  + "</tr>"
				  + "</tbody></table>";
		return cuerpo;
	}
	
	protected String generateCuerpo(DtoSendNotificator dtoSendNotificator, String contenido){
		String cuerpo = "<html>"
				+ "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
				+ "<html>"
				+ "<head>"
				+ "<META http-equiv='Content-Type' content='text/html; charset=utf-8'>"
				+ "</head>"
				+ "<body>"
				+ "	<div>"
				+ "		<div style='font-family: Arial,&amp; amp;'>"
				+ "			<div style='border-radius: 12px 12px 0px 0px; background: #b7ddf0; width: 300px; height: 60px; display: table'>"
				+ "				<img src='"+this.getUrlImagenes()+"ico_notificacion.png' "
				+ "					style='display: table-cell; padding: 12px; display: inline-block' />"
				+ "				<div style='font-size: 20px; vertical-align: top; color: #333; display: table-cell; padding: 12px'>Notificación"
				+ "					encargo de trabajo en REM</div>"
				+ "			</div>"
				+ "			<div style='background: #b7ddf0; width: 785px; min-height: 600px; border-radius: 0px 20px 20px 20px; padding: 20px'>"
				+ "				<div style='background: #054664; width: 600px; height: 375px; border-radius: 20px; color: #fff; display: inline-block'>"
				+ "					<div style='display: table; margin: 20px;'>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='"+this.getUrlImagenes()+"ico_trabajos.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Nº Trabajo:<strong>"+dtoSendNotificator.getNumTrabajo()+"</strong>"
				+ "							</div>"
				+ "						</div>"				
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='"+this.getUrlImagenes()+"ico_tipo.png' />"
				+ "							</div>"
				+ "						<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Tipo de trabajo: <strong>"+dtoSendNotificator.getTipoContrato()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='"+this.getUrlImagenes()+"ico_fecha.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Fecha finalización trabajo: <strong>"+dtoSendNotificator.getFechaFinalizacion()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='"+this.getUrlImagenes()+"ico_activos.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Nº Activo: <strong>"+dtoSendNotificator.getNumActivo()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='"+this.getUrlImagenes()+"ico_direccion.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Dirección: <strong>"+dtoSendNotificator.getDireccion()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='"+this.getUrlImagenes()+"ico_agrupaciones.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Nº Agrupación: <strong>"+(!Checks.esNulo(dtoSendNotificator.getNumAgrupacion())?dtoSendNotificator.getNumAgrupacion() : "-")+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "					</div>"
				+ "				</div>"			
				+ "				<div style='display: inline-block; width: 140px; vertical-align: top'>"
				+ "					<img src='"+this.getUrlImagenes()+"logo_haya.png' "
				+ "						style='display: block; margin: 30px auto' /> "
				+ "					<img src='"+this.getUrlImagenes()+"logo_rem.png' "
				+ "						style='display: block; margin: 30px auto' /> "
				+ "				</div>"
				+ "				<div style='background: #fff; color: #333; border-radius: 20px; padding: 25px; line-height: 22px; text-align: justify; margin-top: 20px; font-size: 16px'>"
				+ 					contenido
				+ "				</div>"
				+ "				<div style='color: #333; margin: 23px 0px 0px 65px; font-size: 16px; display: table;'>"
				+ "					<div style='display: table-cell'>"
				+ "						<img src='"+this.getUrlImagenes()+"ico_advertencia.png' />"
				+ "					</div>"			
				+ "					<div style='display: table-cell; vertical-align: middle; padding: 5px;'>"
				+ "						Este mensaje es una notificación automática. No responda a este correo.</div>"
				+ "				</div>"
				+ "			</div>"
				+ "		</div>"
				+ "</body>"
				+ "</html>";
		
		return cuerpo;
	}
	
	private String getUrlImagenes(){
		String url = appProperties.getProperty("url");
		
		return url+"/pfs/js/plugin/rem/resources/images/notificator/";
	}

	protected DtoSendNotificator rellenaDtoSendNotificator(ActivoTramite tramite){
		DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();
		
		dtoSendNotificator.setNumActivo(tramite.getActivo().getNumActivo());
		dtoSendNotificator.setTipoContrato(tramite.getTrabajo().getSubtipoTrabajo().getDescripcion());
		dtoSendNotificator.setDireccion(this.generateDireccion(tramite.getActivo()));
		dtoSendNotificator.setNumTrabajo(tramite.getTrabajo().getNumTrabajo());
		dtoSendNotificator.setFechaFinalizacion(this.generateFechaTrabajo(tramite.getTrabajo()));
		if(!Checks.esNulo(tramite.getTrabajo().getAgrupacion()))
			dtoSendNotificator.setNumAgrupacion(tramite.getTrabajo().getAgrupacion().getNumAgrupRem());
		
		return dtoSendNotificator;
	}
	
	protected String getCorreoFrom(){
		return appProperties.getProperty(FROM);
	}
}
