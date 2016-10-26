package es.pfsgroup.plugin.rem.controller;

import java.io.EOFException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JRException;
import org.apache.commons.io.IOUtils;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.tools.ant.types.resources.Files;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoCliente;
import es.pfsgroup.plugin.rem.model.DtoOferta;
import es.pfsgroup.plugin.rem.model.DtoPropuestaOferta;
import es.pfsgroup.plugin.rem.model.DtoTasacionInforme;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.PropuestaDto;
import es.pfsgroup.plugin.rem.rest.dto.PropuestaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

@Controller
public class PropuestaresolucionController {
		
		private final Log logger = LogFactory.getLog(getClass());

		private final String CODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
		@Autowired
		private RestApi restApi;
		
		@Autowired 
		private OfertaApi ofertaApi;
		
		@SuppressWarnings("unchecked")
		@RequestMapping(method = RequestMethod.POST, value = "/propuestaresolucion")
		public void propuestaResolucion(ModelMap model, RestRequestWrapper request,HttpServletResponse response) throws ParseException {	
			
			String name = "PropuestaResolucion001";
			String ficheroPlantilla = "jasper/"+name+".jrxml";
			Map<String, Object> mapaValores = new HashMap<String,Object>();
			List<Object> array = new ArrayList();
			
			File fileSalidaTemporal = null;
			Map<String, Object> dataResponse = new HashMap<String, Object>();
			
			PropuestaRequestDto jsonData = null;
			PropuestaDto propuestaDto = null;
			Oferta oferta = null;
			Activo activo = null;
			DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
			
			//OBTENCION DE LOS DATOS PARA RELLENAR EL DOCUMENTO
			try {
				jsonData = (PropuestaRequestDto) request.getRequestData(PropuestaRequestDto.class);
				
				if (Checks.esNulo(jsonData)) {
					model.put("error", RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
					throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				}
				
				model.put("id", jsonData.getId());
				propuestaDto = jsonData.getData();
				
				if (propuestaDto==null || propuestaDto.getOfertaHRE()==null) {
					model.put("error", RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
					throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				}
				oferta = ofertaApi.getOfertaByNumOfertaRem(propuestaDto.getOfertaHRE());
				if (oferta==null) {
					model.put("error", RestApi.REST_NO_RELATED_OFFER);
					throw new Exception(RestApi.REST_NO_RELATED_OFFER);					
				}
				mapaValores.put("NumOfProp", oferta.getNumOferta()+"/1");
				
				//Obteniedo el activo relacionado con la OFERTA
				activo = oferta.getActivoPrincipal();
				if (activo == null) {
					model.put("error", RestApi.REST_NO_RELATED_ASSET);
					throw new Exception(RestApi.REST_NO_RELATED_ASSET);
				}
				mapaValores.put("Activo", activo.getNumActivoUvem().toString());
				
				mapaValores.put("FRecepOf", dateFormat.format(oferta.getFechaAlta()).toString() );
				mapaValores.put("FProp", dateFormat.format(new Date()).toString());
				
				mapaValores.put("Gestor", "***");
				mapaValores.put("FPublWeb", "***");
				mapaValores.put("NumVisitasWeb", "***");

				
			} catch (JsonParseException e1) {
				e1.printStackTrace();
			} catch (JsonMappingException e1) {
				e1.printStackTrace();
			} catch (IOException e1) {
				e1.printStackTrace();
			} catch (Exception e1){
				e1.printStackTrace();
			} 

			
			//GENERACION DEL DOCUMENTO EN PDF		
			if (model.get("error")==null || model.get("error")=="") {
				InputStream is = this.getClass().getClassLoader().getResourceAsStream(ficheroPlantilla);
				//Comprobar si existe el fichero de la plantilla
				if (is == null) {
					logger.error("PropuestaResolucion: No existe el fichero de plantilla" + ficheroPlantilla);
					throw new IllegalStateException("No existe el fichero de plantilla " + ficheroPlantilla);
				}		
				
				try {
					//System.setProperty("java.awt.headless", "true");
					
					//Compilar la plantilla
					JasperReport report = JasperCompileManager.compileReport(is);	
					
					//JasperReport report = (JasperReport)JRLoader.loadObject(is);

					DtoPropuestaOferta propuestaOferta = new DtoPropuestaOferta();
					
					DtoCliente cliente = new DtoCliente();
					cliente.setNombreCliente("***");
					cliente.setDireccionCliente("***");
					cliente.setDniCliente("***");
					
					DtoCliente cliente2 = new DtoCliente();
					cliente2.setNombreCliente("***");
					cliente2.setDireccionCliente("***");
					cliente2.setDniCliente("***");

					List<Object> listaCliente = new ArrayList<Object>();
					listaCliente.add(cliente);
					listaCliente.add(cliente2);
					propuestaOferta.setListaCliente(listaCliente);
					
					DtoOferta ofertaActivo = new DtoOferta();
					ofertaActivo.setNumOferta("***");
					ofertaActivo.setTitularOferta("***");
					ofertaActivo.setImporteOferta("***");
					ofertaActivo.setFechaOferta("***");
					ofertaActivo.setSituacionOferta("***");
					
					DtoOferta ofertaActivo2 = new DtoOferta();
					ofertaActivo2.setNumOferta("***");
					ofertaActivo2.setTitularOferta("***");
					ofertaActivo2.setImporteOferta("***");
					ofertaActivo2.setFechaOferta("***");
					ofertaActivo2.setSituacionOferta("***");
					
					List<Object> listaOferta = new ArrayList<Object>();
					listaOferta.add(ofertaActivo);
					listaOferta.add(ofertaActivo2);
					propuestaOferta.setListaOferta(listaOferta);
					
					DtoTasacionInforme tasacion = new DtoTasacionInforme();
					tasacion.setNumTasacion("***");
					tasacion.setTipoTasacion("***");
					tasacion.setImporteTasacion("***");
					tasacion.setFechaTasacion("***");
					tasacion.setFirmaTasacion("***");
					
					List<Object> listaTasacion = new ArrayList<Object>();
					listaTasacion.add(tasacion);
					propuestaOferta.setListaTasacion(listaTasacion);
					
					array.add(propuestaOferta);
					
					//Rellenar los datos del informe
					JasperPrint print = JasperFillManager.fillReport(report, mapaValores,  new JRBeanCollectionDataSource(array));
					
					//Exportar el informe a PDF
					fileSalidaTemporal = File.createTempFile("jasper", ".pdf");
					fileSalidaTemporal.deleteOnExit();
					if (fileSalidaTemporal.exists()) {
						JasperExportManager.exportReportToPdfStream(print, new FileOutputStream(fileSalidaTemporal));
						FileItem fi = new FileItem();
						fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".pdf");
						fi.setFile(fileSalidaTemporal);
					} else {
						throw new IllegalStateException("Error al generar el fichero de salida " + fileSalidaTemporal);
					}
					
				} catch (JRException e) {
					logger.error("PropuestaResolucion: Error al compilar el informe en JasperReports " + e.getLocalizedMessage(), e);
					throw new IllegalStateException("Error al compilar el informe en JasperReports " + e.getLocalizedMessage(), e);
				} catch (IOException e) {
					logger.error("PropuestaResolucion: No se puede escribir el fichero de salida " + e.getMessage() +"\n" + System.getProperties().getProperty("java.io.tmpdir"));
					throw new IllegalStateException("No se puede escribir el fichero de salida");
				} catch (Exception e) {
					logger.error("PropuestaResolucion: Error al generar el informe en JasperReports " + e.getLocalizedMessage(), e);
					throw new IllegalStateException("Error al generar el informe en JasperReports " + e.getLocalizedMessage(), e);
				}
			}


			//ENVIO DE LOS DATOS DEL DOCUMENTO AL CLIENTE
			if (model.get("error")==null || model.get("error")=="") {
				try {
//					byte[] bytes = read(fileSalidaTemporal);
//					dataResponse.put("contentType", "application/pdf");
//					dataResponse.put("fileName", "HojaPresentacionPropuesta.pdf");
//					dataResponse.put("hojaPropuesta",base64Encode(bytes));
//					model.put("data", dataResponse);
					
					//Si no hay error se pone vacio, por coherencia con los otros métodos.
					model.put("error", "");
					
		       		ServletOutputStream salida = response.getOutputStream(); 
		       		FileInputStream fileInputStream = new FileInputStream(fileSalidaTemporal.getAbsolutePath());
		 
		       		if(fileInputStream!= null) {       		
			       		response.setHeader("Content-disposition", "attachment; filename="+name+".pdf");
			       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
			       		response.setHeader("Cache-Control", "max-age=0");
			       		response.setHeader("Expires", "0");
			       		response.setHeader("Pragma", "public");
			       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
			       		response.setContentType("application/pdf");		
			       		FileUtils.copy(fileInputStream, salida);// Write
			       		salida.flush();
			       		salida.close();
		       		}
		       		
		       	} catch (Exception e) { 
		       		e.printStackTrace();
		       	}
			}
	
		restApi.sendResponse(response, model);
			
			
		}
		
		
		public byte[] read(File file) throws IOException {
		    ByteArrayOutputStream ous = null;
		    InputStream ios = null;
		    try {
		        byte[] buffer = new byte[4096];
		        ous = new ByteArrayOutputStream();
		        ios = new FileInputStream(file);
		        int read = 0;
		        while ((read = ios.read(buffer)) != -1) {
		            ous.write(buffer, 0, read);
		        }
		    }finally {
		        try {
		            if (ous != null)
		                ous.close();
		        } catch (IOException e) {
		        }

		        try {
		            if (ios != null)
		                ios.close();
		        } catch (IOException e) {
		        }
		    }
		    return ous.toByteArray();
		}
		
		
	    private String base64Encode(byte[] in)       {
	        StringBuilder out = new StringBuilder((in.length * 4) / 3);
	        int b;
	        for (int i = 0; i < in.length; i += 3)  {
	            b = (in[i] & 0xFC) >> 2;
	            out.append(CODES.charAt(b));
	            b = (in[i] & 0x03) << 4;
	            if (i + 1 < in.length)      {
	                b |= (in[i + 1] & 0xF0) >> 4;
	                out.append(CODES.charAt(b));
	                b = (in[i + 1] & 0x0F) << 2;
	                if (i + 2 < in.length)  {
	                    b |= (in[i + 2] & 0xC0) >> 6;
	                    out.append(CODES.charAt(b));
	                    b = in[i + 2] & 0x3F;
	                    out.append(CODES.charAt(b));
	                } else  {
	                    out.append(CODES.charAt(b));
	                    out.append('=');
	                }
	            } else      {
	                out.append(CODES.charAt(b));
	                out.append("==");
	            }
	        }

	        return out.toString();
	    }
	
}
