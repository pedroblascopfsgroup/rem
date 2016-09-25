package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Indica que el campo es obligatorio para Webcom
 * @author bruno
 *
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface WebcomRequired {

}
