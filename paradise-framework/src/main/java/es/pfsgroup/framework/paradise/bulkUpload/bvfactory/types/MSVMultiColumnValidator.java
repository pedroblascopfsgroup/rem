package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types;

import java.util.List;
import java.util.Map;

/**
 * Esta interfaz representa un validador de negocio para un conjunto de columnas.
 * 
 * @author pedro
 * 
 */
public interface MSVMultiColumnValidator {

	String getSqlValidacion();
	void setSqlValidacion(String sqlValidacion);

	void setResultConfig(Map<Integer, MSVResultadoValidacionSQL> resultConfig);
	Map<Integer, MSVResultadoValidacionSQL> getResultConfig();

	List<String> getCombinacionColumnas();
	void setCombinacionColumnas(List<String> combinacionColumnas);

	
}
