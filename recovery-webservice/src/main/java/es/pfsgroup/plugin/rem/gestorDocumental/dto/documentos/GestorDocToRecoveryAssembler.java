package es.pfsgroup.plugin.rem.gestorDocumental.dto.documentos;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.IdentificacionDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;

public class GestorDocToRecoveryAssembler {
	
	//private static final String TIPO_EXPEDIENTE_DOCUMENTOS_GASTO = "AI";
	private static final Map<String, String> contents;
	
	static {
		contents = new HashMap<String, String>();
		contents.put(".csv", "text/csv");
		contents.put(".doc", "application/msword");
		contents.put(".htm", "text/html");
		contents.put(".me", "application/x-troff-me");
		contents.put(".ppt", "application/vnd.ms-powerpoint");
		contents.put(".xml", "text/xml");
		contents.put(".eml", "message/rfc822");
		contents.put(".zip", "application/x-zip-compressed");
		contents.put(".gif", "image/gif");
		contents.put(".pps", "application/vnd.ms-pps");
		contents.put(".xlsm", "application/vnd.ms-excel.sheet.macroEnabled.12");
		contents.put(".txt", "text/plain");
		contents.put(".xlk", "application/octet-stream");
		contents.put(".css", "text/css");
		contents.put(".mpt", "application/vnd.ms-project");
		contents.put(".docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
		contents.put(".js", "application/javascript");
		contents.put(".url", "application/x-url");
		contents.put(".xls", "application/vnd.ms-excel");
		contents.put(".bmp", "image/bmp");
		contents.put(".mpp", "application/vnd.ms-project");
		contents.put(".rar", "application/x-rar-compressed");
		contents.put(".rtf", "application/rtf");
		contents.put(".tif", "image/tiff");
		contents.put(".xlsb", "application/vnd.ms-excel.sheet.binary.macroEnabled.12");
		contents.put(".odt", "application/vnd.oasis.opendocument.text");
		contents.put(".pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation");
		contents.put(".docm", "application/vnd.ms-word.document.macroEnabled.12");
		contents.put(".html", "text/html");
		contents.put(".log", "application/octet-stream");
		contents.put(".jpeg", "image/pjpeg");
		contents.put(".jpg", "image/jpeg");
		contents.put(".ods", "application/vnd.oasis.opendocument.spreadsheet");
		contents.put(".msg", "application/vnd.ms-outlook-template");
		contents.put(".pdf", "application/pdf");
		contents.put(".dot", "application/msword");
		contents.put(".tiff", "image/tiff");
		contents.put(".exe", "application/x-exe");
		contents.put(".png", "image/png");
		contents.put(".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	}
	
	private static final Log logger = LogFactory.getLog(GestorDocToRecoveryAssembler.class);

	public static List<DtoAdjunto> getListDtoAdjunto(RespuestaDocumentosExpedientes documentosExp) {

		List<DtoAdjunto> list = new ArrayList<DtoAdjunto>();
		
		if (!Checks.esNulo(documentosExp)) {
			// TODO Hay que setear todos los campos. Falta saber que campo del GD va con el de Recovery
			for (IdentificacionDocumento idnDoc : documentosExp.getDocumentos()) {
				DtoAdjunto dtoAdj = new DtoAdjunto();
				dtoAdj.setId(new Long(idnDoc.getIdentificadorNodo()));
				dtoAdj.setIdEntidad(new Long(idnDoc.getId_activo()));
				dtoAdj.setNombre(idnDoc.getNombreNodo());
				dtoAdj.setCodigoTipo(idnDoc.getTdn1() + "-" + idnDoc.getTdn2());
				dtoAdj.setDescripcionTipo("");
				dtoAdj.setContentType(null);
				dtoAdj.setTamanyo(null);
				dtoAdj.setDescripcion(idnDoc.getDescripcionDocumento());
				dtoAdj.setMatricula(idnDoc.getTipoExpediente() +"-"+idnDoc.getSerieDocumental()+"-"+idnDoc.getTdn1()+"-"+idnDoc.getTdn2());
						        
				Date fechaDocumento = null;
				if(!Checks.esNulo(idnDoc.getFechaDocumento())){
					fechaDocumento = new Timestamp(stringToDate(idnDoc.getFechaDocumento()).getTime());
				    }
				dtoAdj.setFechaDocumento(fechaDocumento);
				Date createDate = null;
				if(!Checks.esNulo(idnDoc.getCreatedate())){
					createDate = new Timestamp(stringToDate(idnDoc.getCreatedate()).getTime());
				    }
				dtoAdj.setCreateDate(createDate);
				dtoAdj.setFileSize(idnDoc.getFileSize());
				dtoAdj.setId_activo(idnDoc.getId_activo());
				dtoAdj.setRel(idnDoc.getRel());
				dtoAdj.setTdn2_desc(idnDoc.getTdn2_desc());
				dtoAdj.setTipoExpediente(idnDoc.getTipoExpediente());
				
				
				list.add(dtoAdj);
			}
		}


		return list;
	}
	
	public static FileItem getFileItem(RespuestaDescargarDocumento descargar) throws IOException {
		
		String nomFichero = descargar.getNombreDocumento();
		String ext = null;
		String contentType = descargar.getContentType();
		
		if(descargar.getNombreDocumento().contains(".")){
			
			nomFichero = descargar.getNombreDocumento().substring(0, descargar.getNombreDocumento().lastIndexOf("."));
			ext =descargar.getNombreDocumento().substring(descargar.getNombreDocumento().lastIndexOf("."));
			
			if(Checks.esNulo(descargar.getContentType())){
				contentType = contents.get(ext.toLowerCase());
			}
		}
		
		if(!Checks.esNulo(contentType) && Checks.esNulo(ext)){
			for (Map.Entry<String, String> entry : contents.entrySet())
			{
				if(entry.getValue().equals(contentType)){
					ext = entry.getKey();
				}
			}
		}
		
		File fileSalidaTemporal = null;
		FileItem resultado = new FileItem();
		InputStream stream =  new ByteArrayInputStream(ArrayUtils.toPrimitive(descargar.getContenido()));
		
		fileSalidaTemporal = File.createTempFile(nomFichero, ext);
		fileSalidaTemporal.deleteOnExit();
		
		resultado.setFileName(nomFichero + ext);
		if(!Checks.esNulo(contentType)) {
			resultado.setContentType(contentType);	
		}		
		resultado.setFile(fileSalidaTemporal);
        OutputStream outputStream = resultado.getOutputStream(); // Last step is to get FileItem's output stream, and write your inputStream in it. This is the way to write to your FileItem.
        IOUtils.copy(stream, outputStream);
		outputStream.close();
		return resultado;			
	}
	
	private static Date stringToDate(String strDate){
		List<String> patrones = new ArrayList<String>();
		patrones.add("yyyy-MM-dd'T'HH:mm:ss");
		patrones.add("dd/MM/yyyy");
	   
		    for(String patron: patrones){
		    	SimpleDateFormat sdf = new SimpleDateFormat(patron);
		    	try{
		    		return sdf.parse(strDate);
		    	} catch (ParseException e) {
		    }
		}
		throw new IllegalArgumentException("Invalid input for date. Given '"+strDate+"', expecting format yyyy-MM-dd'T'HH:mm:ss or dd/MM/yyyy.");
	}

}
