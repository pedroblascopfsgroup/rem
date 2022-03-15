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
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
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
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;


@Component
public class NotificatorServiceResolucionComite extends AbstractNotificatorService implements NotificatorService{

	public static final String CODIGO_T013_RESOLUCION_COMITE = "T013_ResolucionComite";
    public static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
    public static final String CODIGO_T017_ANALISIS_PM = "T017_AnalisisPM";
	public static final String CODIGO_T017_RESOLUCION_CES = "T017_ResolucionCES";
	public static final String CODIGO_T017_RATIFIACION_COMITE_CES = "T017_RatificacionComiteCES";
	private static final String COMBO_RESOLUCION = "comboResolucion";
	private static final String COMBO_RATIFICACION = "comboRatificacion";

	
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
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GestorActivoApi gestorActivoManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private static final String BUZON_REM = "buzonrem";
	private static final String BUZON_PFS = "buzonpfs";
	private static final String BUZON_OFR_APPLE = "buzonofrapple";
	private static final String BUZON_OFR_JAGUAR = "buzonofrjaguar";
	

	List<String> mailsPara = new ArrayList<String>();
	List<String> mailsCC = new ArrayList<String>();
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T013_RESOLUCION_COMITE, CODIGO_T017_ANALISIS_PM, CODIGO_T017_RESOLUCION_CES, CODIGO_T017_RATIFIACION_COMITE_CES};
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
			Usuario supervisorComercial = null;
			Usuario supervisor = null;
			Usuario gestorBackoffice = null;
			Usuario supervisorBackOffice = null;
			Usuario gestorFormalizacion = null;
			Usuario supervisorFormalizacion = null;
			Usuario usuarioBackOffice = null;
			Usuario usuarioFormalizacion = null;
			Usuario buzonRem = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", BUZON_REM));
			Usuario buzonPfs = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", BUZON_PFS));
			Usuario buzonOfertaApple = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", BUZON_OFR_APPLE));
			Usuario buzonOfertaJaguar = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", BUZON_OFR_JAGUAR));
			
			if(expedienteComercialApi.esApple(valores.get(0).getTareaExterna())){
				gestor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
				gestorBackoffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			} else {
				for (TareaActivo tareaActivo : tramite.getTareas()) {				
					if (CODIGO_T013_DEFINICION_OFERTA.equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) {
						gestor = tareaActivo.getUsuario();
					}
					else if(CODIGO_T013_RESOLUCION_COMITE.equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) {
						supervisor = tareaActivo.getSupervisorActivo();
					}
				}
			}
			
			List<Usuario> usuarios = new ArrayList<Usuario>();
			if(!Checks.esNulo(gestor)) {
				usuarios.add(gestor);
			}
			if (!Checks.esNulo(supervisor)) {
				usuarios.add(supervisor);
			}
			if(!Checks.esNulo(gestorBackoffice)) {
				usuarios.add(gestorBackoffice);
			}
			if(!Checks.esNulo(buzonRem)) {
				usuarios.add(buzonRem);
			}
			if(!Checks.esNulo(buzonPfs)) {
				usuarios.add(buzonPfs);
			}
			if(!Checks.esNulo(buzonOfertaApple) && (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
				usuarios.add(buzonOfertaApple);
			}
			if(!Checks.esNulo(buzonOfertaJaguar) && (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo()))) {
				usuarios.add(buzonOfertaJaguar);
			}
			
		    mailsPara = getEmailsNotificacionContraoferta(usuarios);
		    
		    if(activo != null){
				if(DDCartera.CODIGO_CARTERA_BANKIA.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
						|| DDCartera.CODIGO_CARTERA_SAREB.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_GIANTS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_TANGO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_GALEON.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_EGEO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_HYT.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivoPrincipal().getCartera().getCodigo())){
					usuarioBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
					if(!Checks.esNulo(usuarioBackOffice)){
						mailsPara.add(usuarioBackOffice.getEmail());
					}	
				}
				if(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())){
					gestorBackoffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
					supervisorBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
					gestorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
					supervisorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
					gestor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
					supervisorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);

					if(!Checks.esNulo(gestorBackoffice) && !Checks.esNulo(gestorBackoffice.getEmail())){
						mailsPara.add(gestorBackoffice.getEmail());
					}

					if(!Checks.esNulo(supervisorBackOffice) && !Checks.esNulo(supervisorBackOffice.getEmail())){
						mailsPara.add(supervisorBackOffice.getEmail());
					}

					if(!Checks.esNulo(gestorFormalizacion) && !Checks.esNulo(gestorFormalizacion.getEmail())){
						mailsPara.add(gestorFormalizacion.getEmail());
					}

					if(!Checks.esNulo(supervisorFormalizacion) && !Checks.esNulo(supervisorFormalizacion.getEmail())){
						mailsPara.add(supervisorFormalizacion.getEmail());
					}

					if(!Checks.esNulo(gestor) && !Checks.esNulo(gestor.getEmail())){
						mailsPara.add(gestor.getEmail());
					}

					if(!Checks.esNulo(supervisorComercial) && !Checks.esNulo(supervisorComercial.getEmail())){
						mailsPara.add(supervisorComercial.getEmail());
					}
				}
			}
		    
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
	
			String titulo = "Contraoferta Activo/Agrupación #numactivo_agrupacion Oferta #numoferta";	
			String numactivoagrupacion = Checks.esNulo(oferta.getAgrupacion()) ? activo.getNumActivo().toString() : oferta.getAgrupacion().getNumAgrupRem().toString();
			titulo = titulo.replace("#numactivo_agrupacion", numactivoagrupacion)
					 		.replace("#numoferta", oferta.getNumOferta().toString());
	
			dtoSendNotificator.setTitulo("Notificación REM");
			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		} else {
			Boolean permiteNotificarAprobacion = true;
			Boolean correoLlegadaTarea = false;
			Boolean aprueba = false;
			String codTareaActual = null;
			
			for (TareaExternaValor valor : valores) {
				if ((COMBO_RESOLUCION.equals(valor.getNombre()) || COMBO_RATIFICACION.equals(valor.getNombre()) )&& !Checks.esNulo(valor.getValor())) {
					aprueba = DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor()) ? true : false;
					break;
				}
			}
			
			if(CODIGO_T017_ANALISIS_PM.equals(valores.get(0).getTareaExterna().getTareaProcedimiento().getCodigo())) {
				permiteNotificarAprobacion = false;
			}
			
			if((CODIGO_T017_ANALISIS_PM.equals(valores.get(0).getTareaExterna().getTareaProcedimiento().getCodigo()) && aprueba)) {
				correoLlegadaTarea = true;
				codTareaActual = valores.get(0).getTareaExterna().getTareaProcedimiento().getCodigo();
			}
			
			// Para los otros estados posibles, genero una notificacion de aceptacion o rechazo segun corresponda.
			notificatorServiceSancionOfertaAceptacionYRechazo.generaNotificacion(tramite, true, permiteNotificarAprobacion, correoLlegadaTarea, codTareaActual);
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
				+ "					resolución comité Grupo Caixabank</div>"
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

		ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());

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
		if(tramite.getTrabajo() != null && !Checks.esNulo(tramite.getTrabajo().getAgrupacion()))
			dtoSendNotificator.setNumAgrupacion(tramite.getTrabajo().getAgrupacion().getNumAgrupRem());
		
		return dtoSendNotificator;
	}
}