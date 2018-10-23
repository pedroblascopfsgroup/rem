package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;


@Component
public class NotificatorServiceResolucionComite extends AbstractNotificatorService implements NotificatorService{

	public static final String CODIGO_T013_RESOLUCION_COMITE = "T013_ResolucionComite";
    public static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";

	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private OfertaApi ofertaApi;	

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Autowired
	private NotificatorServiceSancionOfertaAceptacionYRechazo notificatorServiceSancionOfertaAceptacionYRechazo;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private static final String BUZON_REM = "buzonrem";
	private static final String BUZON_PFS = "buzonpfs";
	

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
	public final void notificator(ActivoTramite tramite) {

	}	

	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
			
		DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
		
		ExpedienteComercial expediente = getExpedienteComercial(tramite);
		Oferta oferta = expediente.getOferta();
			
		List<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();
		mailsCC.add(this.getCorreoFrom());			
		
		
		if(DDResolucionComite.CODIGO_CONTRAOFERTA.equalsIgnoreCase(activoTramiteApi.getTareaValorByNombre(valores, "comboResolucion"))) {
						
			Activo activo = oferta.getActivoPrincipal();
			ActivoProveedor preescriptor= ofertaApi.getPreescriptor(oferta);
			
			Usuario gestor = null;
			Usuario supervisor = null;
			Usuario buzonRem = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", BUZON_REM));
			Usuario buzonPfs = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", BUZON_PFS));
			
			for (TareaActivo tareaActivo : tramite.getTareas()) {				
				if (CODIGO_T013_DEFINICION_OFERTA.equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) {
					gestor = tareaActivo.getUsuario();
				}
				else if(CODIGO_T013_RESOLUCION_COMITE.equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) {
					supervisor = tareaActivo.getSupervisorActivo();
				}
			}

			
			List<Usuario> usuarios = new ArrayList<Usuario>();
			usuarios.add(gestor);
			usuarios.add(supervisor);
			if(!Checks.esNulo(buzonRem)) {
				usuarios.add(buzonRem);
			}
			if(!Checks.esNulo(buzonPfs)) {
				usuarios.add(buzonPfs);
			}
			
		    mailsPara = getEmailsNotificacionContraoferta(usuarios);
		    if(!Checks.esNulo(preescriptor) && !Checks.esNulo(preescriptor.getEmail())){
		    	mailsPara.add(preescriptor.getEmail());
		    }
			mailsCC.add(this.getCorreoFrom());
		
		    
			String contenido = "<p> Le informamos que la citada propuesta ha sido CONTRAOFERTADA por un importe de #importeContraoferta.</p>"
					+"<p> Quedamos a su disposición para cualquier consulta o aclaración.</p>"
					+"<p> Saludos cordiales.</p>"
					+"<p> Fdo: #gestorTarea </p>"
					+"<p> Email: #mailGestorTarea </p>";
			
			String gestorNombre = "SIN_DATOS_NOMBRE_APELLIDO_GESTOR";
			String gestorEmail = "SIN_DATOS_EMAIL_GESTOR";
			if (gestor != null && gestor.getApellidoNombre() != null ) {
				gestorNombre = gestor.getApellidoNombre();
			}
			if (gestor != null && gestor.getEmail() != null ) {
				gestorEmail = gestor.getEmail();
			}
			contenido = contenido.replace("#importeContraoferta", activoTramiteApi.getTareaValorByNombre(valores, "numImporteContra"))
								 .replace("#gestorTarea", gestorNombre)
								 .replace("#mailGestorTarea", gestorEmail);
	
			String titulo = "Contratoferta Activo/Agrupación #numactivo_agrupacion Oferta #numoferta";	
			String numactivoagrupacion = Checks.esNulo(oferta.getAgrupacion()) ? activo.getNumActivo().toString() : oferta.getAgrupacion().getNumAgrupRem().toString();
			titulo = titulo.replace("#numactivo_agrupacion", numactivoagrupacion)
					 		.replace("#numoferta", oferta.getNumOferta().toString());
	
			dtoSendNotificator.setTitulo("Notificación REM");
			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		} else {
			// Para los otros estados posibles, genero una notificacion de aceptacion o rechazo segun corresponda.
			notificatorServiceSancionOfertaAceptacionYRechazo.generaNotificacion(tramite, true, true);
		}
	}
	
	public void notificarResolucionBankia(ResolucionComiteBankia resol, Notificacion notif) {		
		List<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();
		
	    String correos = notif.getPara();
	    Collections.addAll(mailsPara, correos.split(";"));
		
		genericAdapter.sendMail(mailsPara, mailsCC, notif.getTitulo(), this.generateCuerpoNotificacionBankia(resol, notif.getDescripcion()));
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
	
	private String getUrlImagenes(){
		String url = appProperties.getProperty("url");
		
		return url+"/pfs/js/plugin/rem/resources/images/notificator/";
	}

	
	private String generateCuerpoNotificacionBankia(ResolucionComiteBankia resol, String contenido){
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
	
	private List<String> getEmailsNotificacionContraoferta(List<Usuario> usuarios) {


		List<String> mailsPara = new ArrayList<String>();
		
		for(Usuario usuario: usuarios) {
			
			if (usuario != null && !Checks.esNulo(usuario.getEmail())) {
				mailsPara.add(usuario.getEmail());
			}
		}
		

		
		return mailsPara;
	}
	
	public DtoSendNotificator rellenaDtoSendNotificator(ActivoTramite tramite){
		DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();
		
		dtoSendNotificator.setNumActivo(tramite.getActivo().getNumActivo());
		dtoSendNotificator.setDireccion(this.generateDireccion(tramite.getActivo()));
		if(!Checks.esNulo(tramite.getTrabajo().getAgrupacion()))
			dtoSendNotificator.setNumAgrupacion(tramite.getTrabajo().getAgrupacion().getNumAgrupRem());
		
		return dtoSendNotificator;
	}
}