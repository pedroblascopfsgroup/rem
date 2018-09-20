package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.types;

import java.util.Map;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnSQLValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVResultadoValidacionSQL;

/**
 * Implementación del validador de columna vía SQL
 * @author bruno
 *
 */
public class MSVColumnSQLValidatorImpl extends  MSVGenericColumnValidator implements MSVColumnSQLValidator {
	
	private String name;
	
	private String errorMsg;

	/**
	 * Crea un validador
	 * @param colName Nombre de la columna
	 * @param sql SQL  a ejecutar
	 */
	public MSVColumnSQLValidatorImpl(String colName, String sql) {
		super(sql);
		this.name = colName;
		this.errorMsg = "No se ha encontrado en el sistema";
	}

	@Override
	public String getTipoValidacion() {
		return DEBE_EXISTIR;
	}

	@Override
	public String getErrorMessage() {
		return name.concat(": ").concat(errorMsg);
	}

	

	@Override
	public boolean isRequired() {
		// Gestionamos si el valor es requerido o no durante la validación de formato
		return false;
	}

	@Override
	public Map<Integer, MSVResultadoValidacionSQL> getResultConfig() {
		// Como esto es de tipo DEBE_EXISTIR no hace falta devolver configuración
		return null;
	}

}
