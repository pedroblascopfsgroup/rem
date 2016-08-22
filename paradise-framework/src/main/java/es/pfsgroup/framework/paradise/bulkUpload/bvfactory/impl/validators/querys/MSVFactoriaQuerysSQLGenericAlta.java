package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.querys;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.types.MSVColumnMultiResultSQL;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVResultadoValidacionSQL;

public class MSVFactoriaQuerysSQLGenericAlta implements MSVFactoriaQuerysSQL{

	private Map<Integer, MSVResultadoValidacionSQL> configValidacion;
	
	private Map<String, String> sqlValidacion;
	
	//Mapa con la relación entre los nombres de las columnas del excel y las constantes.
	private Map<String, String> mapaColumnas = new HashMap<String,String>(); 
	
	/**
	 * Inicializamos el el mapa para poder obtener las query en función del valor de la constante y no al revés.
	 */	
	@SuppressWarnings("rawtypes")
	public void init(Class clazz){
		Field[] declaredFields = clazz.getDeclaredFields();
		for (Field field : declaredFields) {
		    if (java.lang.reflect.Modifier.isStatic(field.getModifiers())) {
		    	try {
					mapaColumnas.put((String)field.get(null), field.getName());
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				}
		    }
		}
	}
	
	public String getSql(String colName) {
		
		String query = sqlValidacion.get(mapaColumnas.get(colName));
		return query;
	}

	public Map<Integer, MSVResultadoValidacionSQL> getConfig(String colName) {
		return this.configValidacion;
	}
	
	public Map<Integer, MSVResultadoValidacionSQL> getConfigValidacion() {
		return configValidacion;
	}

	public void setConfigValidacion(
			Map<Integer, MSVResultadoValidacionSQL> configValidacion) {
		this.configValidacion = configValidacion;
	}

	public Map<String, String> getSqlValidacion() {
		return sqlValidacion;
	}

	public void setSqlValidacion(Map<String, String> sqlValidacion) {
		this.sqlValidacion = sqlValidacion;
		for(String key : sqlValidacion.keySet()){
			sqlValidacion.put(key, sqlValidacion.get(key)		
					.replaceAll("VALUETOKEN", MSVColumnMultiResultSQL.VALUE_TOKEN)
					.replaceAll("\\t", "").replaceAll("\\n", "")
			);
		}
	}
}
