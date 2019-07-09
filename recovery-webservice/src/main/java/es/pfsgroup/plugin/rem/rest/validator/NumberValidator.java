package es.pfsgroup.plugin.rem.rest.validator;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.IsNumber;


public class NumberValidator implements ConstraintValidator<IsNumber, Object>{

	@Override
	public void initialize(IsNumber arg0) {
		
	}

	@Override
	public boolean isValid(Object arg0, ConstraintValidatorContext arg1) {
		String valor = null;
		if(arg0 != null){
			valor = arg0.toString();
			return isNumeric(valor);
		}else{
			return true;
		}
		
		
	}
	
	public static boolean isNumeric(String cadena) {

        boolean resultado;

        try {
            Integer.parseInt(cadena);
            resultado = true;
        } catch (NumberFormatException excepcion) {
            resultado = false;
        }

        return resultado;
    }

	

}
