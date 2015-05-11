package es.pfsgroup.plugin.recovery.mejoras.utils;

import javax.servlet.http.HttpServletRequest;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface FileUploadUtils {
	public static final String BO_FILEUPLOAD_UTILS_EXTRACTHTTP = "fileUploadUtils.extractHttpServletRequest";
	
	@BusinessOperationDefinition(BO_FILEUPLOAD_UTILS_EXTRACTHTTP)
	public HttpServletRequest extractHttpServletRequest(final Object object);

}