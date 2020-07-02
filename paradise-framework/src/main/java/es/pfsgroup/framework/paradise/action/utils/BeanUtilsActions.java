//package es.pfsgroup.framework.paradise.action.utils;
//
//import java.beans.BeanInfo;
//import java.beans.Introspector;
//import java.beans.PropertyDescriptor;
//import java.lang.reflect.Method;
//import java.util.Map;
//
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import es.capgemini.pfs.diccionarios.Dictionary;
//import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
//import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
//
//private final class BeanUtilsActions {
//
//	protected final Log logger = LogFactory.getLog(getClass());
//	private static final String CODIGO = "codigo";
//	private static final String EXCLUSION = "java.lang.Class";
//	
//	@Autowired
//	private GenericABMDao genericDao;
//	
//	@Autowired
//	private ActionUtils actionUtils;
//	
//	
//	public void dtoToProjectionDto(Object dest, Object source) {
//
//		try {
//			dest = dest.getClass().newInstance();
//			Map<String, TargetDescriptors> targetDest = actionUtils.getTypeDescriptors(dest);
//
//			BeanInfo beanInfoSource = Introspector.getBeanInfo(source.getClass());
//			PropertyDescriptor[] descriptorsSource = beanInfoSource.getPropertyDescriptors();
//			for (PropertyDescriptor descriptor : descriptorsSource) {
//				if (targetDest.get(descriptor.getName()) == null) {
//					throw new BeanUtilsActionsExceptions(BeanUtilsActionsExceptions
//							.propertyNotExist(descriptor.getName(), dest.getClass().getName()));
//				}
//				TargetDescriptors destinationTarget = targetDest.get(descriptor.getName());
//				Method writeMethod = descriptor.getWriteMethod();
//				Method readMethod = descriptor.getReadMethod();
//				Object val = readMethod.invoke(source);
//				if (!EXCLUSION.equals(destinationTarget.getType().getName()) && val != null) {
//					if (Dictionary.class.isAssignableFrom(destinationTarget.getType())) {
//						writeMethod = destinationTarget.getDescriptor().getWriteMethod();
//						val = genericDao.get(destinationTarget.getType().getClass(), genericDao.createFilter(FilterType.EQUALS, CODIGO, val));
//					}
//						writeMethod.invoke(dest, val);
//				} else {
//					logger.debug("El metodo" + readMethod.getName() + " ha devuelto un valor nulo. Se omite" );
//				}
//			}
//		} catch (BeanUtilsActionsExceptions e) {
//			logger.error(e);
//		} catch (Exception e) {
//			logger.error(e);
//		}
//
//	}
//
//}
