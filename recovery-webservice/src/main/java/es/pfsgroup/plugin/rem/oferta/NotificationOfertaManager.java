package es.pfsgroup.plugin.rem.oferta;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoRestringida;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.usuarioRem.UsuarioRemApi;
import es.pfsgroup.plugin.rem.utils.FileItemUtils;

/**
 * Notificacion por correo cuando una nueva oferta llegue
 * 
 * HREOS-2044
 */
@Service
public class NotificationOfertaManager extends AbstractNotificatorService {

	private static final String USUARIO_FICTICIO_OFERTA_CAJAMAR = "ficticioOfertaCajamar";
	private static final String BUZON_REM = "buzonrem";
	private static final String BUZON_PFS = "buzonpfs";
	private static final String BUZON_BOARDING = "buzonboarding";
	private static final String BUZON_OFR_APPLE = "buzonofrapple";
	private static final String STR_MISSING_VALUE = "---";
	private static final String HTTP = "http";
	private static final String HTTPS = "https";
	private static final String GENERATE_EXCEL_HTTPS_DOWNLOAD = "generate.excel.https.download";
	public static final String[] DESTINATARIOS_CORREO_APROBACION = {"GESTCOMALQ", "SUPCOMALQ", "SCOM", "GCOM"};
		
	private List<String> mailsPara 	= new ArrayList<String>();
	private List<String> mailsCC 	= new ArrayList<String>();
	private List<String> mailsSustituto	= new ArrayList<String>();
	
	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private GestorActivoApi gestorActivoManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private UsuarioRemApi usuarioRemApiImpl;

	@Autowired
	private UsuarioManager usuarioManager;
	
	@Resource
	private Properties appProperties;
	
	
	
