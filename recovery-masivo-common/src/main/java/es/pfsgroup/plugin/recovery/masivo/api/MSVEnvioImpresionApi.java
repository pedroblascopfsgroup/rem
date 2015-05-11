package es.pfsgroup.plugin.recovery.masivo.api;

import java.util.Date;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * @author pedro
 * Manager de la clase MSVEnvioImpresion
 */
public interface MSVEnvioImpresionApi {

	static final String CODIGO_TIPO_DOCUMENTO_AUTOGENERADO = "LI";

	static final String IMPRIMIR_TODOS_DOCUMENTOS = "TODOS";
	static final String IMPRIMIR_DOCUMENTOS_AUTOGENERADOS = "AUTOGENERADOS";

	static final String PROP_PATH_TO_PRINT = "ruta.imprimir.docs";
	static final String DEFAULT_PATH_TO_PRINT = "/tmp/docsImprimir";
	
	static final String TXT_SIN_PLAZA = "SIN_PLAZA";
	
	public final static String MSV_BO_ENVIO_IMPRESION = "es.pfsgroup.plugin.recovery.masivo.api.envioImpresion";

	/**
	 * Envía a imprimir los adjuntos asociados al procedimiento (en realidad, a su asunto).
	 * @param proc
	 * @param fechaImpresion
	 * @param tipoDocumentacion
	 */
	@BusinessOperationDefinition(MSV_BO_ENVIO_IMPRESION)	
	void envioImpresion(Procedimiento proc, Date fechaImpresion, String tipoDocumentacion);
	
	
}
