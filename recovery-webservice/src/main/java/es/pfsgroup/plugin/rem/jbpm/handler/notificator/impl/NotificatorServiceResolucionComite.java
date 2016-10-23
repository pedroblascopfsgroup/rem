package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.mail.MailManager;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.AgendaMultifuncionCorreoUtils;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
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
		String contenido = "";
		String titulo = "";
		
	    String correos = notif.getPara();
	    Collections.addAll(mailsPara, correos.split(";"));
		
	    contenido = "<p>El comité decisor " + resol.getComite().getDescripcion() + ", ha "+resol.getEstadoResolucion().getDescripcion()+" oferta de número " + resol.getOferta().getNumOferta() + "</p>"
 		  		 + "<p>Por favor, entre en la aplicación REM y finalice la tarea que tiene pendiente en la agenda.</p>"
 		  		 + "<p>Gracias.</p>";
	    
		titulo = "Notificación de resolución comité Bankia sobre la oferta número (" + resol.getOferta().getNumOferta() + ".)";
		
		genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(resol, contenido));
	}
	
	
	
	private String getUrlImagenes(){
		String url = appProperties.getProperty("url");
		
		return url+"/pfs/js/plugin/rem/resources/images/notificator/";
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
				+ "			<div style='background: #b7ddf0; width: 785px; min-height: 600px; border-radius: 0px 20px 20px 20px; padding: 20px'>"
				+ "				<div style='background: #054664; width: 600px; height: 375px; border-radius: 20px; color: #fff; display: inline-block'>"
				+ "					<div style='display: table; margin: 20px;'>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Oferta HRE:<strong>"+resol.getOferta().getNumOferta()+"</strong>"
				+ "							</div>"
				+ "						</div>"				
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Comité decisor: <strong>"+resol.getComite().getDescripcion()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Resolución: <strong>"+resol.getEstadoResolucion().getDescripcion()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Motivo denegación: <strong>"+resol.getMotivoDenegacion().getDescripcion()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Fecha anulación: <strong>"+resol.getFechaAnulacion()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Importe contraoferta: <strong>"+resol.getImporteContraoferta()+"</strong>"
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

}