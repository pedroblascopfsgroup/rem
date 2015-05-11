package es.pfsgroup.plugin.recovery.mejoras.utils.impl;

import java.lang.reflect.Method;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.utils.FileUploadUtils;

@Component
public class FileUploadUtilsImpl implements FileUploadUtils{

@BusinessOperation(BO_FILEUPLOAD_UTILS_EXTRACTHTTP)
public HttpServletRequest extractHttpServletRequest(final Object object) {
		
		if (Checks.esNulo(object)){
			throw new IllegalArgumentException("'object' no puede ser nulo");
		}
		
		if (object instanceof HttpServletRequest){
			return (HttpServletRequest) object;
		}

		try {
			Method getServletRequest = object.getClass().getSuperclass().getDeclaredMethod("getRequest", null);

			if (getServletRequest == null) {
				throw new BusinessOperationException("El objeto no tiene un método getRequest [" + object.getClass() + "]");
			}

			getServletRequest.setAccessible(true);
			final Object request = getServletRequest.invoke(object, null);

			if (!(request instanceof HttpServletRequest)) {
				throw new BusinessOperationException("El método getRequest no devuelve un objeto HttpServletRequest [" + object.getClass() + "]");
			}

			return (HttpServletRequest) request;

		} catch (Exception e) {
			throw new BusinessOperationException("Se ha producido un error al intentar invocar " + object.getClass() + ".getRequest()", e);
		}

	}
}
