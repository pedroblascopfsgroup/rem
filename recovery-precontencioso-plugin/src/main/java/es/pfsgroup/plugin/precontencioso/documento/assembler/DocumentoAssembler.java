package es.pfsgroup.plugin.precontencioso.documento.assembler;

import java.text.SimpleDateFormat;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudDocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DDSiNoNoAplica;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;

/**
 * Clase que se encarga de ensablar las entidades de documentosPCO y solicitudesPCO a 
 * sus correspondientes DTO
 * 
 * @author jmartin
 */
public class DocumentoAssembler {
	
	
	private static SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");
	
	/**
	 * Convierte en una SolicitudDocumentoDTO a partir de un documentoPCO y 
	 * una solicitudPCO
	 * 
	 * @param List<liquidacionesPCO> entity
	 * @return List<liquidacionDTO> DTO
	 */
	public static SolicitudDocumentoPCODto docAndSolEntityToSolicitudDto(DocumentoPCO documento,
			SolicitudDocumentoPCO solicitud, String ugIdDto, String descripcionUG, boolean esDocumento, 
			boolean tieneSolicitud, DDSiNo siNo, DDSiNoNoAplica siNoAplica, Long idIdentificativo) {
		SolicitudDocumentoPCODto solicitudDto = new SolicitudDocumentoPCODto();
				
		solicitudDto.setIdIdentificativo(idIdentificativo + "");
		solicitudDto.setIdDoc(documento.getId());
		solicitudDto.setTieneSolicitud(tieneSolicitud);
		solicitudDto.setEsDocumento(esDocumento);	
		solicitudDto.setCodigoEstadoDocumento(documento.getEstadoDocumento().getCodigo());

		if (esDocumento){			
			solicitudDto.setContrato(ugIdDto);
			solicitudDto.setDescripcionUG(descripcionUG);
			solicitudDto.setTipoDocumento(documento.getTipoDocumento().getDescripcion());
			solicitudDto.setEstado(documento.getEstadoDocumento().getDescripcion());
			solicitudDto.setAdjunto(siNo.getDescripcion());	
			if (!Checks.esNulo(siNoAplica)) {
				solicitudDto.setEjecutivo(siNoAplica.getDescripcion());
			}
			solicitudDto.setComentario(documento.getObservaciones());
		}
		
		if (tieneSolicitud){
			solicitudDto.setId(solicitud.getId());
			if (solicitud.getActor()!=null)
				solicitudDto.setActor(solicitud.getActor().getUsuario().getApellidoNombre());
			if (solicitud.getTipoActor()!=null)
				solicitudDto.setTipoActor(solicitud.getTipoActor().getDescripcion());
			if (solicitud.getFechaSolicitud()!=null)
				solicitudDto.setFechaSolicitud(webDateFormat.format(solicitud.getFechaSolicitud()));
			if (solicitud.getFechaResultado()!=null)
				solicitudDto.setFechaResultado(webDateFormat.format(solicitud.getFechaResultado()));
			if (solicitud.getFechaEnvio()!=null)
				solicitudDto.setFechaEnvio(webDateFormat.format(solicitud.getFechaEnvio()));
			if (solicitud.getFechaRecepcion()!=null)
				solicitudDto.setFechaRecepcion(webDateFormat.format(solicitud.getFechaRecepcion()));
			if (solicitud.getResultadoSolicitud()!=null)
				solicitudDto.setResultado(solicitud.getResultadoSolicitud().getDescripcion());
			if(!Checks.esNulo(solicitud.getSolicitante())){
				solicitudDto.setSolicitante(solicitud.getSolicitante().getUsuario().getApellidoNombre());
			}

		}


		return solicitudDto;
	}
	
	public static DocumentoPCODto docEntityToDocumentoDto(DocumentoPCO documento, DDSiNo siNo, DDSiNoNoAplica siNoAplica) {
		DocumentoPCODto doc = new DocumentoPCODto();
		doc.setId(documento.getId());
		doc.setIdProc(documento.getProcedimientoPCO().getId());
		doc.setTipoUG(documento.getUnidadGestion().getDescripcion());
		doc.setContrato(documento.getProcedimientoPCO().getCntPrincipal());
		doc.setDescripcionUG(documento.getUgDescripcion());
		doc.setTipoDocumento(documento.getTipoDocumento().getDescripcion());
		doc.setEstado(documento.getEstadoDocumento().getDescripcion());
		doc.setAdjunto(siNo.getDescripcion());
		if (!Checks.esNulo(siNoAplica)) {
			doc.setEjecutivo(siNoAplica.getDescripcion());
		}
		doc.setComentario(documento.getObservaciones());
		doc.setAsiento(documento.getAsiento());
		doc.setFinca(documento.getFinca());
		doc.setFolio(documento.getFolio());
		doc.setIdufir(documento.getIdufir());
		doc.setLibro(documento.getLibro());
		doc.setNotario(documento.getNotario());
		doc.setNumFinca(documento.getNroFinca());
		doc.setNumRegistro(documento.getNroRegistro());
		doc.setProtocolo(documento.getProtocolo());
		doc.setTomo(documento.getTomo());
		doc.setPlaza(documento.getPlaza());
		if (documento.getFechaEscritura()!=null)
			doc.setFechaEscritura(webDateFormat.format(documento.getFechaEscritura()));		
		
		return doc;
	}

}
