package es.pfsgroup.plugin.rem.oferta;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

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
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorSustituto;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
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

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private GestorActivoApi gestorActivoManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	private static final String STR_MISSING_VALUE = "---";
	public static final String[] DESTINATARIOS_CORREO_APROBACION = {"GESTCOMALQ", "SUPCOMALQ", "SCOM", "GCOM"};

	/**
	 * Cada vez que llegue una oferta de un activo, 
	 * se enviará una notificación (correo) al gestor comercial correspondiente, 
	 * con independencia de que dicha oferta se muestre en el listado de ofertas del módulo comercial en el estado que corresponda (pendiente o congelada).
	 * 
	 * @param tramite
	 */
	public void sendNotification(Oferta oferta) {

		Usuario usuario = null;
		Usuario usuarioBackOffice = null;
		Usuario supervisor= null;
		Activo activo = oferta.getActivoPrincipal();

		if (!Checks.esNulo(oferta.getAgrupacion()) 
		        && !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion())
		        && DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())) {

			ActivoLoteComercial activoLoteComercial = genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
			usuario = activoLoteComercial.getUsuarioGestorComercial();
			if(!Checks.estaVacio(oferta.getAgrupacion().getActivos())){
				supervisor= gestorActivoManager.getGestorByActivoYTipo(oferta.getAgrupacion().getActivos().get(0).getActivo(), GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
			}

		} else {
			// por activo
			usuario = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			supervisor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
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

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			
			if(oferta.getActivoPrincipal() != null){
				if(DDCartera.CODIGO_CARTERA_BANKIA.equals(oferta.getActivoPrincipal().getCartera().getCodigo()) 
						|| DDCartera.CODIGO_CARTERA_SAREB.equals(oferta.getActivoPrincipal().getCartera().getCodigo())){
					usuarioBackOffice = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
					if(!Checks.esNulo(usuarioBackOffice)){
						mailsPara.add(usuarioBackOffice.getEmail());					
					}
				}
			}

			if(!Checks.esNulo(usuario)){
				mailsPara.add(usuario.getEmail());
				
				Usuario directorEquipo = gestorActivoManager.getDirectorEquipoByGestor(usuario);
				if (!Checks.esNulo(directorEquipo)){
					mailsPara.add(directorEquipo.getEmail());
				}
				
				List<GestorSustituto> sustitutos = genericDao.getList(GestorSustituto.class, genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", usuario.getId()));
				if (!Checks.esNulo(sustitutos)) {
					for (GestorSustituto gestorSustituto : sustitutos) {
						if (!Checks.esNulo(gestorSustituto)) {
							if ((gestorSustituto.getFechaFin() == null || gestorSustituto.getFechaFin().after(new Date())
									|| gestorSustituto.getFechaFin().equals(new Date()))
									&& (gestorSustituto.getFechaInicio().before(new Date())
											|| gestorSustituto.getFechaInicio().equals(new Date()))
									&& !gestorSustituto.getAuditoria().isBorrado()) {
								mailsPara.add(gestorSustituto.getUsuarioGestorSustituto().getEmail());
							}
						}
					}
				}				
			}
			
			if(!Checks.esNulo(supervisor)){
				mailsPara.add(supervisor.getEmail());
			}
			
			if(!Checks.esNulo(activo.getCartera()) && DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())){
				if(!Checks.esNulo(usuarioManager.getByUsername(USUARIO_FICTICIO_OFERTA_CAJAMAR))){
					mailsPara.add(usuarioManager.getByUsername(USUARIO_FICTICIO_OFERTA_CAJAMAR).getEmail());
				}				
				
				Usuario ficticioCajamar = usuarioManager.getByUsername(USUARIO_FICTICIO_OFERTA_CAJAMAR);
				
				if(!Checks.esNulo(ficticioCajamar)){
					mailsPara.add(ficticioCajamar.getEmail());
				}
				
				Usuario gesRes = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_RESERVA_CAJAMAR);
				
				if(!Checks.esNulo(gesRes)) {
					mailsPara.add(gesRes.getEmail());
				}
				
				Usuario supRes = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_RESERVA_CAJAMAR);
				
				if(!Checks.esNulo(supRes)){
					mailsPara.add(supRes.getEmail());
				}
			}
			
			Usuario buzonRem = usuarioManager.getByUsername(BUZON_REM);
			Usuario buzonPfs = usuarioManager.getByUsername(BUZON_PFS);
			
			if(!Checks.esNulo(buzonRem)) {
				mailsPara.add(buzonRem.getEmail());
			}
			if(!Checks.esNulo(buzonPfs)) {
				mailsPara.add(buzonPfs.getEmail());
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
				}
				//ADJUNTOS SI ES SAREB
				else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_SAREB)) {
					f1 = FileItemUtils.fromResource("docs/instrucciones_de_reserva.docx");
					adjuntos.add(createAdjunto(f1, "Instrucciones_de_reserva.docx"));
				}
				//ADJUNTOS SI ES BANKIA
				else if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)){
					f1 = FileItemUtils.fromResource("docs/instrucciones_reserva_Bankia_v7.docx");
					adjuntos.add(createAdjunto(f1, "instrucciones_reserva_Bankia.docx"));
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
	 */
	public void sendNotificationPropuestaOferta(Oferta oferta, FileItem file) {

		Usuario usuario = null;
		Activo activo = oferta.getActivoPrincipal();

		usuario = gestorActivoManager.getGestorByActivoYTipo(activo, "GESTCOMALQ");

		if (activo != null && usuario != null) {

			String titulo = "Propuesta oferta para el inmueble con referencia: " + activo.getNumActivo();
			
			DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();

			dtoSendNotificator.setNumActivo(activo.getNumActivo());
			dtoSendNotificator.setDireccion(generateDireccion(activo));
			dtoSendNotificator.setTitulo(titulo);

			if(!Checks.esNulo(oferta.getAgrupacion())) {
				dtoSendNotificator.setNumAgrupacion(oferta.getAgrupacion().getNumAgrupRem());	
			}

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();

			if(!Checks.esNulo(usuario)){
				mailsPara.add(usuario.getEmail());
			
				List<GestorSustituto> sustitutos = genericDao.getList(GestorSustituto.class, genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", usuario.getId()));
				for (GestorSustituto gestorSustituto : sustitutos) {
					if ((gestorSustituto.getFechaFin().after(new Date()) || gestorSustituto.getFechaFin().equals(new Date())) && (gestorSustituto.getFechaInicio().before(new Date()) || gestorSustituto.getFechaInicio().equals(new Date())) && !gestorSustituto.getAuditoria().isBorrado()){
						mailsPara.add(gestorSustituto.getUsuarioGestorSustituto().getEmail());
					}
				}
			}
			
			mailsCC.add(this.getCorreoFrom());
			
			List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
			adjuntos.add(createAdjunto(file, "Propuesta_Oferta.xlsx"));

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.creaCuerpoPropuestaOferta(oferta), adjuntos);
		}
	}
	
	private ArrayList<String> getEmailDestinatariosAprobacion(Activo activo, Oferta ofertaAceptada, ExpedienteComercial expediente) {
		
		ArrayList<String> destinatarios = new ArrayList<String>();
		
		Usuario gestor = null;
		ActivoProveedor prescriptor = null;
		ActivoProveedor custodio = null;
		
		for (String codigoGestor: DESTINATARIOS_CORREO_APROBACION) {
			
			gestor = gestorActivoManager.getGestorByActivoYTipo(activo, codigoGestor);
			
			if(!Checks.esNulo(gestor)){
				destinatarios.add(gestor.getEmail());
			}
			
		}
		
		prescriptor = ofertaAceptada.getPrescriptor();
		if(!Checks.esNulo(prescriptor)){
			destinatarios.add(prescriptor.getEmail());
		}		
		
		custodio = ofertaAceptada.getActivoPrincipal().getInfoComercial().getMediadorInforme();
		if(!Checks.esNulo(custodio)){
			destinatarios.add(custodio.getEmail());
		}
		
		return destinatarios;
	}
	
	public String enviarMailAprobacion(Oferta oferta) {
		
		String errorCode = "";
		
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		Activo activo = oferta.getActivoPrincipal();
		ActivoTramite tramite = new ActivoTramite();
		tramite.setActivo(activo);
		
		String codigoCartera = null;
		if (!Checks.esNulo(tramite.getActivo()) && !Checks.esNulo(tramite.getActivo().getCartera())) {
			codigoCartera = tramite.getActivo().getCartera().getCodigo();			
		}
		
		ArrayList<String> destinatarios = this.getEmailDestinatariosAprobacion(activo, oferta, expediente);
		List<String> mailsCC = new ArrayList<String>();
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
		
		if(!destinatarios.isEmpty()) {
		
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
			
			genericAdapter.sendMail(destinatarios, mailsCC, asunto, cuerpoCorreo, adjuntos);
			
		}
		else {
			errorCode = "No se han podido obtener los gestores.";
		}
		
		return errorCode;
	}
	
	public void enviarPropuestaOfertaTipoAlquiler(Oferta oferta) {
		
		Activo activo = oferta.getActivoPrincipal();
		
		ArrayList<String> para = new ArrayList<String>();
		Usuario gest_com_alq = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);
		Usuario sup_com_alq = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES);
		
		if(!Checks.esNulo(gest_com_alq)) {
			para.add(gest_com_alq.getEmail());
		}
		if(!Checks.esNulo(sup_com_alq)) {
			para.add(sup_com_alq.getEmail());
		}
		
		Usuario buzonPfs = usuarioManager.getByUsername(BUZON_PFS);
		if(!Checks.esNulo(buzonPfs)) {
			para.add(buzonPfs.getEmail());
		}
		
		String tipoDocIndentificacion= oferta.getCliente().getTipoDocumento().getDescripcion();
		String docIdentificacion= oferta.getCliente().getDocumento();
		String codigoPrescriptor= oferta.getPrescriptor().getCodigoProveedorRem().toString();
		String nombrePrescriptor= oferta.getPrescriptor().getNombre();
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
		if(!para.isEmpty()) {
		
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
			
			genericAdapter.sendMail(para, null, asunto, cuerpoCorreo, adjuntos);
			
		}
	
	}
	
	private DtoAdjuntoMail createAdjunto(FileItem fileitem, String name) {
		DtoAdjuntoMail adjMail = new DtoAdjuntoMail();
		Adjunto adjunto = new Adjunto(fileitem);
		adjMail.setAdjunto(adjunto);
		adjMail.setNombre(name);	
		return adjMail;
	}

	
}
