package es.pfsgroup.commons.utils.web.controller.metaform;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.commons.utils.web.dto.metadata.MetadataDto;

public class MetadataBinderException extends BusinessOperationException {

	private MetadataDto<?> dto;
	private String propertyName;
	private Throwable cause;

	public MetadataBinderException(MetadataDto<?> dto, String name, Throwable e) {
		super(e);
		this.dto = dto;
		this.propertyName = name;
		this.cause = e;
	}

	private static final long serialVersionUID = -8877340360940759172L;

	@Override
	public String getMessage() {
		if (dto == null){
			return "Trying to bind on a NULL object";
		}
		
		if (propertyName == null){
			return dto.getClass().getName() + ": tryin to bind a NULL property";
		}
		
		if (cause == null){
			return  dto.getClass().getName() + ": binding ERROR on '" + propertyName
			+ ". Unknown cause";
		}
		return  dto.getClass().getName() + ": binding ERROR on '" + propertyName
				+ ". Cause: " + this.cause.getMessage();
	}

}
