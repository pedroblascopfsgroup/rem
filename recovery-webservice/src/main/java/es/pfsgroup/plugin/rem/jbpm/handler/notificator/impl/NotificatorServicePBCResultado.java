package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestor.GestorExpedienteComercialManager;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.utils.FileItemUtils;

@Component
public class NotificatorServicePBCResultado extends AbstractNotificatorService implements NotificatorService {

	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
	private static final String USUARIO_FICTICIO_PBC_BANKIA = "ficticioPbcBankia";
	private static final String USUARIO_FICTICIO_PBC_SAREB = "ficticioPbcSareb";
	private static final String USUARIO_FICTICIO_PBC_LIBERBANK = "ficticioPbcLiberbank";

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private GestorExpedienteComercialManager gestorExpedienteComercialManager;

	@Autowired
	private GestorActivoApi gestorActivoManager;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_RESULTADO_PBC };
	}

	@Override
	public void notificator(ActivoTramite tramite) {
		return;
	}

	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {

		String pbcEstado = "denegada";

		for (TareaExternaValor valor : valores) {
			if (COMBO_RESULTADO.equals(valor.getNombre()) && "01".equals(valor.getValor())) {
				pbcEstado = "aprobada";
			}
		}

		ExpedienteComercial expediente = getExpedienteComercial(tramite);

		if (expediente == null) {
			return;
		}

		Oferta oferta = expediente.getOferta();

		if (oferta == null) {
			return;
		}
		
		Activo activo = oferta.getActivoPrincipal();
		
		if (activo == null) {
			return;
		}
		
		DDCartera cartera = activo.getCartera();
		
		if (DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo()) || DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo()) 
				|| DDCartera.CODIGO_CARTERA_LIBERBANK.equals(cartera.getCodigo())) {
			
			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

			String titulo = "Resolución PBC&FT del expediente " + expediente.getNumExpediente() + ": Solicitud documentación para formalización venta";

			dtoSendNotificator.setTitulo(titulo);

			String contenido = String.format("<p>Le informamos que para iniciar la tramitación de la operación objeto del presente, precisamos que nos remita a la mayor brevedad posible lo siguiente:</p>"
					+ "<ul style='list-style-type:none'>"
					+ "<li>- El formulario de cliente anexo debidamente completado y firmado por el comprador o compradores* (de persona física o persona jurídica según proceda).</li><br/>"
					+ "<ul style='list-style-type:none'>"
					+ "<li>* Deberá aportarse un formulario por cada comprador en caso de que haya más de uno.</li><br/>"
					+ "</ul>"
					+ "<li>- Aportar la información y documentación que se detalla en el documento adjunto denominado “Información y documentación”.</li>"
					+ "</ul>"
					+ "<p>Le informamos que la autorización PBC&FT de la oferta %s se ha resuelto como %s.</p>", oferta.getNumOferta(), pbcEstado);
			
			List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
			FileItem f1 = null;
			FileItem f2 = null;
			FileItem f3 = null;
			
			List<String> mailsPara = getEmailsToSend(expediente, oferta);
			List<String> mailsCC = new ArrayList<String>();
			
			mailsCC.add(this.getCorreoFrom());
			
				if(DDCartera.CODIGO_CARTERA_LIBERBANK.equals(cartera.getCodigo())) {
					
					f1 = FileItemUtils.fromResource("docs/anexo_1_a_Formulario_personas_fisicas_unicaja.docx");
					f2 = FileItemUtils.fromResource("docs/anexo_1_b_Formulario_personas_juridicas_unicaja.docx");
					f3 = FileItemUtils.fromResource("docs/informacion_y_documentacion.docx");
					
					adjuntos.add(createAdjunto(f1, "Anexo_1_a_Formulario_personas_fisicas.docx"));
					adjuntos.add(createAdjunto(f2, "Anexo_1_b_Formulario_personas_juridicas.docx"));
					adjuntos.add(createAdjunto(f3, "Información_y_documentación.docx"));
					
				}else {
					
					f1 = FileItemUtils.fromResource("docs/anexo_1_a_Formulario_personas_fisicas.docx");
					f2 = FileItemUtils.fromResource("docs/anexo_1_b_Formulario_personas_juridicas.docx");
					f3 = FileItemUtils.fromResource("docs/informacion_y_documentacion.docx");
					
					adjuntos.add(createAdjunto(f1, "Anexo_1_a_Formulario_personas_fisicas.docx"));
					adjuntos.add(createAdjunto(f2, "Anexo_1_b_Formulario_personas_juridicas.docx"));
					adjuntos.add(createAdjunto(f3, "Información_y_documentación.docx"));
					
				}
								
				genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido), adjuntos);
			
		} else {
			
			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);

			String titulo = "Resolución PBC&FT del expediente " + expediente.getNumExpediente();

			dtoSendNotificator.setTitulo(titulo);

			String contenido = String.format("<p>Le informamos que la autorización PBC&FT de la oferta %s se ha resuelto como %s.</p>", oferta.getNumOferta(), pbcEstado);

			List<String> mailsPara = getEmailsToSend(expediente, oferta);
			List<String> mailsCC = new ArrayList<String>();

			mailsCC.add(this.getCorreoFrom());

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
			
		}
	}

	private List<String> getEmailsToSend(ExpedienteComercial expediente, Oferta oferta) {
		ActivoProveedor preescriptor= ofertaApi.getPreescriptor(oferta);
		Usuario gestoriaFormalizacion = gestorExpedienteComercialManager.getGestorByExpedienteComercialYTipo(expediente, "GIAFORM");

		Usuario gestorComercial = null;
		Activo activo = oferta.getActivoPrincipal();

		if (!Checks.esNulo(oferta.getAgrupacion()) 
		        && !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion())
		        && DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())) {

			ActivoLoteComercial activoLoteComercial = genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
			gestorComercial = activoLoteComercial.getUsuarioGestorComercial();

		} else {
			// Activo
			gestorComercial = gestorActivoManager.getGestorByActivoYTipo(activo, "GCOM");
		}

		List<String> mailsPara = new ArrayList<String>();

		if (preescriptor != null && !Checks.esNulo(preescriptor.getEmail())) {
			mailsPara.add(preescriptor.getEmail());
		}

		if (gestoriaFormalizacion != null && !Checks.esNulo(gestoriaFormalizacion.getEmail())) {
			mailsPara.add(gestoriaFormalizacion.getEmail());
		}

		if (gestorComercial != null && !Checks.esNulo(gestorComercial.getEmail())) {
			mailsPara.add(gestorComercial.getEmail());
		}
		
		if(!Checks.esNulo(activo.getCartera()) && DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())){
			if(!Checks.esNulo(usuarioManager.getByUsername(USUARIO_FICTICIO_PBC_SAREB))){
				mailsPara.add(usuarioManager.getByUsername(USUARIO_FICTICIO_PBC_SAREB).getEmail());
			}				
		} else if(!Checks.esNulo(activo.getCartera()) && DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())){
			if(!Checks.esNulo(usuarioManager.getByUsername(USUARIO_FICTICIO_PBC_BANKIA))){
				mailsPara.add(usuarioManager.getByUsername(USUARIO_FICTICIO_PBC_BANKIA).getEmail());
			}				
		} else if(!Checks.esNulo(activo.getCartera()) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())){
			if(!Checks.esNulo(usuarioManager.getByUsername(USUARIO_FICTICIO_PBC_LIBERBANK))){
				mailsPara.add(usuarioManager.getByUsername(USUARIO_FICTICIO_PBC_LIBERBANK).getEmail());
			}				
		}
		
		return mailsPara;
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
	
	private DtoAdjuntoMail createAdjunto(FileItem fileitem, String name) {
		DtoAdjuntoMail adjMail = new DtoAdjuntoMail();
		Adjunto adjunto = new Adjunto(fileitem);
		adjMail.setAdjunto(adjunto);
		adjMail.setNombre(name);	
		return adjMail;
	}

}
