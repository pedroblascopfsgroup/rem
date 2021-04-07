package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.adjunto.model.Adjunto;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoBbvaActivos;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoEmailReserva;
import es.pfsgroup.plugin.rem.model.DtoEmailReservaDatosActivos;
import es.pfsgroup.plugin.rem.model.DtoEmailReservaDatosCompradores;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;

@Component
public class NotificatorServiceContabilidadBbva extends AbstractNotificatorService {
	
	private static final String VENTA_INMUEBLES_BBVA_CORREO = "ventainmuebles@bbva.com";
	private static final String CONTABILIDAD_RECATALUNYA_BBVA_CORREO = "contabilidad.recatalunya@bbva.com";
	private static final String RECUPERA_CORREO = "recupera@edt-sg.com";
	private static final String J_POYATOS_CORREO = "jpoyatos@haya.com";
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	
	
	public void notificatorFinTareaConValores(ExpedienteComercial expediente,boolean contratoReserva) throws GestorDocumentalException {
		
			DtoEmailReserva dtoEmailReserva = rellenarDtoEmailReserva(expediente, contratoReserva);
			
			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			List<String> mailsBCC = new ArrayList<String>();
			List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
			
			String correos = null;
			String titulo = "";
			
			if(contratoReserva) {
				titulo = "Reserva oferta " + expediente.getOferta().getNumOferta() + " - Importe reserva "+ dtoEmailReserva.getImporteReserva() +"";
				
			}else {
				titulo = "Venta oferta " + expediente.getOferta().getNumOferta() + " - Importe oferta "+ dtoEmailReserva.getImporteOferta() +"";
				
			}
			adjuntos = rellenarDtoAdjuntoMailReserva(expediente,contratoReserva);
			mailsCC.add(this.getCorreoFrom());
			
			
			genericAdapter.sendMailCopiaOculta(mailsPara, mailsCC, titulo, generateBodyMailVenta(dtoEmailReserva), adjuntos, mailsBCC);
		}
	
