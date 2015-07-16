package es.pfsgroup.plugin.precontencioso.documento.assembler;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudDocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

/**
 * Clase que se encarga de ensablar las entidades de documentosPCO y solicitudesPCO a 
 * sus correspondientes DTO
 * 
 * @author jmartin
 */
public class DocumentoAssembler {

	/**
	 * Convierte en una SolicitudDocumentoDTO a partir de un documentoPCO y 
	 * una solicitudPCO
	 * 
	 * @param List<liquidacionesPCO> entity
	 * @return List<liquidacionDTO> DTO
	 */
	public static SolicitudDocumentoPCODto docAndSolEntityToSolicitudDto(DocumentoPCO documento,
			SolicitudDocumentoPCO solicitud) {
		SolicitudDocumentoPCODto solicitudDto = new SolicitudDocumentoPCODto();
		
		SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");
		
		Long antIdDoc = new Long(0);
		Long antTipoUG = new Long(0);
		Long antTipoDoc = new Long(0);
		
		solicitudDto.setId(solicitud.getId());
		solicitudDto.setIdDoc(documento.getId());
		solicitudDto.setEsDocumento(false);
		if (!antIdDoc.equals(documento.getId()) || antTipoUG != documento.getUnidadGestion().getId() || antTipoDoc != documento.getTipoDocumento().getId()){
			solicitudDto.setContrato(documento.getProcedimientoPCO().getCntPrincipal());
			solicitudDto.setDescripcionUG(documento.getUgDescripcion());
			solicitudDto.setTipoDocumento(documento.getTipoDocumento().getDescripcion());
			solicitudDto.setEstado(documento.getEstadoDocumento().getDescripcion());
			solicitudDto.setAdjunto("NO");
			if (documento.getAdjuntado())
				solicitudDto.setAdjunto("SI");
		
			solicitudDto.setComentario(documento.getObservaciones());
			solicitudDto.setEsDocumento(true);
			
			antIdDoc = documento.getId();
			antTipoUG = documento.getUnidadGestion().getId();
			antTipoDoc = documento.getTipoDocumento().getId();
		}
		//solicitudDto.setActor(sol.getActor());
		if (solicitud.getFechaSolicitud()!=null)
			solicitudDto.setFechaSolicitud(webDateFormat.format(solicitud.getFechaSolicitud()));
		if (solicitud.getFechaResultado()!=null)
			solicitudDto.setFechaResultado(webDateFormat.format(solicitud.getFechaResultado()));
		if (solicitud.getFechaEnvio()!=null)
			solicitudDto.setFechaEnvio(webDateFormat.format(solicitud.getFechaEnvio()));
		if (solicitud.getFechaRecepcion()!=null)
			solicitudDto.setFechaRecepcion(webDateFormat.format(solicitud.getFechaRecepcion()));
		solicitudDto.setResultado(solicitud.getResultadoSolicitud().getDescripcion());

		return solicitudDto;
	}
	
	public static DocumentoPCODto docEntityToDocumentoDto(DocumentoPCO documento) {
		DocumentoPCODto doc = new DocumentoPCODto();
		doc.setId(documento.getId());
		doc.setIdProc(documento.getProcedimientoPCO().getId());
		doc.setTipoUG(documento.getUnidadGestion().getDescripcion());
		doc.setContrato(documento.getProcedimientoPCO().getCntPrincipal());
		doc.setDescripcionUG(documento.getUgDescripcion());
		doc.setTipoDocumento(documento.getTipoDocumento().getDescripcion());
		doc.setEstado(documento.getEstadoDocumento().getDescripcion());
		doc.setAdjunto("NO");
		if (documento.getAdjuntado())
			doc.setAdjunto("SI");
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
		
		return doc;
	}

}
