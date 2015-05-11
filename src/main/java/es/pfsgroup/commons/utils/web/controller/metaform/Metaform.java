package es.pfsgroup.commons.utils.web.controller.metaform;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;


@Retention(RetentionPolicy.RUNTIME)

public @interface Metaform {
	String mfid();
	Class<?> dto();
	Class<?> entity();
	String createBO();
	String getBO() default MetaformController.GENERIC_ABM_GET;
	String updateBO();
	
	String customView() default MetaformEntry.DEFAULT_VIEW;
}