	private void limpiarMails() {
		this.mailsPara.clear();
		this.mailsCC.clear();
		this.mailsSustituto.clear();
	}
	/**
	 * Cada vez que llegue una oferta de un activo, 
	 * se enviará una notificación (correo) al gestor comercial correspondiente, 
	 * con independencia de que dicha oferta se muestre en el listado de ofertas del módulo comercial en el estado que corresponda (pendiente o congelada).
	 * 
	 * @param tramite
	 */
	@SuppressWarnings("unchecked")
	public void sendNotification(Oferta oferta) {

		Usuario usuario = null;
		Usuario supervisor= null;
		String emailPrescriptor = null;
		Usuario buzonOfertaApple = null;
		Activo activo = oferta.getActivoPrincipal();
		Usuario usuarioBackOffice = null;
		limpiarMails();

		if (!Checks.esNulo(oferta.getAgrupacion()) 
		        && !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion())
		        && DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())) {

			ActivoLoteComercial activoLoteComercial = genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
			usuario = activoLoteComercial.getUsuarioGestorComercial();
			if(!Checks.estaVacio(oferta.getAgrupacion().getActivos())){
				supervisor= gestorActivoManager.getGestorByActivoYTipo(oferta.getAgrupacion().getActivos().get(0).getActivo(), GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
			}

		} else if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())){
			// por activo
			usuario = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			emailPrescriptor = oferta.getPrescriptor().getEmail();
			buzonOfertaApple = usuarioManager.getByUsername(BUZON_OFR_APPLE);
		} else {
			if(!Checks.esNulo(activo)) {
				usuario = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
				supervisor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
			}
		}

		if (activo != null && (usuario != null || supervisor != null)) {
			
			String titulo;
			if (DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
				titulo = "Solicitud de oferta para compra del inmueble con referencia: " + activo.getNumActivo();
			} else {
				titulo = "Solicitud de oferta para alquiler del inmueble con referencia: " + activo.getNumActivo();
			}
			String tipoDocIndentificacion= "";
			String docIdentificacion="";
			String codigoPrescriptor="";
			String nombrePrescriptor="";
			
			DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();

			dtoSendNotificator.setNumActivo(activo.getNumActivo());
			dtoSendNotificator.setDireccion(generateDireccion(activo));
			dtoSendNotificator.setTitulo(titulo);

			if(!Checks.esNulo(oferta.getAgrupacion())) {
				dtoSendNotificator.setNumAgrupacion(oferta.getAgrupacion().getNumAgrupRem());	
			}

			List<String> mailsPara 		= new ArrayList<String>();
			List<String> mailsCC 		= new ArrayList<String>();	

			if(activo != null){
				if(DDCartera.CODIGO_CARTERA_BANKIA.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
						|| DDCartera.CODIGO_CARTERA_SAREB.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_GIANTS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_TANGO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_GALEON.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_EGEO.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						|| DDCartera.CODIGO_CARTERA_HYT.equals(oferta.getActivoPrincipal().getCartera().getCodigo())){
					usuarioBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
					if(!Checks.esNulo(usuarioBackOffice)){						
						if(Checks.estaVacio(mailsSustituto)){
							mailsSustituto = usuarioRemApiImpl.getGestorSustitutoUsuario(usuarioBackOffice);
						}else {
							mailsSustituto.clear();
							mailsSustituto = usuarioRemApiImpl.getGestorSustitutoUsuario(usuarioBackOffice);	
						}						
						if (!Checks.estaVacio(mailsSustituto)){
							mailsPara.addAll(mailsSustituto);
							mailsCC.add(usuarioBackOffice.getEmail());
						}else{
							mailsPara.add(usuarioBackOffice.getEmail());
						}
					}	
				}
			}

			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
					|| DDCartera.CODIGO_CARTERA_SAREB.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
					|| (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))){
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO, mailsPara, mailsCC, false);	

			}
			
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
					|| DDCartera.CODIGO_CARTERA_SAREB.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
					|| (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))){
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO, mailsPara, mailsCC, false);
			}
			
			if(!Checks.esNulo(usuario)){		
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL, mailsPara, mailsCC, false);
				if(!Checks.esNulo(activo.getSubcartera()) && !DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())) {
					usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL, mailsPara, mailsCC, true);
				}
			}
			
			if(!Checks.esNulo(supervisor)){
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL, mailsPara, mailsCC, false);
			}
			
			if(!Checks.esNulo(emailPrescriptor)) {
				mailsPara.add(emailPrescriptor);
			}
			
			if(!Checks.esNulo(activo.getCartera()) && DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())){
				usuarioRemApiImpl.rellenaListaCorreosPorDefecto(GestorActivoApi.USUARIO_FICTICIO_OFERTA_CAJAMAR, mailsPara);
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_RESERVA_CAJAMAR, mailsPara, mailsCC, false);
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR, mailsPara, mailsCC, false);
			}					
				
			Usuario buzonRem = usuarioManager.getByUsername(BUZON_REM);
			Usuario buzonPfs = usuarioManager.getByUsername(BUZON_PFS);

			if (!Checks.esNulo(buzonRem)) {
				mailsPara.add(buzonRem.getEmail());
			}
			if (!Checks.esNulo(buzonPfs)) {
				mailsPara.add(buzonPfs.getEmail());
			}
			if(buzonOfertaApple != null && (!Checks.esNulo(activo.getSubcartera()) && DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
				mailsPara.add(buzonOfertaApple.getEmail());
			}

			mailsCC.add(this.getCorreoFrom());
			
			if(!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getCliente()) && !Checks.esNulo(oferta.getCliente().getTipoDocumento())){
				tipoDocIndentificacion= oferta.getCliente().getTipoDocumento().getDescripcion();
				docIdentificacion= oferta.getCliente().getDocumento();
			}
			if(!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getPrescriptor())){
				if(!Checks.esNulo(oferta.getPrescriptor().getCodigoProveedorRem())){
					codigoPrescriptor= oferta.getPrescriptor().getCodigoProveedorRem().toString();
				}
				nombrePrescriptor= oferta.getPrescriptor().getNombre();
				if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
					mailsPara.add(oferta.getPrescriptor().getEmail());
				}
				
			}
			
			String contenido = 
					String.format("<p>Ha recibido una nueva oferta con número identificador %s, a nombre de %s con identificador %s %s, por importe de %s €. Prescriptor: %s %s.</p>", 
							oferta.getNumOferta().toString(), oferta.getCliente().getNombreCompleto(),tipoDocIndentificacion,docIdentificacion, NumberFormat.getNumberInstance(new Locale("es", "ES")).format(oferta.getImporteOferta()),codigoPrescriptor,nombrePrescriptor );
			if (oferta.getOfertaExpress()) {
				Usuario buzonBoarding = usuarioManager.getByUsername(BUZON_BOARDING);
				String asunto = "Notificación de aprobación provisional de la oferta " + oferta.getNumOferta();
				List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
				FileItem f1 = null;
				FileItem f2 = null;
				FileItem f3 = null;
				
				if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) {
					if (!Checks.esNulo(oferta.getPrescriptor())) {
						if (DDTipoProveedor.COD_OFICINA_CAJAMAR.equals(oferta.getPrescriptor().getTipoProveedor().getCodigo())) {
							f1 = FileItemUtils.fromResource("docs/instrucciones_reserva_express_oficinas.docx");
						} else {
							f1 = FileItemUtils.fromResource("docs/instrucciones_reserva_express_apis.docx");
						}
					} else {
						f1 = FileItemUtils.fromResource("docs/instrucciones_reserva_express_apis.docx");
					}
					
					f2 = FileItemUtils.fromResource("docs/ficha_cliente.xlsx");
					f3 = FileItemUtils.fromResource("docs/manif_titular_real.doc");
					
					adjuntos.add(createAdjunto(f1, "Instrucciones_Reserva_Formalizacion_Cajamar.docx"));
					adjuntos.add(createAdjunto(f2, "Ficha_cliente.xlsx"));
					adjuntos.add(createAdjunto(f3, "Manif_Titular_Real.doc"));

					if(!Checks.esNulo(buzonBoarding)){
						mailsPara.add(buzonBoarding.getEmail());
					}
				}
				//ADJUNTOS SI ES SAREB
				else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_SAREB)) {
					f1 = FileItemUtils.fromResource("docs/instrucciones_de_reserva_v3.docx");
					adjuntos.add(createAdjunto(f1, "Instrucciones_de_reserva.docx"));
				}
				//ADJUNTOS SI ES BANKIA
				else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)){
					f1 = FileItemUtils.fromResource("docs/instrucciones_reserva_CaixaBank_v7.docx");
					adjuntos.add(createAdjunto(f1, "instrucciones_reserva_CaixaBank.docx"));
				}
				//ADJUNTOS SI ES TANGO
				else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_TANGO)){
					f1 = FileItemUtils.fromResource("docs/contrato_reserva_Tango.docx");
					adjuntos.add(createAdjunto(f1, "contrato_reserva_Tango.docx"));
				}
				
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
				
				if (!Checks.esNulo(expediente)){
					String cuerpo = this.creaCuerpoOfertaExpress(oferta);
					
					genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpo, adjuntos);
				}

			} else {
				genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
			}
		}
	}
	
	
	/**
	 * Al proponer una oferta, 
	 * se enviará una notificación (correo) al gestor comercial correspondiente, 
	 * 
	 * @param tramite
	 **/
	public void sendNotificationPropuestaOferta(Oferta oferta, FileItem file) {

		Usuario usuario = null;
		Activo activo = oferta.getActivoPrincipal();
		limpiarMails();
		usuario = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);

		if (activo != null && usuario != null) {
			
			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();
			
			String titulo = "Propuesta oferta para el inmueble con referencia: " + activo.getNumActivo();
			
			dtoSendNotificator.setNumActivo(activo.getNumActivo());
			dtoSendNotificator.setDireccion(generateDireccion(activo));
			dtoSendNotificator.setTitulo(titulo);

			if(!Checks.esNulo(oferta.getAgrupacion())) {
				dtoSendNotificator.setNumAgrupacion(oferta.getAgrupacion().getNumAgrupRem());	
			}
			
			usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES, mailsPara, mailsCC, false);
			
			mailsCC.add(this.getCorreoFrom());
			
			List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
			adjuntos.add(createAdjunto(file, "Propuesta_Oferta.xlsx"));

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.creaCuerpoPropuestaOferta(oferta), adjuntos);
		}
	}
	
	private void getEmailDestinatariosAprobacion(Activo activo, Oferta ofertaAceptada, ExpedienteComercial expediente) {
		
		limpiarMails();
		ActivoProveedor prescriptor = null;
		ActivoProveedor custodio = null;
		Usuario usuarioBackOffice = null;
		List<String> mailsSustituto = new ArrayList<String>();
		
		for (String codigoGestor: DESTINATARIOS_CORREO_APROBACION) {
			usuarioRemApiImpl.rellenaListaCorreos(activo, codigoGestor, mailsPara, mailsCC, false);		
		}
		if(!Checks.esNulo(ofertaAceptada)){	
			if(!Checks.esNulo(ofertaAceptada.getPrescriptor())){
				prescriptor = ofertaAceptada.getPrescriptor();
				if(!Checks.esNulo(prescriptor)){
					mailsPara.add(prescriptor.getEmail());
				}		
			}
			if(!Checks.esNulo(ofertaAceptada.getActivoPrincipal()) && !Checks.esNulo(ofertaAceptada.getActivoPrincipal().getInfoComercial())) {
				custodio = ofertaAceptada.getActivoPrincipal().getInfoComercial().getMediadorInforme();
			}
		}
		if(custodio != null && !Checks.esNulo(custodio.getEmail())){
			mailsPara.add(custodio.getEmail());
		}

		if(ofertaAceptada.getActivoPrincipal() != null){
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo()) 
					|| DDCartera.CODIGO_CARTERA_SAREB.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_GIANTS.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_TANGO.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_GALEON.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_EGEO.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
					|| DDCartera.CODIGO_CARTERA_HYT.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())){
				usuarioBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
				if(!Checks.esNulo(usuarioBackOffice)){
					mailsSustituto.clear();
					mailsSustituto = usuarioRemApiImpl.getGestorSustitutoUsuario(usuarioBackOffice);
					if (!Checks.estaVacio(mailsSustituto)){
						mailsPara.addAll(mailsSustituto);
						mailsCC.add(usuarioBackOffice.getEmail());
					}else{
						mailsPara.add(usuarioBackOffice.getEmail());
					}
				}	
			}
		}
		
	}
	
	public String enviarMailAprobacion(Oferta oferta) {
		
		String errorCode = "";
		limpiarMails();
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		Activo activo = oferta.getActivoPrincipal();
		ActivoTramite tramite = new ActivoTramite();
		tramite.setActivo(activo);
		
		String codigoCartera = null;
		if (!Checks.esNulo(tramite.getActivo()) && !Checks.esNulo(tramite.getActivo().getCartera())) {
			codigoCartera = tramite.getActivo().getCartera().getCodigo();			
		}
		
		getEmailDestinatariosAprobacion(activo, oferta, expediente);
		
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
		
		if(!mailsPara.isEmpty()) {
		
			String asunto = "Notificación de aprobación provisional de la oferta " + oferta.getNumOferta();
			String cuerpo = "<p>Nos complace comunicarle que la oferta " + oferta.getNumOferta()
			+ " a nombre de '" + this.nombresOfertantes(expediente)
			+ "' ha sido PROVISIONALMENTE ACEPTADA";
			if (DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)) {
				cuerpo = cuerpo + " hasta la formalización de las arras/reserva";
			}
			cuerpo = cuerpo + ".</p>";
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
					gestorComercial = gestorActivoManager.getGestorByActivoYTipo(tramite.getActivo(), "GESTCOMALQ");
				}
			} else {
			    gestorComercial = gestorActivoManager.getGestorByActivoYTipo(tramite.getActivo(), "GESTCOMALQ");
			}
	
			cuerpo = cuerpo + String.format("<p>Gestor comercial alquiler: %s </p>", (gestorComercial != null) ? gestorComercial.getApellidoNombre() : STR_MISSING_VALUE );
			cuerpo = cuerpo + String.format("<p>%s</p>", (gestorComercial != null) ? gestorComercial.getEmail() : STR_MISSING_VALUE);
	
			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
			dtoSendNotificator.setTitulo(asunto);
			
			String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);

			
			genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpoCorreo, adjuntos);
			
		}
		else {
			errorCode = "No se han podido obtener los gestores.";
		}
		
		return errorCode;
	}
	
	public void enviarPropuestaOfertaTipoAlquiler(Oferta oferta) {
		
		Activo activo = oferta.getActivoPrincipal();
		limpiarMails();
		ArrayList<String> mailsPara = new ArrayList<String>();
		ArrayList<String> mailsCC = new ArrayList<String>();
	
		usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES, mailsPara, mailsCC, false);
		usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES, mailsPara, mailsCC, false);
		usuarioRemApiImpl.rellenaListaCorreosPorDefecto(GestorActivoApi.BUZON_PFS, mailsPara);
		
		String tipoDocIndentificacion=null;
		String docIdentificacion=null;
		if(!Checks.esNulo(oferta.getCliente())) {
			if(!Checks.esNulo(oferta.getCliente().getTipoDocumento())) {
				tipoDocIndentificacion= oferta.getCliente().getTipoDocumento().getDescripcion();
			}
			docIdentificacion= oferta.getCliente().getDocumento();
		}
		
		String codigoPrescriptor= oferta.getPrescriptor().getCodigoProveedorRem().toString();
		String nombrePrescriptor= oferta.getPrescriptor().getNombre();
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
		if(!mailsPara.isEmpty()) {
		
			String asunto = "Solicitud de oferta para alquiler del inmueble con referencia: " + oferta.getNumOferta();
			String cuerpo = 
					String.format("<p>Ha recibido una nueva oferta con número identificador %s, a nombre de %s con identificador %s %s, por importe de %s €. Prescriptor: %s %s.</p>", 
							oferta.getNumOferta().toString(), oferta.getCliente().getNombreCompleto(),tipoDocIndentificacion,docIdentificacion, NumberFormat.getNumberInstance(new Locale("es", "ES")).format(oferta.getImporteOferta()),codigoPrescriptor,nombrePrescriptor );
			
			DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();

			dtoSendNotificator.setNumActivo(activo.getNumActivo());
			dtoSendNotificator.setDireccion(generateDireccion(activo));
			dtoSendNotificator.setTitulo(asunto);

			if(!Checks.esNulo(oferta.getAgrupacion())) {
				dtoSendNotificator.setNumAgrupacion(oferta.getAgrupacion().getNumAgrupRem());	
			}			
			String cuerpoCorreo = this.generateCuerpo(dtoSendNotificator, cuerpo);
			
			genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpoCorreo, adjuntos);
			
		}
	
	}
	
	private DtoAdjuntoMail createAdjunto(FileItem fileitem, String name) {
		DtoAdjuntoMail adjMail = new DtoAdjuntoMail();
		Adjunto adjunto = new Adjunto(fileitem);
		adjMail.setAdjunto(adjunto);
		adjMail.setNombre(name);	
		return adjMail;
	}
	/**
	 * Al proponer una oferta, 
	 * se enviará una notificación (correo) al gestor comercial y supervisor correspondiente, 
	 * indicando si se aprueba o se anula y solo en caso de venta.
	 * El activo debe pertenecer a una agrupación DND.
	 * @param oferta
	 **/
	public void sendNotificationDND(Oferta oferta, Activo activo) {
		Usuario usuario = null;
		Usuario supervisor= null;
		limpiarMails();
		List<String> mailsPara 		= new ArrayList<String>();
		List<String> mailsCC 		= new ArrayList<String>();	
		String titulo = null;
		Long nActivo = null;
		
		String nombreCartera = "";
		String nombreLocalidad = "";
		String nombreProvincia = "";
		
		Boolean mandaCorreo=false;
		DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();
		
		if (!Checks.esNulo(activo) && !Checks.esNulo(oferta)
				&& !Checks.estaVacio(oferta.getActivosOferta())
				) {
			for (ActivoOferta actOfr : oferta.getActivosOferta()) {
				if (!Checks.esNulo(actOfr.getPrimaryKey().getActivo()) && actOfr.getPrimaryKey().getActivo().getIsDnd()) {
						mandaCorreo=true;
				}
			}
		}
		
		if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getEstadoOferta())
				&& !Checks.esNulo(activo)
				&& (!Checks.esNulo(activo.getIsDnd()) && activo.getIsDnd() || mandaCorreo)
				&& !Checks.esNulo(oferta.getEstadoOferta().getCodigo())
		        && (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo()) 
		        		|| DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())
		        	)
		) {
				usuario = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
				supervisor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);		
				
				if ( usuario != null || supervisor != null) {

					dtoSendNotificator.setNumActivo(activo.getNumActivo());
					dtoSendNotificator.setDireccion(generateDireccion(activo));
					dtoSendNotificator.setTitulo(titulo);

					if(!Checks.esNulo(oferta.getAgrupacion())) {
						dtoSendNotificator.setNumAgrupacion(oferta.getAgrupacion().getNumAgrupRem());	
					}

					if(!Checks.esNulo(usuario)){		
						usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL, mailsPara, mailsCC, false);
					}
					
					if(!Checks.esNulo(supervisor)){
						usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL, mailsPara, mailsCC, false);
					}
					
					String contenido = null;
					if (!Checks.esNulo(activo.getId())) {
						nActivo = activo.getNumActivo();
					}
					if (!Checks.esNulo(activo.getCartera()) && !Checks.esNulo(activo.getCartera().getDescripcion())) {
						nombreCartera = activo.getCartera().getDescripcion();
					}
					if (!Checks.esNulo(activo.getLocalidad()) && !Checks.esNulo(activo.getProvincia())) {
						nombreLocalidad = activo.getLocalidad().getDescripcion().toString();
						
						nombreProvincia = activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion();
					}
					if(nActivo != null){
						if (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())){
							titulo = 
									String.format("Oferta de venta aprobada de un activo incluido en un DND: %s- %s/%s/%s. ", 
											nActivo.toString(), nombreCartera, nombreLocalidad, nombreProvincia);
							contenido = 
									String.format("Oferta de venta aprobada para el activo incluido en un DND: " +
											 "%s- %s-%s-%s. Por favor, ponte en contacto con el comercial "
											 + "para conocer la fecha estimada de escrituración. Antes de producirse "
											 + "la venta el PM y la constructora debe realizar una valoración y liquidación "
											 + "de las obras en el estado que se paralizan.", nActivo.toString(),nombreCartera, nombreLocalidad, nombreProvincia 
									);
						} else if (DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())){
							titulo = 
									String.format("Oferta de venta anulada de un activo incluido en DND: %s- %s/%s/%s. ", 
											nActivo.toString(), nombreCartera, nombreLocalidad, nombreProvincia);
							contenido = 
									String.format("Oferta de venta anulada de un activo incluido en DND: %s- %s/%s/%s. ", 
											nActivo.toString(), nombreCartera, nombreLocalidad, nombreProvincia);
						}
					}
					genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
				}
		} 
	}
	
	
	public String enviarMailFichaComercial(Oferta oferta, String nameFile, String scheme, String serverName) {
		String base = scheme.concat("://").concat(serverName);
		if (useHttps() && HTTP.equals(scheme)) {
			base = HTTPS.concat("://").concat(serverName);
		}
		limpiarMails();
		String errorCode = "";
		Activo activo = oferta.getActivoPrincipal();
		DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
		Usuario usuarioBackOffice = null;
		ActivoLoteComercial agrupacionLoteCom = null;
		if(oferta.getAgrupacion() != null && oferta.getAgrupacion().getTipoAgrupacion() != null && DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())) {
			agrupacionLoteCom = genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
			if(agrupacionLoteCom != null) {
				usuarioBackOffice = agrupacionLoteCom.getUsuarioGestorComercialBackOffice();
			}
		} else {
			usuarioBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
		}
		Usuario buzonPfs = usuarioManager.getByUsername(BUZON_PFS);
		if(!Checks.esNulo(usuarioBackOffice)){	
			mailsPara.add(usuarioBackOffice.getEmail());
			mailsSustituto = usuarioRemApiImpl.getGestorSustitutoUsuario(usuarioBackOffice);
			mailsPara.addAll(mailsSustituto);
		}

		mailsCC.add(buzonPfs.getEmail());
		
		if(!mailsPara.isEmpty()) {
		
			String asunto = "Ficha comercial de la oferta " + oferta.getNumOferta();
			String cuerpo = "<p>La ficha comercial de la oferta  " + oferta.getNumOferta() + " esta lista para descargar.</p>";
			cuerpo =  cuerpo + "<p>\n" + 
					"			<a href=\"" + base +"/pfs/email/attachment?file=" + nameFile + "\"\n" + 
					"			   title=\"descarga el archivo\n" + 
					"			          \">Ficha Comercial</a>\n" + 
					"			</p>";
			cuerpo = cuerpo + "<p>La ficha estará disponible para su descarga durante 7 días</p>";

			dtoSendNotificator.setTitulo(asunto);
			if(oferta.getAgrupacion() != null) {
				if(agrupacionLoteCom != null) {
					dtoSendNotificator.setNumAgrupacion(agrupacionLoteCom.getNumAgrupRem());
					dtoSendNotificator.setDireccion(agrupacionLoteCom.getDireccion());
				} else if(oferta.getAgrupacion().getTipoAgrupacion() != null && (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())
						|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())
						|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo()))) {
					ActivoRestringida agrupacionRest = genericDao.get(ActivoRestringida.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
					if (agrupacionRest != null) {
						dtoSendNotificator.setNumAgrupacion(agrupacionRest.getNumAgrupRem());
						dtoSendNotificator.setDireccion(agrupacionRest.getDireccion());
					}
				}
			} else {
				dtoSendNotificator.setNumActivo(activo.getNumActivo());
				dtoSendNotificator.setDireccion(activo.getDireccionCompleta());
			}
			
			String cuerpoMail = generateBodyMailFichaComercial(dtoSendNotificator,cuerpo,base);
			
			genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpoMail,adjuntos);
			
		}
		else {
			errorCode = "No se ha podido enviar email de la ficha comercial de la oferta.";
		}
		
		return errorCode;
	}
	
	public boolean useHttps() {
		Boolean useHttps = Boolean.valueOf(appProperties.getProperty(GENERATE_EXCEL_HTTPS_DOWNLOAD));
		if (useHttps == null) {
			return false;
		}
		return useHttps;
	}
	
	
	
}
