package es.pfsgroup.plugin.rem.rest.validator;

import java.util.List;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.UniqueKey;

public class UniqueKeyValidator implements ConstraintValidator<UniqueKey, Object> {

	private UniqueKey unique;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public void initialize(UniqueKey unique) {
		this.unique = unique;
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean isValid(Object value, ConstraintValidatorContext context) {
		boolean resultado = true;
		if (value != null) {
			List<?> lista = genericDao.getList(unique.clase(),
					genericDao.createFilter(FilterType.EQUALS,unique.field(), value));
			if(lista!=null && lista.size()>0){
				resultado =false;
			}
		}
		return resultado;
	}

}
