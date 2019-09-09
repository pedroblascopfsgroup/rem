package es.pfsgroup.plugin.rem.api;

import java.util.Map;

import es.capgemini.devon.files.WebFileItem;

public interface UploadApi {
	
	public static final String VALIDATE_WEBFILE_ACTIVO = "activo";
	public static final String VALIDATE_WEBFILE_TRABAJO = "trabajo";
	public static final String VALIDATE_WEBFILE_EXPEDIENTE = "expediente";
	public static final String VALIDATE_WEBFILE_GASTO_PROOVEDOR = "gastoProovedor";

	public Map <String , Object> validateAndUploadWebFileItem(WebFileItem webFileItem) throws Exception;
	

}

