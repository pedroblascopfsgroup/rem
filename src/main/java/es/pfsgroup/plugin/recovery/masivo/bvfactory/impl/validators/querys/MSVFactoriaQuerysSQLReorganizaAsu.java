package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys;

import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.types.MSVColumnMultiResultSQL;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVReorganizaAsuColumns;

/**
 * Factoría que devuelve configuraciones del resultado de la validación para el
 * fichero de confirmar recepción del original
 * 
 * @author Carlos
 * 
 */
public class MSVFactoriaQuerysSQLReorganizaAsu extends
MSVFactoriaQuerysSQLGenericContrato {

	private String sqlValidacionIdTarea;
	private Map<Integer, MSVResultadoValidacionSQL> configValidacionIdTarea;
		
	public Map<Integer, MSVResultadoValidacionSQL> getConfig(String colName) {
		if (MSVReorganizaAsuColumns.TAP_ID.equals(colName)) {
			return configValidacionIdTarea;
		} else {
			return super.getConfig(colName);
		} 
	}

	public String getSql(String colName) {
		if (MSVReorganizaAsuColumns.TAP_ID.equals(colName)) {
			return this.sqlValidacionIdTarea;
		} else {
			return super.getSql(colName);
		}
	}

	public void setSqlValidacionIdTarea(String sqlValidacionIdTarea) {
		this.sqlValidacionIdTarea = sqlValidacionIdTarea
				.replaceAll("VALUETOKEN", MSVColumnMultiResultSQL.VALUE_TOKEN)
				.replaceAll("\\t", "").replaceAll("\\n", "");
	}

	public Map<Integer, MSVResultadoValidacionSQL> getConfigValidacionIdTarea() {
		return configValidacionIdTarea;
	}

	public void setConfigValidacionIdTarea(
			Map<Integer, MSVResultadoValidacionSQL> configValidacionIdTarea) {
		this.configValidacionIdTarea = configValidacionIdTarea;
	}
}