package es.pfsgroup.plugin.rem.gestorDocumental.dto.documentos;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

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

	private static final Log logger = LogFactory.getLog(GestorDocToRecoveryAssembler.class);

	public static List<DtoAdjunto> getListDtoAdjunto(RespuestaDocumentosExpedientes documentosExp) {

		List<DtoAdjunto> list = new ArrayList<DtoAdjunto>();
		
		if (!Checks.esNulo(documentosExp)) {
			// TODO Hay que setear todos los campos. Falta saber que campo del GD va con el de Recovery
			for (IdentificacionDocumento idnDoc : documentosExp.getDocumentos()) {
				DtoAdjunto dtoAdj = new DtoAdjunto();
				dtoAdj.setId(new Long(idnDoc.getIdentificadorNodo()));
				dtoAdj.setIdActivo(new Long(idnDoc.getIdExpedienteHaya()));
//				dtoAdj.setIdTrabajo(null);
				dtoAdj.setNombre(idnDoc.getNombreNodo());
				dtoAdj.setCodigoTipo(idnDoc.getTdn1() + "-" + idnDoc.getTdn2());
				dtoAdj.setDescripcionTipo("");
				dtoAdj.setContentType(null);
				dtoAdj.setTamanyo(null);
				dtoAdj.setDescripcion(null);
				dtoAdj.setFechaDocumento(null);
				
				list.add(dtoAdj);
			}
		}


		return list;
	}
	
	public static FileItem getFileItem(RespuestaDescargarDocumento descargar) throws IOException {
		
		String nomFichero = descargar.getNombreDocumento().substring(0, descargar.getNombreDocumento().lastIndexOf("."));
		String ext = descargar.getNombreDocumento().substring(descargar.getNombreDocumento().lastIndexOf("."));
		
		File fileSalidaTemporal = null;
		FileItem resultado = new FileItem();
		InputStream stream =  new ByteArrayInputStream(ArrayUtils.toPrimitive(descargar.getContenido()));
		
		fileSalidaTemporal = File.createTempFile(nomFichero, "."+ext);
		fileSalidaTemporal.deleteOnExit();
		
		resultado.setFileName(nomFichero + ext);
		resultado.setContentType("");			
		resultado.setFile(fileSalidaTemporal);
        OutputStream outputStream = resultado.getOutputStream(); // Last step is to get FileItem's output stream, and write your inputStream in it. This is the way to write to your FileItem.
        int read = 0;
		byte[] bytes = new byte[1024];

		while ((read = stream.read(bytes)) != -1) {
			outputStream.write(bytes, 0, read);
		}

		outputStream.close();
		return resultado;		
	}

}
