package es.pfsgroup.plugin.rem.service.api;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;

public abstract interface GenerateJasperPdfServiceApi {

	/**
	 * Genera un File de tipo pdf, que carga y rellena la plantilla indicada por parametro.
	 * @param params Campos a rellenar en la plantilla
	 * @param dataSource Lista con valores a rellenar
	 * @param template Plantilla a cargar y rellenar
	 * @return
	 * @throws JRException
	 * @throws IOException
	 * @throws Exception
	 */
	public File getPDFFile(Map<String, Object> params, List<Object> dataSource, String template) throws JRException, IOException, Exception;
	
	public Map<String, Object> sendFileBase64(HttpServletResponse response, File file) throws Exception;
}
