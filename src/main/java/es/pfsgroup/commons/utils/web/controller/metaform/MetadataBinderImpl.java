package es.pfsgroup.commons.utils.web.controller.metaform;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import javax.persistence.Id;
import javax.validation.constraints.NotNull;

import org.apache.commons.beanutils.BeanUtils;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.validation.ErrorMessage;
import es.capgemini.devon.validation.Severity;
import es.capgemini.devon.validation.ValidationException;
import es.pfsgroup.commons.utils.web.dto.metadata.MetadataDto;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.BOReference;
import es.pfsgroup.commons.utils.Checks;

@Component
public class MetadataBinderImpl implements MetadataBinder {

	@Override
	public void bind(WebRequest request, MetadataDto<?> dto) {
		doBind(request, dto, false, true);
	}

	@Override
	public void bindAndValidate(WebRequest request, MetadataDto<?> dto,
			boolean allowNullId) {
		doBind(request, dto, true, allowNullId);

	}

	private void doBind(WebRequest request, MetadataDto<?> dto,
			boolean validate, boolean allowNullId) {
		if (Checks.esNulo(request)) {
			throw new IllegalArgumentException("request: NO PUEDE SER NULL");
		}

		if (Checks.esNulo(dto)) {
			throw new IllegalArgumentException("dto: NO PUEDE SER NULL");
		}

		for (Field f : dto.getClass().getDeclaredFields()) {
			if (!Modifier.isStatic(f.getModifiers())) {
				Object o = request.getParameter(f.getName());
				if (Checks.esNulo(o)) {
					BOReference ref = f.getAnnotation(BOReference.class);
					if ((ref != null) && (ref.required())) {
						throw new IllegalStateException("@BOReference " + f.getName() + " IS REQUIRED");
					}
				}
				if (!Checks.esNulo(o)) {
					try {
						BeanUtils.copyProperty(dto, f.getName(), o);
					} catch (Exception e) {
						throw new MetadataBinderException(dto, f.getName(), e);
					}
				} else if (validate) {
					List<ErrorMessage> errors = checkRestrictions(f,
							allowNullId);
					if ((errors != null) && (!errors.isEmpty())) {
						throw new ValidationException(errors);
					}
				}
			}
		}// for
	}

	private List<ErrorMessage> checkRestrictions(Field f, boolean allowNullId) {
		ArrayList<ErrorMessage> errors = new ArrayList<ErrorMessage>();
		NotNull nn = f.getAnnotation(NotNull.class);
		NotEmpty ne = f.getAnnotation(NotEmpty.class);
		Id id = f.getAnnotation(Id.class);
		BOReference ref = f.getAnnotation(BOReference.class);
		if (nn != null) {
			errors.add(new ErrorMessage(this, nn.message(), Severity.ERROR));
		}
		if (ne != null) {
			errors.add(new ErrorMessage(this, ne.message(), Severity.ERROR));
		}
		if ((id != null) && (!allowNullId)) {
			errors.add(new ErrorMessage(this, "Identifiers cannot be NULL",
					Severity.ERROR));
		}
		if ((ref != null) && (ref.required())) {
			errors.add(new ErrorMessage(this, ref.clazz()
					+ ". Business Objects reference cannot be NULL",
					Severity.ERROR));
		}
		return errors;
	}

}
