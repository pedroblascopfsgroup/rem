package es.pfsgroup.plugin.rem.rest.validator;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;

public class DiccionaryValidator implements ConstraintValidator<Diccionary, String> {

	private Diccionary diccionario;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public void initialize(Diccionary diccionario) {
		this.diccionario = diccionario;
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean isValid(String value, ConstraintValidatorContext context) {
		boolean resultado = false;
		if (value == null) {
			resultado = true;
		} else {

			Object object = genericDao.get(diccionario.clase(),
					genericDao.createFilter(FilterType.EQUALS, diccionario.foreingField(), value));

			if (object != null) {
				resultado = true;
			}
		}
		return resultado;
	}

}
