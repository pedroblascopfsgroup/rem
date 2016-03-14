package es.pfsgroup.recovery.geninformes.api;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.geninformes.dto.GENINFCorreoPendienteDto;
import es.pfsgroup.recovery.geninformes.dto.GENINFGenerarEscritoDto;

public interface GENINFInformesApi {

	public static final String MSV_BO_GENERAR_ESCRITO = "es.pfsgroup.plugin.recovery.masivo.api.generarEscrito";
	public static final String MSV_BO_ENVIAR_EMAIL = "es.pfsgroup.plugin.recovery.masivo.api.enviarMailConEscritoAdjunto";
	public static final String MSV_BO_GENERAR_ESCRITO_EDITABLE = "es.pfsgroup.plugin.recovery.masivo.api.generarEscritoEditable";
	public static final String MSV_BO_GENERAR_INFORME = "es.pfsgroup.plugin.recovery.masivo.api.generarInforme";
	public static final String MSV_BO_GENERAR_INFORME_PDF = "es.pfsgroup.plugin.recovery.masivo.api.generarInformePDF";
	public static final String MSV_GENERAR_ESCRITO_VARIABLES = "es.pfsgroup.plugin.recovery.masivo.api.generarEscritoConVariables";
	public static final String MSV_GENERAR_ESCRITO_PDF_FROM_HTML = "es.pfsgroup.plugin.recovery.masivo.api.createPdfFileFromHtmlText";
	public static final String MSV_CONVERTIR_DOCX_A_PDF = "es.pfsgroup.plugin.recovery.masivo.api.convertirAPdf";
	public static final String MSV_GENERAR_ESCRITO_VARIABLES_Y_LOGO = "es.pfsgroup.plugin.recovery.masivo.api.generarEscritoConVariablesYLogo";
	
	
	/**
	 * Recupera los datos referentes al tipo de entidad de la que trata el escrito.
	 * Genera el escrito, pas�ndole los datos y el tipo de plantilla correspondiente.
	 * Si se pasa el flag correspondiente, se envia por email el informe generado.
	 * 
	 * @param tipoEntidad (String) tipo de entidad relacionada con el escrito
	 * @param tipoEscrito (String) tipo de escrito
	 * @param idEntidad (Long) identificador de la entidad de la que recuperar los datos
	 * @param enviarPorEmail (boolean) flag que indica si se va a enviarpor email el informe
	 * @param proc (Procedimiento) entidad Procedimiento que contiene los datos no incluidos en la entidad principal
	 * @param mapaValoresPrecalculados par�metro opcional que incluye un array de mapas de valores precalculados
	 *  
	 * @return boolean se ha producido alg�n error
	 * 
	 * @author pedro
	 * */
	@BusinessOperationDefinition(MSV_BO_GENERAR_ESCRITO)
	public boolean generarEscrito(String tipoEntidad, String tipoEscrito, Long idEntidad, boolean enviarPorEmail, Procedimiento proc,
			Map<String, Object>... mapaValoresPrecalculados);

	@BusinessOperationDefinition(MSV_BO_ENVIAR_EMAIL)
	public void enviarMailConEscritoAdjunto(GENINFCorreoPendienteDto dto)
			throws javax.mail.MessagingException;

	/**
	 * Recupera los datos referentes al tipo de entidad de la que trata el escrito.
	 * Genera el escrito editable, pas�ndole un dto con los datos necesarios.
	 *
	 * @param generarEscritoDto (GENINFGenerarEscritoDto) DTO con los datos necesarios para generar el escrito
	 * @param mapaValoresPrecalculados par�metro opcional que incluye un array de mapas de valores precalculados
	 *  
	 * @return FileItem fichero generado
	 * 
	 * @author pedro
	 * */
	@BusinessOperationDefinition(MSV_BO_GENERAR_ESCRITO_EDITABLE)
	public FileItem generarEscritoEditable(GENINFGenerarEscritoDto generarEscritoDto,
			Map<String, Object>... mapaValoresPrecalculados);

	@BusinessOperationDefinition(MSV_BO_GENERAR_INFORME)
	public FileItem generarInforme(String plantilla, Map<String, Object> mapaValores, List<Object> array);
	
	@BusinessOperationDefinition(MSV_BO_GENERAR_INFORME_PDF)
	public FileItem generarInformePDF(String plantilla, Map<String, Object> mapaValores, List<Object> array);
	
	@BusinessOperationDefinition(MSV_GENERAR_ESCRITO_VARIABLES)
	FileItem generarEscritoConVariables(HashMap<String, Object> mapaVariables, String escrito,InputStream is) throws Throwable;
	
	@BusinessOperationDefinition(MSV_GENERAR_ESCRITO_VARIABLES_Y_LOGO)
	FileItem generarEscritoConVariablesYLogo(HashMap<String, Object> mapaVariables, String escrito,InputStream is, String codigoPropietaria) throws Throwable;
	
	@BusinessOperationDefinition(MSV_GENERAR_ESCRITO_PDF_FROM_HTML)
	InputStream createPdfFileFromHtmlText(String htmlText,String nombreFichero) throws Exception;

	

}
