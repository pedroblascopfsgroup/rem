package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.querys;

import java.util.Map;
import java.util.Set;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVResultadoValidacionSQL;

public abstract class MSVFactoriaMultiQuerySQL {

	private Map<String,Map<Integer,MSVResultadoValidacionSQL>> mapaCombinacionesValidacion;
	private Map<String,String> mapaSQLValidaciones;

	public Set<String> getCombinacionesValidacion() {
		
		return mapaCombinacionesValidacion.keySet();
		
	}
	
	public Map<Integer,MSVResultadoValidacionSQL> getConfigCombinacion(String combinacionColumnas) {
		
		return mapaCombinacionesValidacion.get(combinacionColumnas);
		
	}

	public String getSQLValidacion(String combinacionColumnas) {
		
		return mapaSQLValidaciones.get(combinacionColumnas);
		
	}

	public Map<String, Map<Integer, MSVResultadoValidacionSQL>> getMapaCombinacionesValidacion() {
		return mapaCombinacionesValidacion;
	}

	public void setMapaCombinacionesValidacion(
			Map<String, Map<Integer, MSVResultadoValidacionSQL>> mapaCombinacionesValidacion) {
		this.mapaCombinacionesValidacion = mapaCombinacionesValidacion;
	}

	public Map<String, String> getMapaSQLValidaciones() {
		return mapaSQLValidaciones;
	}

	public void setMapaSQLValidaciones(Map<String, String> mapaSQLValidaciones) {
		this.mapaSQLValidaciones = mapaSQLValidaciones;
	}

}
