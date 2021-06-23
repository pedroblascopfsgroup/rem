package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.ExpedienteComercialAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.controller.OperacionVentaController;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoBbvaActivos;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoEmailReserva;
import es.pfsgroup.plugin.rem.model.DtoEmailReservaDatosActivos;
import es.pfsgroup.plugin.rem.model.DtoEmailReservaDatosCompradores;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TSCConfigSociedadCorreo;
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
	
	@Autowired
	private ExpedienteComercialAdapter expedienteAdapter;
	
	@Autowired
	private OperacionVentaController operacionVentaController;
	
	public void notificatorFinTareaConValores(ExpedienteComercial expediente,boolean contratoReserva) throws GestorDocumentalException {
		
			DtoEmailReserva dtoEmailReserva = rellenarDtoEmailReserva(expediente, contratoReserva);
			List<String> mails = new ArrayList<String>();
			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			List<String> mailsBCC = new ArrayList<String>();
			List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
			adjuntos = rellenarDtoAdjuntoMailReserva(expediente,contratoReserva, true);
			mails = rellenarCorreos(dtoEmailReserva);
			for (String mailsSeparados : mails) {
				String [] a = mailsSeparados.split("-");
				if(a[1].equals("true")) {
					mailsCC.add(a[0]);
				}else {
					mailsPara.add(a[0]);
				}
			}
			if(!mailsPara.isEmpty()) {
				String correos = null;
				String titulo = "";
				
				if(contratoReserva) {
					titulo = "Reserva oferta " + expediente.getOferta().getNumOferta() + " - Importe reserva "+ dtoEmailReserva.getImporteReserva() +"";
					
				}else {
					titulo = "Venta oferta " + expediente.getOferta().getNumOferta() + " - Importe oferta "+ dtoEmailReserva.getImporteOferta() +"";
				}
				mailsBCC.add(J_POYATOS_CORREO);
				genericAdapter.sendMailCopiaOculta(mailsPara, mailsCC, titulo, generateBodyMailVenta(dtoEmailReserva), adjuntos, mailsBCC);
			}
		}
	
	public DtoEmailReserva rellenarDtoEmailReserva(ExpedienteComercial expediente, boolean contratoReserva) {
		DtoEmailReserva dtoEmailReserva = new DtoEmailReserva();
		dtoEmailReserva.setNumeroOferta(expediente.getOferta().getNumOferta());
		dtoEmailReserva.setImporteReserva(expediente.getCondicionante().getImporteReserva());
		dtoEmailReserva.setImporteOferta(expediente.getOferta().getImporteOferta());
		if(expediente.getReserva()!=null && contratoReserva) {
			dtoEmailReserva.setFechaFirmaReserva(expediente.getReserva().getFechaFirma());
		}
		
		if(!contratoReserva) {
			dtoEmailReserva.setFechaVenta(expediente.getFechaVenta());
		}
		
		List<CompradorExpediente> compradoresExpediente = expediente.getCompradores();
		if(compradoresExpediente != null) {
			List<DtoEmailReservaDatosCompradores> listDtoEmailReservaDatosCompradores = new ArrayList<DtoEmailReservaDatosCompradores>();
			for (CompradorExpediente datosCompradores : compradoresExpediente) {
				DtoEmailReservaDatosCompradores dto = new DtoEmailReservaDatosCompradores();
				Comprador comprador = datosCompradores.getPrimaryKey().getComprador();
				dto.setNombreCompleto(comprador.getNombre() + " " + comprador.getApellidos());
				if(comprador.getTipoDocumento() != null) {
					dto.setTipoDocumento(comprador.getTipoDocumento().getDescripcion());	
				}
				if(comprador.getDocumento() != null) {
					dto.setDocumento(comprador.getDocumento());
				}
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
				if(activo.getPropietarioPrincipal() != null) {
					dto.setSociedadPropietaria(activo.getPropietarioPrincipal().getNombre());
					if(activo.getPropietarioPrincipal().getdDTSPTipoCorreo() != null) {
						dto.setTipoCorreo(activo.getPropietarioPrincipal().getdDTSPTipoCorreo().getCodigo());
					}
				}	
				dto.setProvincia(activo.getProvincia());
				dto.setMunicipio(activo.getMunicipio());
				dto.setDireccion(activo.getDireccion());
				dto.setParticipacion(activosOferta.getPorcentajeParticipacion());
				if(activo.getPropietarioPrincipal().getdDTSPTipoCorreo() != null) {
					dto.setTipoCorreo(activo.getPropietarioPrincipal().getdDTSPTipoCorreo().getCodigo());
				}
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				ActivoBbvaActivos activoBbvaActivos = genericDao.get(ActivoBbvaActivos.class, filtro);
				if(activoBbvaActivos != null) {
				dto.setLineaFactura(activoBbvaActivos.getLineaFactura());
				}
				ActivoInfoRegistral activoInfoRegistral = genericDao.get(ActivoInfoRegistral.class, filtro);
				if(activoInfoRegistral != null) {
				dto.setFincaRegistral(activoInfoRegistral.getInfoRegistralBien().getNumFinca());
				}
				listDtoEmailReservaDatosActivos.add(dto);
			}
			dtoEmailReserva.setLisDtoEmailReservaDatosActivos(listDtoEmailReservaDatosActivos);
		}
		
		return dtoEmailReserva;
		
	}
	
	
	public List<DtoAdjuntoMail> rellenarDtoAdjuntoMailReserva(ExpedienteComercial expediente, boolean contratoReserva, boolean generarHojaDatosFormalizacion) throws GestorDocumentalException{
		List<DtoAdjuntoMail> listAdjuntoMails = new ArrayList<DtoAdjuntoMail>();
		List<String> subtipoDocumentoCodigos = rellenarSubtipoDocumentoCodigo(contratoReserva);
		
		if(gestorDocumentalAdapterApi.modoRestClientActivado()) {
			listAdjuntoMails.addAll(rellenarAdjuntosGD(subtipoDocumentoCodigos, expediente));
		}else {
			Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
			for (String string : subtipoDocumentoCodigos) {
				listAdjuntoMails.add(devolverAdjuntoMail(string,order,filtro));
			}
			
		}

		if(generarHojaDatosFormalizacion && !contratoReserva) {
			File hojaDatosFormalizacion = operacionVentaController.generarPdfOperacionVentaByOfertaHre(expediente.getNumExpediente(), null);
			FileItem hojaDatosFileItem = new FileItem(hojaDatosFormalizacion);
			
			
			DtoAdjuntoMail hojaDatosAdj = new DtoAdjuntoMail();
			
			hojaDatosAdj.setNombre(hojaDatosFormalizacion.getName());
			hojaDatosAdj.setAdjunto(new Adjunto(hojaDatosFileItem));			
			listAdjuntoMails.add(hojaDatosAdj);
		}
		return listAdjuntoMails;
		
	}
	private DtoAdjuntoMail devolverAdjuntoMail(String codigo, Order order, Filter filtro) {
		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "subtipoDocumentoExpediente.codigo",codigo);
		DtoAdjuntoMail adjuntoMail = new DtoAdjuntoMail();
		List<AdjuntoExpedienteComercial> adjuntosRecuperados = genericDao.getListOrdered(AdjuntoExpedienteComercial.class, order,filtro,filtro2);
		for (AdjuntoExpedienteComercial adjuntoExpedienteComercial : adjuntosRecuperados) {
			if(adjuntoExpedienteComercial != null) {		
				Adjunto adjunto = adjuntoExpedienteComercial.getAdjunto();
				adjuntoMail.setAdjunto(adjunto);
				adjuntoMail.setNombre(adjuntoExpedienteComercial.getNombre());
				}
		}
		return adjuntoMail;
	}
	
	private List<String> rellenarSubtipoDocumentoCodigo(boolean contratoReserva){
		List<String> subtipoDocumentoCodigo = new ArrayList<String>();
		if(contratoReserva) {
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_CONTRATO_RESERVA);
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_RESERVA);
		}else {
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_ESCRITURA_COMPRAVENTA);
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_FICHA_ESCRITURA_INMUEBLE);
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_COMPRAVENTA);
			subtipoDocumentoCodigo.add(DDSubtipoDocumentoExpediente.CODIGO_COPIA_SIMPLE);
		}
		return subtipoDocumentoCodigo;
	}
	
	private List<String> rellenarCorreos(DtoEmailReserva dtoEmailReserva){
		Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
		List<String> rellenarCorreosPara = new ArrayList<String>();
		String codigoTipoCorreo = dtoEmailReserva.getLisDtoEmailReservaDatosActivos().get(0).getTipoCorreo();
		if(codigoTipoCorreo != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "dDTSPTipoCorreo.codigo",codigoTipoCorreo);
			List<TSCConfigSociedadCorreo> configSociedadCorreo = genericDao.getListOrdered(TSCConfigSociedadCorreo.class, order,filtro);
			for (TSCConfigSociedadCorreo tscConfigSociedadCorreo : configSociedadCorreo) {
				if(tscConfigSociedadCorreo.isTipoCorreo()) {
				rellenarCorreosPara.add(tscConfigSociedadCorreo.getCorreo()+"-true");
				}else {
				rellenarCorreosPara.add(tscConfigSociedadCorreo.getCorreo()+"-false");
				}
			}
		}
		return rellenarCorreosPara;
	}
	
	private List<String> rellenarMatriculas(List<String> subtipoDocumentoCodigos){
		List<String> rellenarMatriculas = new ArrayList<String>();
		for (String string : subtipoDocumentoCodigos) {
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo",string);
			DDSubtipoDocumentoExpediente subtipoDocumentoExpediente = genericDao.get(DDSubtipoDocumentoExpediente.class, filtro1);
			if(subtipoDocumentoExpediente != null) {
				rellenarMatriculas.add(subtipoDocumentoExpediente.getMatricula());
			}
		}
		
		return rellenarMatriculas;
		
	}
	
	private List<DtoAdjuntoMail> rellenarAdjuntosGD(List<String>subtipoDocumentoCodigos,ExpedienteComercial expediente) throws GestorDocumentalException{
		List<DtoAdjuntoMail> listAdjuntoMails = new ArrayList<DtoAdjuntoMail>();
		List<String> matriculasList = rellenarMatriculas(subtipoDocumentoCodigos);
		List<DtoAdjunto> listDtoAdjuntos = gestorDocumentalAdapterApi.getAdjuntosExpedienteComercial(expediente);
		for (DtoAdjunto dtoAdjunto : listDtoAdjuntos) {
			if(matriculasList.contains(dtoAdjunto.getMatricula())) {
				if (!Checks.esNulo(dtoAdjunto.getId())) {
					FileItem fileItem = null;
					DtoAdjuntoMail adj = new DtoAdjuntoMail();
					adj.setNombre(dtoAdjunto.getNombre());
					try {
						 fileItem = expedienteAdapter.downloadExpediente(dtoAdjunto.getId(), dtoAdjunto.getNombre());
					} catch (UserException e) {
						logger.error(e.getMessage(), e);
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
					if (!Checks.esNulo(fileItem)) {
						adj.setAdjunto(new Adjunto(fileItem));
					}

					listAdjuntoMails.add(adj);
				}
			}
			
		}
		return listAdjuntoMails;
	}
	
}
	
	

