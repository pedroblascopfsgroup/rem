package es.pfsgroup.framework.paradise.utils;



import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.beanutils.BeanUtilsBean;
import org.apache.commons.beanutils.ConvertUtilsBean;
import org.apache.commons.beanutils.PropertyUtilsBean;
import org.apache.commons.beanutils.converters.FloatConverter;
import org.apache.commons.beanutils.converters.IntegerConverter;
import org.apache.commons.beanutils.converters.LongConverter;

public class BeanUtilNotNull extends BeanUtilsBean{

		
	    public BeanUtilNotNull() {
	    	
	    	
		    super();
		    IntegerConverter converter = new IntegerConverter(null); 
			FloatConverter converterFloat = new FloatConverter(null);
			LongConverter converterLong = new LongConverter(null);
			ParadiseCustomDateConverter converterDate = new ParadiseCustomDateConverter(null);
			
			this.getConvertUtils().register(converter, Integer.class);
			this.getConvertUtils().register(converterFloat, Float.class);
			this.getConvertUtils().register(converterLong, Long.class);
			// FIXME SOLUCION PARA BORRAR FECHAS
			this.getConvertUtils().register(converterDate, Date.class);
			
	    }

		public BeanUtilNotNull(ConvertUtilsBean convertUtilsBean,
				PropertyUtilsBean propertyUtilsBean) {
			
			
			super(convertUtilsBean, propertyUtilsBean);
			IntegerConverter converter = new IntegerConverter(null); 
			FloatConverter converterFloat = new FloatConverter(null);
			LongConverter converterLong = new LongConverter(null);
			ParadiseCustomDateConverter converterDate = new ParadiseCustomDateConverter(null);

			this.getConvertUtils().register(converter, Integer.class);
			this.getConvertUtils().register(converterFloat, Float.class);
			this.getConvertUtils().register(converterLong, Long.class);
			// FIXME SOLUCION PARA BORRAR FECHAS
			this.getConvertUtils().register(converterDate, Date.class);
		}

		@Override
	    public void copyProperty(Object dest, String name, Object value)
	            throws IllegalAccessException, InvocationTargetException {
		  
	        if (value==null)return;
	        /*if (value.equals("") && ( (dest.getClass() == Long.class) || (dest.getClass() == Float.class) || (dest.getClass() == Integer.class) )) {
	        	System.out.println("Campo " + dest + " seteado a null");
	        	return;
	        }*/
	        if ((value instanceof java.util.Date)){	            
	        	if (value.equals(new Date(0L))) {
	        		super.copyProperty(dest, name, null);
	        		return;
	        	}
			}
	        super.copyProperty(dest, name, value);
	    }
}

