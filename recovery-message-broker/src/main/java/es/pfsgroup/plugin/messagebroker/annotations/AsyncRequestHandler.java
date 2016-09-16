package es.pfsgroup.plugin.messagebroker.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface AsyncRequestHandler {

	public String typeOfMessage() default AnnotationConstants.CLASS_AS_TYPE_OF_MESSAGE;

}
