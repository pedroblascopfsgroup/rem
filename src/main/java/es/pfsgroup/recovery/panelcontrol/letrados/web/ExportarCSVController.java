package es.pfsgroup.recovery.panelcontrol.letrados.web;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.FileManagerImpl;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.panelcontrol.letrados.api.PanelControlLetradosApi;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoDetallePanelControlLetrados;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlFiltros;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlLetrados;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelListado;

@Controller
public class ExportarCSVController {
	
	private static final String JSP_FILE_ATTACHMENT = "plugin/panelcontrol/fileAttachment";
	private final String CSV_SEPARATOR_COLUMN = ";";
    private final String CSV_SEPARATOR_ROW = "\n";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;
	
	 @RequestMapping("panelCSV.htm")
	 public String getPanelCSV(DtoPanelControlFiltros dto, Map<String, Object> model) {
	        StringBuilder data = new StringBuilder("NIVEL" + CSV_SEPARATOR_COLUMN + "TOTAL EXPEDIENTES" + CSV_SEPARATOR_COLUMN + "IMPORTE" + CSV_SEPARATOR_COLUMN + "TAREAS VENCIDAS"
	                + CSV_SEPARATOR_COLUMN + "TAREAS PDTES.HOY" + CSV_SEPARATOR_COLUMN + "TAREAS PDTES.SEMANA" + CSV_SEPARATOR_COLUMN + "TAREAS PDTES.MES" + CSV_SEPARATOR_COLUMN
	                + "TAREAS PDTES.MAS MES" + CSV_SEPARATOR_COLUMN + "TAREAS PDTES.MAS AÑO" + CSV_SEPARATOR_COLUMN + "TAREAS FIN.AYER." + CSV_SEPARATOR_COLUMN + "TAREAS FIN.SEMANA"
	                + CSV_SEPARATOR_COLUMN + "TAREAS FIN.MES" + CSV_SEPARATOR_COLUMN + "TAREAS FIN.AÑO" + CSV_SEPARATOR_COLUMN
	                + CSV_SEPARATOR_COLUMN + "TAREAS FIN.MAS AÑO" + CSV_SEPARATOR_ROW);
	        
	        List<DtoPanelControlLetrados> list = proxyFactory.proxy(PanelControlLetradosApi.class).getDatosPorJerarquia(dto);
	        
	        for (DtoPanelControlLetrados o : list) {
	        	data.append((o.getNivel() == null ? "" : o.getNivel()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTotalExpedientes() == null ? "" : o.getTotalExpedientes()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getImporte()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasVencidas() == null ? "" : o.getTareasVencidas()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasPendientesHoy() == null ? "" : o.getTareasPendientesHoy()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasPendientesSemana() == null ? "" : o.getTareasPendientesSemana()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasPendientesMes() == null ? "" : o.getTareasPendientesMes()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasPendientesMasMes() == null ? "" : o.getTareasPendientesMasMes()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasPendientesMasAnyo() == null ? "" : o.getTareasPendientesMasAnyo()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasFinalizadasAyer() == null ? "" : o.getTareasFinalizadasAyer()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasFinalizadasSemana() == null ? "" : o.getTareasFinalizadasSemana()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasFinalizadasMes() == null ? "" : o.getTareasFinalizadasMes()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasFinalizadasAnyo() == null ? "" : o.getTareasFinalizadasAnyo()) + CSV_SEPARATOR_COLUMN);
	            data.append((o.getTareasFinalizadas() == null ? "" : o.getTareasFinalizadas()) + CSV_SEPARATOR_ROW);
	        }
	    
	        FileItem file = getCSV(data.toString(), "ListadoPanel");
	
	        model.put("fileItem", file);
		 	return JSP_FILE_ATTACHMENT;

	    }

	 @SuppressWarnings("unchecked")
	@RequestMapping("tareasCSV.htm")
	 public String getTareasCSV(DtoDetallePanelControlLetrados dto, Map<String, Object> model) {
		   StringBuilder data = new StringBuilder("");
		
		     List<String> tituloColumnas =proxyFactory.proxy(PanelControlLetradosApi.class).getTituloColumnas(dto.getTipo());
		     int numeroColumnas =proxyFactory.proxy(PanelControlLetradosApi.class).getNumeroColumnas(dto.getTipo());
		     int contador=1;
		    
		     for (String titulo: tituloColumnas) {
		    	 if (contador==numeroColumnas)
		    	 	data.append(titulo + CSV_SEPARATOR_ROW);
		    	 else
		    		data.append(titulo + CSV_SEPARATOR_COLUMN);
		    	 contador++;
		     }
		     
			 List<Map<String, Object>> listaDatos =proxyFactory.proxy(PanelControlLetradosApi.class).getTareasListadoExcel(dto);
		
			 int contadorFilas=1;
			 String separador="";
			 
			 for (Map<String, Object> mapValores: listaDatos) {
		    	 for (Entry<String, Object> dato : mapValores.entrySet()) {
		    		 if (contadorFilas<numeroColumnas){
		    			 data.append((dato.getValue() == null ? "" : dato.getValue()) + CSV_SEPARATOR_COLUMN);
		    		 }else{
			    		 separador=(contadorFilas % numeroColumnas == 0) ? CSV_SEPARATOR_ROW : CSV_SEPARATOR_COLUMN;
			    		 data.append((dato.getValue() == null ? "" : dato.getValue()) + separador);
		    		 }
		    		 contadorFilas++;
		    	 }
		    	 
		     }
			
		        FileItem file = getCSV(data.toString(), "ListadoTareas");
		
		        model.put("fileItem", file);
			 	return JSP_FILE_ATTACHMENT;
	 }
	 
	@SuppressWarnings("unchecked")
	@RequestMapping("expedientesCSV.htm")
	 public String getExpedientesCSV(DtoDetallePanelControlLetrados dto, Map<String, Object> model) {
	     StringBuilder data = new StringBuilder("");

	     List<String> tituloColumnas =proxyFactory.proxy(PanelControlLetradosApi.class).getTituloColumnas(dto.getTipo());
	     int numeroColumnas =proxyFactory.proxy(PanelControlLetradosApi.class).getNumeroColumnas(dto.getTipo());
	     int contador=1;
	     for (String titulo: tituloColumnas) {
	    	 if (contador==numeroColumnas)
	    	 	data.append(titulo + CSV_SEPARATOR_ROW);
	    	 else
	    		data.append(titulo + CSV_SEPARATOR_COLUMN);
	    	 contador++;
	     }
	     
		 List<Map<String, Object>> listaDatos =proxyFactory.proxy(PanelControlLetradosApi.class).getAsuntosListadoExcel(dto);
		 
		 int contadorFilas=1;
		 String separador="";
		 
		 for (Map<String, Object> mapValores: listaDatos) {
	    	 for (Entry<String, Object> dato : mapValores.entrySet()) {
	    		 if (contadorFilas<numeroColumnas){
	    			 data.append((dato.getValue() == null ? "" : dato.getValue()) + CSV_SEPARATOR_COLUMN);
	    		 }else{
		    		 separador=(contadorFilas % numeroColumnas == 0) ? CSV_SEPARATOR_ROW : CSV_SEPARATOR_COLUMN;
		    		 data.append((dato.getValue() == null ? "" : dato.getValue()) + separador);
	    		 }
	    		 contadorFilas++;
	    	 }
	    	 
	     }

	        FileItem file = getCSV(data.toString(), "ListadoExpedientes");
	
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