	public DtoEmailReserva rellenarDtoEmailReserva(ExpedienteComercial expediente, boolean contratoReserva) {
		DtoEmailReserva dtoEmailReserva = new DtoEmailReserva();
		dtoEmailReserva.setNumeroOferta(expediente.getOferta().getNumOferta());
		dtoEmailReserva.setImporteOferta(expediente.getOferta().getImporteOferta());
		dtoEmailReserva.setImporteReserva(expediente.getReserva().getImporteDevuelto());
		if(contratoReserva) {
		dtoEmailReserva.setFechaFirmaReserva(expediente.getReserva().getFechaFirma());
		}
		List<CompradorExpediente> compradoresExpediente = expediente.getCompradores();
		if(compradoresExpediente != null) {
			List<DtoEmailReservaDatosCompradores> listDtoEmailReservaDatosCompradores = new ArrayList<DtoEmailReservaDatosCompradores>();
			for (CompradorExpediente datosCompradores : compradoresExpediente) {
				DtoEmailReservaDatosCompradores dto = new DtoEmailReservaDatosCompradores();
				dto.setNombreCompleto(datosCompradores.getNombreRepresentante()+datosCompradores.getApellidosRepresentante());
				dto.setTipoDocumento(datosCompradores.getTipoDocumentoRepresentante().getDescripcion());
				dto.setDocumento(datosCompradores.getDocumentoRepresentante());
				listDtoEmailReservaDatosCompradores.add(dto);
			}
			dtoEmailReserva.setListaEmailReservaCompradores(listDtoEmailReservaDatosCompradores);
		}
		List<ActivoOferta> activosOfertaExpediente = expediente.getOferta().getActivosOferta();
		if(activosOfertaExpediente != null) {
			List<DtoEmailReservaDatosActivos> listDtoEmailReservaDatosActivos = new ArrayList<DtoEmailReservaDatosActivos>();
			for (ActivoOferta activosOferta : activosOfertaExpediente) {
				DtoEmailReservaDatosActivos dto = new DtoEmailReservaDatosActivos();
				Activo activo = activosOferta.getPrimaryKey().getActivo();
				dto.setId(activosOferta.getPrimaryKey().getActivo().getId());
				dto.setSociedadPropietaria(activo.getPropietarioPrincipal().getNombre());
				dto.setProvincia(activo.getProvincia());
				dto.setMunicipio(activo.getMunicipio());
				dto.setDireccion(activo.getDireccion());
				dto.setParticipacion(activosOferta.getPorcentajeParticipacion());
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				ActivoBbvaActivos activoBbvaActivos = genericDao.get(ActivoBbvaActivos.class, filtro);
				dto.setLineaFactura(activoBbvaActivos.getLineaFactura());
				ActivoInfoRegistral activoInfoRegistral = genericDao.get(ActivoInfoRegistral.class, filtro);
				dto.setFincaRegistral(activoInfoRegistral.getInfoRegistralBien().getNumFinca());
				listDtoEmailReservaDatosActivos.add(dto);
			}
			dtoEmailReserva.setLisDtoEmailReservaDatosActivos(listDtoEmailReservaDatosActivos);
		}
		
		return dtoEmailReserva;
		
	}
	
	
	public List<DtoAdjuntoMail> rellenarDtoAdjuntoMailReserva(ExpedienteComercial expediente, boolean contratoReserva) throws GestorDocumentalException {
		List<DtoAdjuntoMail> listAdjuntoMails = new ArrayList<DtoAdjuntoMail>();
		
		if(gestorDocumentalAdapterApi.modoRestClientActivado()) {
			List<DtoAdjunto> listDtoAdjuntos = gestorDocumentalAdapterApi.getAdjuntosExpedienteComercial(expediente);
			for (DtoAdjunto dtoAdjunto : listDtoAdjuntos) {
				
			}
			
		}else {
			Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente", expediente);
			List<String> subtipoDocumentoCodigos = rellenarSubtipoDocumentoCodigo(contratoReserva);
			for (String string : subtipoDocumentoCodigos) {
				listAdjuntoMails.add(devolverAdjuntoMail(string,order,filtro));
			}
			
		}
		return listAdjuntoMails;
		
	}
	private DtoAdjuntoMail devolverAdjuntoMail(String codigo, Order order, Filter filtro) {
		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "subtipoDocumentoExpediente.codigo",codigo);
		DtoAdjuntoMail adjuntoMail = new DtoAdjuntoMail();
		List<AdjuntoExpedienteComercial> adjuntosRecuperados = genericDao.getListOrdered(AdjuntoExpedienteComercial.class, order,filtro,filtro2);
				
		Adjunto adjunto = adjuntosRecuperados.get(0).getAdjunto();
		adjuntoMail.setAdjunto(adjunto);
		adjuntoMail.setNombre(adjuntosRecuperados.get(0).getNombre());
		
		return adjuntoMail;
	}
	
	private List<String> rellenarSubtipoDocumentoCodigo(boolean contratoReserva){
		List<String> subtipoDocumentoCodigo = new ArrayList<String>();
		if(contratoReserva) {
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_CONTRATO_RESERVA);
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_RESERVA);
		}else {
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_ESCRITURA_COMPRAVENTA);
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_RESERVA);
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_COMPRAVENTA);
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_RESERVA);
		}
		return subtipoDocumentoCodigo;
	}
	
//	private List<String> rellenarCorreosPara(DtoEmailReserva dtoEmailReserva , boolean contratoReserva){
//		List<String> rellenarCorreosPara = new ArrayList<String>();
//		if(contratoReserva) {
//			if(dtoEmailReserva.getListaEmailReservaCompradores().get(0).getNombreCompleto())
//			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_CONTRATO_RESERVA);
//			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_RESERVA);
//		}else {
//			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_ESCRITURA_COMPRAVENTA);
//			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_RESERVA);
//			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_COMPRAVENTA);
//			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_RESERVA);
//		}
//		return subtipoDocumentoCodigo;
//	}
	
}

	
	

