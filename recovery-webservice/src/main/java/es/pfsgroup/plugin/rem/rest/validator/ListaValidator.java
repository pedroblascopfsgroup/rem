package es.pfsgroup.plugin.rem.rest.validator;

import java.util.List;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Lista;

public class ListaValidator implements ConstraintValidator<Lista, Object> {

	private Lista diccionario;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public void initialize(Lista diccionario) {
		this.diccionario = diccionario;
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean isValid(Object value, ConstraintValidatorContext context) {
		boolean resultado = false;
		if (value == null) {
			resultado = true;
		} else {
			List<Object> lista = genericDao.getList(diccionario.clase(),
					genericDao.createFilter(FilterType.EQUALS, diccionario.foreingField(), value));

			if (lista != null && !lista.isEmpty()) {
				resultado = true;
			}
		}
		return resultado;
	}

}
