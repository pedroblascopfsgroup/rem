package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.mail.MailManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.AgendaMultifuncionCorreoUtils;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.rest.api.NotificatorApi;

@Component
public class NotificatorServiceResolucionComite implements NotificatorApi{

	public static final String CODIGO_T013_RESOLUCION_COMITE = "T013_ResolucionComite";

	
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private AgendaMultifuncionCorreoUtils agendaMultifuncionCorreoUtils;
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	List<String> mailsPara = new ArrayList<String>();
	List<String> mailsCC = new ArrayList<String>();
	
	
	
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T013_RESOLUCION_COMITE};
	}


	
	
	@Override
	public void notificator(ResolucionComiteBankia resol, Notificacion notif) {		
		List<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();
		
	    String correos = notif.getPara();
	    Collections.addAll(mailsPara, correos.split(";"));
		
		genericAdapter.sendMail(mailsPara, mailsCC, notif.getTitulo(), this.generateCuerpo(resol, notif.getDescripcion()));
	}
	
	
	
	private String getUrlImagenes(){
		String url = appProperties.getProperty("url");
		
		return url+"/pfs/js/plugin/rem/resources/images/notificator/";
	}
	
	
	private String getUnidadGestion(ResolucionComiteBankia resol){
		String ud = "";
		if(!Checks.esNulo(resol) && !Checks.esNulo(resol.getExpediente()) && !Checks.esNulo(resol.getExpediente().getOferta())){
			Oferta ofr = resol.getExpediente().getOferta();
			if(!Checks.esNulo(ofr.getAgrupacion()) && !Checks.esNulo(ofr.getAgrupacion().getNumAgrupRem())){
				ud = ofr.getAgrupacion().getNumAgrupRem().toString();
				
			}else if(!Checks.esNulo(ofr.getActivoPrincipal()) && !Checks.esNulo(ofr.getActivoPrincipal().getNumActivo())){
				ud = ofr.getActivoPrincipal().getNumActivo().toString();
				
			} else {
				ud = " - ";
			}
		}
		return ud;
	}
	
	private String getOferta(ResolucionComiteBankia resol){
		String ofr = "";
		if(!Checks.esNulo(resol) && !Checks.esNulo(resol.getExpediente().getOferta())){
			ofr = resol.getExpediente().getOferta().getNumOferta().toString();
		}
		return ofr;
	}
	
	private String getComite(ResolucionComiteBankia resol){
		String comite = "";
		if(!Checks.esNulo(resol) && !Checks.esNulo(resol.getComite())){
			comite = resol.getComite().getDescripcion();
		}
		return comite;
	}
	
	
	private String getEstadoResolucion(ResolucionComiteBankia resol){
		String estado = "";
		if(!Checks.esNulo(resol) && !Checks.esNulo(resol.getEstadoResolucion())){
			estado = resol.getEstadoResolucion().getDescripcion();
		}
		return estado;
	}
	
	private String getMotivoDenegacion(ResolucionComiteBankia resol){
		String motivo = "";
		if(!Checks.esNulo(resol) && !Checks.esNulo(resol.getMotivoDenegacion())){
			motivo = resol.getMotivoDenegacion().getDescripcion();
		}
		return motivo;
	}
	
	private String getFechaAnulacion(ResolucionComiteBankia resol){
		SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		String fecha = "";
		if(!Checks.esNulo(resol) && !Checks.esNulo(resol.getFechaAnulacion())){
			fecha = df.format(resol.getFechaAnulacion());
		}
		return fecha;
	}
	
	private String getImporteContraoferta(ResolucionComiteBankia resol){
		String importe = "";
		if(!Checks.esNulo(resol) && !Checks.esNulo(resol.getImporteContraoferta())){
			importe = resol.getImporteContraoferta().toString();
		}
		return importe;
	}

	
	protected String generateCuerpo(ResolucionComiteBankia resol, String contenido){
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
				+ "					resolución comité Bankia</div>"
				+ "			</div>"
				+ "			<div style='background: #b7ddf0; width: 700px; min-height: 400px; border-radius: 0px 20px 20px 20px; padding: 20px'>"
				+ "				<div style='background: #054664; width: 600px; height: 200px; border-radius: 20px; color: #fff; display: inline-block'>"
				+ "					<div style='display: table; margin: 20px;'>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Oferta HRE:<strong>"+this.getOferta(resol)+"</strong>"
				+ "							</div>"
				+ "						</div>"	
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Activo/Lote HRE:<strong>"+this.getUnidadGestion(resol)+"</strong>"
				+ "							</div>"
				+ "						</div>"	
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Comité decisor: <strong>"+this.getComite(resol) +"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Resolución: <strong>"+ this.getEstadoResolucion(resol)+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Motivo denegación: <strong>"+ this.getMotivoDenegacion(resol) +"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Fecha anulación: <strong>"+ this.getFechaAnulacion(resol) +"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Importe contraoferta: <strong>"+ this.getImporteContraoferta(resol) +"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "					</div>"
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

}