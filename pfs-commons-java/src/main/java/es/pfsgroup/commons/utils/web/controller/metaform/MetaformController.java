package es.pfsgroup.commons.utils.web.controller.metaform;

import java.io.Serializable;
import java.lang.reflect.Field;

import javax.persistence.Id;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.metadata.MetadataDto;
import es.pfsgroup.commons.utils.Checks;

@Controller("metaform")
public class MetaformController {
	public static final String NAME = "metaform";
	
	public static final String REQUEST_MAPPING = "process";

	private static final String DEFAULT_JSON = "default";

	public static final String PRM_NEXT_ACTION = "mfNextAction";

	public static final String ACTION_CREATE = "mfCreate";

	public static final String ACTION_GET = "mfGet";

	public static final String ACTION_UPDATE = "mfUpdate";

	public static final String GENERIC_ABM_GET = "metaformController.abm.get";

	public static final String GENERIC_ABM_UPDATE = "metaformController.abm.update";
	
	public static final String GENERIC_ABM_CREATE = "metaformController.abm.create";

	@Autowired
	private MetadataBinder binder;

	@Autowired
	private Executor executor;

	@Autowired
	private MetaformRegistry registry;

	@Autowired
	private GenericABMDao genericDao; 

	@RequestMapping(REQUEST_MAPPING + ".htm")
	public String process(
			ModelMap model,
			WebRequest request,
			@RequestParam("mfid") String mfId,
			@RequestParam(required = false, value = PRM_NEXT_ACTION) String mfNextAction) {
		check();
		if (Checks.esNulo(mfId)) {
			throw new IllegalArgumentException("mfId: NO ESPECIFICADO");
		}
		MetaformEntry entry = registry.getDto(mfId);
		if (Checks.esNulo(entry)) {
			throw new IllegalStateException(mfId
					+ ": Meta Data DTO NO REGISTRADO");
		}
		if (ACTION_CREATE.equals(mfNextAction)) {
			
			return actionCreate(model, request, entry);
		}

		if (ACTION_UPDATE.equals(mfNextAction)) {
			
			return actionUpdate(model, request, entry);
		}

		if (ACTION_GET.equals(mfNextAction)) {
			return actionGet(model, request, entry);
		}

		return defaultAction(model, request, entry);
	}

	private <T extends Serializable> String actionGet(ModelMap model,
			WebRequest request, MetaformEntry entry) {
		String bo = entry.getGetBO();
		Long id = extractId(entry.getDtoType(), request);
		MetadataDto<T> dto = null;
		try {
			if (GENERIC_ABM_GET.equals(bo)) {
				dto = createInstance(entry);
				entry.getEntityType();
				T o = (T) getObjectFromDB(entry.getEntityType(), id);
				if (o != null) {
					dto.loadObject(o);
				}
			} else {
				dto = (MetadataDto<T>) executor.execute(bo, id);
			}
			model.put("metadataDto", dto);
			return entry.getView();
		} catch (Exception e) {
			throw new MetaformControllerException(entry.getDtoType(), e);
		}
	}

	private <T extends Serializable> String actionUpdate(ModelMap model,
			WebRequest request, MetaformEntry entry) {
		
		String bo = entry.getUpdateBO();
		Long id = extractId(entry.getDtoType(), request);
		MetadataDto<T> dto = createInstance(entry);
		binder.bindAndValidate(request, dto,false);
		try {
			if (GENERIC_ABM_UPDATE.equals(bo)) {
				throw new IllegalAccessError("MetaformController.actionCreate está deshabilidado. Use una @BusinessOperation");
				/*
				 * No funcional debido a que la transacción del DAO no se pued poner de modo RW
				 */
				//T o = (T) getObjectFromDB(entry.getEntityType(), id);
				//if (o != null) {
				//	T o2 = dto.mergeObject(o);
				//	genericDao.readWrite(entry.getEntityType()).update(o2);
				//}
			} else {
				executor.execute(bo, dto);
			}

		} catch (Exception e) {
			throw new MetaformControllerException(entry.getDtoType(), e);
		}
		return DEFAULT_JSON;
	}

	private String defaultAction(ModelMap model, WebRequest request,
			MetaformEntry entry) {
		MetadataDto<?> dto = createInstance(entry);
		binder.bind(request, dto);
		model.put("metadataDto", dto);
		return entry.getView();
	}

	
	private <T extends Serializable> String actionCreate(ModelMap model, WebRequest request,
			MetaformEntry entry) {
		
		MetadataDto<T> dto = createInstance(entry);
		binder.bindAndValidate(request, dto,true);
		String bo = entry.getCreateBO();
		try {
			if (GENERIC_ABM_CREATE.equals(bo)) {
				throw new IllegalAccessError("MetaformController.actionCreate está deshabilidado. Use una @BusinessOperation");
				/*
				 * No funcional debido a que la transacción del DAO no se pued poner de modo RW
				 */
				//T o = dto.createObject();
				//genericDao.readWrite(entry.getEntityType()).save(o);
			} else {
				executor.execute(bo, dto);
			}

		} catch (Exception e) {
			throw new MetaformControllerException(entry.getDtoType(), e);
		}
		return DEFAULT_JSON;
	}

	private void check() {
		if (Checks.esNulo(binder)) {
			throw new IllegalStateException("binder: ES NULL");
		}

		if (Checks.esNulo(registry)) {
			throw new IllegalStateException("registry: ES NULL");
		}

		if (Checks.esNulo(executor)) {
			throw new IllegalStateException("executor: ES NULL");
		}
	}

	private <T extends Serializable> MetadataDto<T> createInstance(
			MetaformEntry entry) {
		MetadataDto<T> dto = null;
		try {
			dto = (MetadataDto<T>) entry.getDtoType().newInstance();
		} catch (Exception e) {
			throw new MetaformControllerException(entry.getDtoType(), e);
		}
		return dto;
	}

	private void checkDao() {
		if (Checks.esNulo(genericDao)) {
			throw new IllegalStateException("genericDao: ES NULL");
		}
	}

	/**
	 * Extrae el ID de la petición request. Extrae el ID escaneando la clase en
	 * busca de la anotación <code>@Id</code>.
	 * 
	 * @param clazz
	 * @param request
	 * @return
	 * @throws MetaformControllerException
	 *             si: no se ha anotado la clase con @Id, el campo anotado como
	 *             ID no es Long, la petición request no contiene el parámetro.
	 */
	private Long extractId(Class<?> clazz, WebRequest request) {
		if (Checks.esNulo(clazz)) {
			throw new IllegalArgumentException("clazz: IS NULL");
		}
		Field idField = null;
		for (Field f : clazz.getDeclaredFields()) {
			Id id = f.getAnnotation(Id.class);
			if (!Checks.esNulo(id)) {
				idField = f;
			}
		}
		if (idField == null) {
			throw new MetaformControllerException(clazz,
					MetaformControllerException.Type.ID_FIELD_REQUIRED);
		}
		Object o = request.getParameter(idField.getName());
		Long id = null;
		try {
			id = Long.parseLong(o.toString());
		} catch (NumberFormatException e) {
			throw new MetaformControllerException(clazz,
					MetaformControllerException.Type.ID_TYPE_MSMACTH, o);
		}
		if (Checks.esNulo(id)) {
			throw new MetaformControllerException(clazz,
					MetaformControllerException.Type.PARAMETER_NOT_FOUND,
					idField.getName());
		}
		return id;

	}

	private <T extends Serializable> T getObjectFromDB(Class<T> c, Long id) {
		T o = (T) genericDao.get(c, genericDao
				.createFilter(FilterType.EQUALS, "id", id));
		return o;
	}
}
