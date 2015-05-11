//package es.pfsgroup.commons.utils.manager;
//
//import java.io.Serializable;
//import java.util.List;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import es.capgemini.devon.bo.BusinessOperationException;
//import es.capgemini.devon.bo.annotations.BusinessOperation;
//import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
//import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
//import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
//
//@Component
//public class GenericABMManager implements GenericABM {
//
//	@Autowired
//	private GenericABMDao genericDao;
//	
////	@BusinessOperation(BO_GENERIC_ABM_GET_LIST_BY_ID_REF)
////	public <T extends Serializable, Auditable> List<T> getListByIdRef(Class<T> clazz, String fieldName, Long id){
////		Filter filtro = genericDao.createFilter(FilterType.EQUALS, fieldName, id);
////		return genericDao.getList(clazz,filtro);
////	}
////	
////	@BusinessOperation(BO_GENERIC_ABM_CREATE)
////	public <T extends Serializable,Auditable> MetadataDto<T> create(MetadataDto<T> dto){
////		try {
////			if (true){
////				throw new IllegalAccessException(BO_GENERIC_ABM_CREATE + ": OPERACIÓN DE NEGOCIO DESACTIVADA");
////			}
////			T o = dto.createObject();
////			Class<T> clazz = (Class<T>) o.getClass();
////			Long id = genericDao.save(clazz, o);
////			//TODO Setear el ID en el DTO
////			return dto;
////		} catch (Exception e) {
////			throw new BusinessOperationException(e);
////		}
////	}
//	@BusinessOperation(BO_GENERIC_ABM_GET_DICTIONARY_BY_CODE)
//	public<T extends Serializable> T getDictionaryByCode(Class<T> clazz, String codigo){
//		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
//		return genericDao.get(clazz, filtro);
//	}
//	
//	@BusinessOperation(BO_GENERIC_ABM_GET_DICTIONARY_LIST)
//	public<T extends Serializable> List<T> getDictionaryList(Class<T> clazz){
//		return genericDao.getList(clazz);
//	}
//	
////	@BusinessOperation(BO_GENERIC_ABM_DELETE_BY_ID)
////	public<T extends Serializable, Auditable> void deleteById(Class<T> clazz, Long id){
////		genericDao.deleteById(clazz, id);
////	}
//}
