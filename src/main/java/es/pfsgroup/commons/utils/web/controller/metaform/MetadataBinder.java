package es.pfsgroup.commons.utils.web.controller.metaform;

import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.web.dto.metadata.MetadataDto;

/**
 * 
 * @author bruno
 *
 */
public interface MetadataBinder {

	void bind(WebRequest request, MetadataDto<?> dto);

	void bindAndValidate(WebRequest request, MetadataDto<?> dto, boolean allowNullId);

}
