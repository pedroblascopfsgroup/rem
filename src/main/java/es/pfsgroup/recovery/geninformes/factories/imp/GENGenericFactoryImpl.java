package es.pfsgroup.recovery.geninformes.factories.imp;

import java.lang.reflect.ParameterizedType;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.pfsgroup.recovery.geninformes.factories.GENBusinessObjectApi;
import es.pfsgroup.recovery.geninformes.factories.GENGenericFactory;


/**
 * @author manuel
 *
 * Implementación abstracta de la factoría {@link GENGenericFactory}
 * 
 * Obtiene una lista de objetos de negocio al arrancar la aplicación. 
 * Estos objetos deben ser de tipo T e implementar el interfaz {@link GENBusinessObjectApi}
 * 
 * La elección de qué objeto devolver se hace con un comparador que evalúa el método {@link GENBusinessObjectApi#getPrioridad()}
 *
 * @param <T> Clase o interfaz que devolverá la factoría genérica.
 */
@Component
public abstract class GENGenericFactoryImpl<T extends GENBusinessObjectApi> implements GENGenericFactory<T>, ApplicationContextAware {

	private List<T> list;
	
    private ApplicationContext mApplicationContext;
    
    private Class<T> clazz;
    
	/**
	 * Constructor.
	 */
	@SuppressWarnings("unchecked")
	public GENGenericFactoryImpl() {
		
		ParameterizedType genericSuperclass = (ParameterizedType) this.getClass().getGenericSuperclass();
		this.clazz = (Class<T>)genericSuperclass.getActualTypeArguments()[0];
		
		list = new ArrayList<T>();
	}

	/* 
	 * Rellena la lista de objetos de negocio buscándolos en el ApplicationContext
	 */
	@Override
	@SuppressWarnings("unchecked")
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		
		this.mApplicationContext = applicationContext;
		
		Map<String, T> beansMap = mApplicationContext.getBeansOfType(clazz);
		
		if (beansMap.isEmpty()) 
		{
            Error noProcessorError = new Error("No existen beans configurados del tipo " + clazz.getClass());
            throw noProcessorError;
        }
		
		for(Map.Entry<String, T> entry : beansMap.entrySet()){
			list.add(entry.getValue());
		}
	}
	
	/* 
	 * Devuelve un objeto de negocio, en este caso el de mayor prioridad. 
	 */
	@Override
	public T getBusinessObject() {
		
		if (list == null || list.size() == 0){
			return null;
		}
		
		Collections.sort(list, Collections.reverseOrder(this.getGenericCompartor()));
		return list.get(0);
	}

	private Comparator<T> getGenericCompartor() {
		return new Comparator<T>(){

			@Override
			public int compare(T arg0, T arg1) {
				
				if (arg0 == null){
					return -1;
				}
				if (arg1 == null){
					return 1;
				}
				return arg0.getPrioridad() - arg1.getPrioridad();
			}
			
		};
	}

}
