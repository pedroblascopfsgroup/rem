package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys;

import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.types.MSVColumnMultiResultSQL;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVGenericContratoColumns;

/**
 * Factoría que devuelve configuraciones del resultado de la validación generica
 * del contrato
 * 
 * 
 * @author Carlos
 * 
 */
public class MSVFactoriaQuerysSQLGenericContrato {

	private String sqlValidacionNumContrato;
	private Map<Integer, MSVResultadoValidacionSQL> configValidacionNumContrato;

	public Map<Integer, MSVResultadoValidacionSQL> getConfig(String colName) {
		if  (MSVGenericContratoColumns.NUM_NOVA.equals(colName) || MSVGenericContratoColumns.NUM_CONTRATO.equals(colName)) {
			return this.configValidacionNumContrato;
		} else {
			return null;
		}
	}

	public String getSql(String colName) {
		if (MSVGenericContratoColumns.NUM_NOVA.equals(colName) || MSVGenericContratoColumns.NUM_CONTRATO.equals(colName)) {
			return this.sqlValidacionNumContrato;
		} else {
			return null;
		}
	}

	public void setSqlValidacionNumContrato(String sqlValidacionNumContrato) {
		this.sqlValidacionNumContrato = sqlValidacionNumContrato
				.replaceAll("VALUETOKEN", MSVColumnMultiResultSQL.VALUE_TOKEN)
				.replaceAll("\\t", "").replaceAll("\\n", "");
	}

	public Map<Integer, MSVResultadoValidacionSQL> getConfigValidacionNumContrato() {
		return configValidacionNumContrato;
	}

	public void setConfigValidacionNumContrato(
			Map<Integer, MSVResultadoValidacionSQL> configValidacionNumContrato) {
		this.configValidacionNumContrato = configValidacionNumContrato;
	}
}
