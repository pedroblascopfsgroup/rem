package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators;

import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;

public class MSVMultiColumnValidatorImpl implements MSVMultiColumnValidator {

	private Map<Integer, MSVResultadoValidacionSQL> resultConfig;
	
	private String sqlValidacion;
	
	private List<String> combinacionColumnas;
	
	public List<String> getCombinacionColumnas() {
		return combinacionColumnas;
	}

	public void setCombinacionColumnas(List<String> combinacionColumnas) {
		this.combinacionColumnas = combinacionColumnas;
	}

	public String getSqlValidacion() {
		return sqlValidacion;
	}

	public void setSqlValidacion(String sqlValidacion) {
		this.sqlValidacion = sqlValidacion;
	}

	public void setResultConfig(Map<Integer, MSVResultadoValidacionSQL> resultConfig) {
		this.resultConfig = resultConfig;
	}

	public Map<Integer, MSVResultadoValidacionSQL> getResultConfig() {
		return resultConfig;
	}

}
