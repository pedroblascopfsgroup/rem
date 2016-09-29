package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import es.pfsgroup.plugin.rem.tests.restclient.webcom.examples.ExampleSubDto;

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface NestedDto {

	Class type();

	String groupBy();

}
