package es.pfsgroup.recovery.recobroWeb.accionesExtrajudiciales.controller.impl;

import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.FileManagerImpl;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.manager.api.RecobroAccionesExtrajudicialesManagerApi;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroAccionesExtrajudiciales;
import es.pfsgroup.recovery.recobroWeb.accionesExtrajudiciales.controller.api.ExportarCSVRecobroControllerApi;

/**
 * @author manuel
 * Controller usado para exportar a excel el listado de acciones.
 *
 */
@Controller
public class ExportarCSVRecobroController implements ExportarCSVRecobroControllerApi{
	
	private static final String JSP_FILE_ATTACHMENT = "plugin/recobroWeb/fileAttachment";
	private final String CSV_SEPARATOR_COLUMN = ";";
    private final String CSV_SEPARATOR_ROW = "\n";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@RequestMapping
	 public String getAccionesExpedienteCSV(RecobroAccionesExtrajudicialesExpedienteDto dto, Map<String, Object> model) {
	        StringBuilder data = new StringBuilder("ID" + CSV_SEPARATOR_COLUMN + "ID ACCION" + CSV_SEPARATOR_COLUMN + "ID ENVIO" + CSV_SEPARATOR_COLUMN 
	        		+ "BBDD ORIGEN NUEVO DATO" + CSV_SEPARATOR_COLUMN + "CODIGO CONTRATO" + CSV_SEPARATOR_COLUMN + "HORA GESTION" + CSV_SEPARATOR_COLUMN
	        		+ "NUEVO DOMICILIO" + CSV_SEPARATOR_COLUMN + "NUEVO TELEFONO" + CSV_SEPARATOR_COLUMN
	                + "OBSERVACIONES" + CSV_SEPARATOR_COLUMN + "TELEFONO" + CSV_SEPARATOR_COLUMN + "TEXTO EXTRA 1" + CSV_SEPARATOR_COLUMN
	                + "TEXTO EXTRA 2" + CSV_SEPARATOR_COLUMN + "TEXTO EXTRA 3" + CSV_SEPARATOR_COLUMN + "TEXTO EXTRA 4" + CSV_SEPARATOR_COLUMN
	                + "TEXTO EXTRA 5" + CSV_SEPARATOR_COLUMN + "AGENCIA" + CSV_SEPARATOR_COLUMN + "CODIGO DIR" + CSV_SEPARATOR_COLUMN
	                + "CODIGO ENTIDAD PERSONA" + CSV_SEPARATOR_COLUMN + "CONTRATO" + CSV_SEPARATOR_COLUMN + "DATO NUEVO CONFIRMADO" + CSV_SEPARATOR_COLUMN
	                + "DATO NUEVO ORIGEN" + CSV_SEPARATOR_COLUMN + "DIRECCION" + CSV_SEPARATOR_COLUMN + "FECHA EXTRA 1" + CSV_SEPARATOR_COLUMN
	                + "FECHA EXTRA 2" + CSV_SEPARATOR_COLUMN + "FECHA EXTRA 3" + CSV_SEPARATOR_COLUMN + "FECHA EXTRA 4" + CSV_SEPARATOR_COLUMN
	                + "FECHA EXTRA 5" + CSV_SEPARATOR_COLUMN + "FECHA EXTRACCION" + CSV_SEPARATOR_COLUMN + "IMPORTE ACEPTADO" + CSV_SEPARATOR_COLUMN
	                + "IMPORTE COMPROMETIDO" + CSV_SEPARATOR_COLUMN + "IMPORTE PROPUESTO" + CSV_SEPARATOR_COLUMN + "NUM EXTRA 1" + CSV_SEPARATOR_COLUMN
	                + "NUM EXTRA 2" + CSV_SEPARATOR_COLUMN + "NUM EXTRA 3" + CSV_SEPARATOR_COLUMN + "NUM EXTRA 4" + CSV_SEPARATOR_COLUMN
	                + "NUM EXTRA 5" + CSV_SEPARATOR_COLUMN + CSV_SEPARATOR_ROW);

	        SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	        dto.setLimit(1000000);
	        
	        Page page = proxyFactory.proxy(RecobroAccionesExtrajudicialesManagerApi.class).getPageAccionesRecobroExpediente(dto);
	        @SuppressWarnings("unchecked")
			List<RecobroAccionesExtrajudiciales> list = (List<RecobroAccionesExtrajudiciales>) page.getResults();
	        
	        for (RecobroAccionesExtrajudiciales ace : list) {
	        	data.append((ace.getId() == null ? "" : ace.getId()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getCodigoAccion() == null ? "" : ace.getCodigoAccion()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getIdEnvio() == null ? "" : ace.getIdEnvio()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getBbddOrigenNuevoDato() == null ? "" : ace.getBbddOrigenNuevoDato()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getCodigoContrato() == null ? "" : ace.getCodigoContrato()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getHoraGestion() == null ? "" : ace.getHoraGestion()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getNuevoDomicilio() == null ? "" : ace.getNuevoDomicilio()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getNuevoTelefono() == null ? "" : ace.getNuevoTelefono()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getObservacionesGestor() == null ? "" : ace.getObservacionesGestor()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getTelefono() == null ? "" : ace.getTelefono()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getTextoExtra1() == null ? "" : ace.getTextoExtra1()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getTextoExtra2() == null ? "" : ace.getTextoExtra2()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getTextoExtra3() == null ? "" : ace.getTextoExtra3()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getTextoExtra4() == null ? "" : ace.getTextoExtra4()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getTextoExtra5() == null ? "" : ace.getTextoExtra5()) + CSV_SEPARATOR_COLUMN);
	        	data.append(((ace.getAgencia() == null || ace.getAgencia().getNombre() == null) ? "" : ace.getAgencia().getNombre()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getCodigoDir() == null ? "" : ace.getCodigoDir()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getCodigoEntidadPersona() == null ? "" : ace.getCodigoEntidadPersona()) + CSV_SEPARATOR_COLUMN);
	        	data.append(((ace.getContrato() == null || ace.getContrato().getCodigoContrato() == null) ? "" : ace.getContrato().getCodigoContrato()) + CSV_SEPARATOR_COLUMN);
	        	data.append(((ace.getDatoNuevoConfirmado() == null || ace.getDatoNuevoConfirmado().getDescripcion() == null) ? "" : ace.getDatoNuevoConfirmado().getDescripcion()) + CSV_SEPARATOR_COLUMN);
	        	data.append(((ace.getDatoNuevoOrigen() == null || ace.getDatoNuevoOrigen().getDescripcion() == null) ? "" : ace.getDatoNuevoOrigen().getDescripcion()) + CSV_SEPARATOR_COLUMN);
	        	data.append(((ace.getDireccion() == null || ace.getDireccion().getDomicilio() == null) ? "" : ace.getDireccion().getDomicilio()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getFechaExtra1() == null ? "" : df.format(ace.getFechaExtra1())) + CSV_SEPARATOR_COLUMN);	        	
	        	data.append((ace.getFechaExtra2() == null ? "" : df.format(ace.getFechaExtra2())) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getFechaExtra3() == null ? "" : df.format(ace.getFechaExtra3())) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getFechaExtra4() == null ? "" : df.format(ace.getFechaExtra4())) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getFechaExtra5() == null ? "" : df.format(ace.getFechaExtra5())) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getFechaExtraccion() == null ? "" : df.format(ace.getFechaExtraccion())) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getImporteAceptado() == null ? "" : ace.getImporteAceptado()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getImporteComprometido() == null ? "" : ace.getImporteComprometido()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getImportePropuesto() == null ? "" : ace.getImportePropuesto()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getNumeroExtra1() == null ? "" : ace.getNumeroExtra1()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getNumeroExtra2() == null ? "" : ace.getNumeroExtra2()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getNumeroExtra3() == null ? "" : ace.getNumeroExtra3()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getNumeroExtra4() == null ? "" : ace.getNumeroExtra4()) + CSV_SEPARATOR_COLUMN);
	        	data.append((ace.getNumeroExtra5() == null ? "" : ace.getNumeroExtra5()) + CSV_SEPARATOR_ROW);	 	        	

	        }
	    
	        FileItem file = getCSV(data.toString(), "ListadoAccionesExpediente");
	
	        model.put("fileItem", file);
		 	return JSP_FILE_ATTACHMENT;

	    }

	private FileItem getCSV(String data, String titulo) {
        FileItem fileItem = FileManagerImpl.getInstance().createTemporaryFileItem();
        String fileName = titulo + ".csv";
     
        fileItem.setFileName(fileName);
        fileItem.setContentType("text/csv");
        fileItem.setLength(data.getBytes().length);
        FileOutputStream outputStream = null;

        try {
            outputStream = new FileOutputStream(fileItem.getFile());
            outputStream.write(data.getBytes("ISO-8859-1"));

        } catch (IOException exception) {
        	 System.out.println(exception);

        } finally {
            if (outputStream != null) try {
                outputStream.close();
            } catch (IOException e) {
                System.out.println(e);
            }
        }
        return fileItem;
    }

}
