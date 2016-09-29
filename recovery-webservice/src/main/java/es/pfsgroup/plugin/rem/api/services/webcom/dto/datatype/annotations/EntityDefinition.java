package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface EntityDefinition {
	String propertyName();
	Class entity();

}
