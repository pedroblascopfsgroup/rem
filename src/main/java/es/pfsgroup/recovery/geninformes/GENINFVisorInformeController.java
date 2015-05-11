package es.pfsgroup.recovery.geninformes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;
import es.pfsgroup.recovery.geninformes.dto.GENINFGenerarEscritoDto;

@Controller
public class GENINFVisorInformeController {

	public static final String JSP_DOWNLOAD_FILE = "plugin/geninformes/download";

	@Autowired
	private ApiProxyFactory apiProxyFactory;

	/**
	 * Metodo que visualiza un informe de Asunto en Jasper Reports.
	 * 
	 * @param idAsunto
	 * @param plantilla
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public void generarEscrito(Long idAsunto, String plantilla, ModelMap model) {

		boolean ok = apiProxyFactory.proxy(GENINFInformesApi.class)
				.generarEscrito("EXTAsunto", plantilla,
						idAsunto, false, null);
		model.put("resultado", ok);
		
	}

	/**
	 * Metodo que visualiza un informe de Asunto en Jasper Reports.
	 * 
	 * @param idAsunto
	 * @param plantilla
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarEscritoEditable(Long idAsunto, String plantilla, ModelMap model) {

		GENINFGenerarEscritoDto generarEscritoDto = new GENINFGenerarEscritoDto("EXTAsunto", plantilla,
				idAsunto , false, false, null, GENINFGestorInformes.SUFIJO_INFORME_RTF);
		
		FileItem resultado = apiProxyFactory.proxy(GENINFInformesApi.class)
				.generarEscritoEditable(generarEscritoDto);
		
		model.put("fileItem", resultado);
		
		return JSP_DOWNLOAD_FILE;

	}
	
	/**
	 * Metodo que visualiza un informe de un Procedimiento en Jasper Reports.
	 * 
	 * @param idAsunto
	 * @param idProcedimiento
	 * @param plantilla
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarEscritoEditableProc(Long idAsunto, Long idProcedimiento, String plantilla, ModelMap model) {
		Procedimiento procedimiento = apiProxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		/*
		GENINFGenerarEscritoDto generarEscritoDto = new GENINFGenerarEscritoDto("EXTAsunto", plantilla,
				idAsunto , false, false, procedimiento, GENINFGestorInformes.SUFIJO_INFORME_RTF);
		*/
		
		GENINFGenerarEscritoDto generarEscritoDto = new GENINFGenerarEscritoDto("EXTAsunto", plantilla,
				idAsunto , false, false, procedimiento, GENINFGestorInformes.SUFIJO_INFORME_DOCX);
		
		FileItem resultado = apiProxyFactory.proxy(GENINFInformesApi.class)
				.generarEscritoEditable(generarEscritoDto);
		
		model.put("fileItem", resultado);
		
		return JSP_DOWNLOAD_FILE;

	}
	
	
}
