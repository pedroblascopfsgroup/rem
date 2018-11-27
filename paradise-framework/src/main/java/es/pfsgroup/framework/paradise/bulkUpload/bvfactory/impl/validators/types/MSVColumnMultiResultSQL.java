package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.types;

import java.util.Map;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnSQLValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVResultadoValidacionSQL;

/**
 * El propósito de esta clase es la de poder hacer una validación de una columna
 * mediante una SQL que nos devuelve un único resultado numérico, y poder
 * pasarle una configuración que nos diga qué números devueltos por la SQL son
 * errores y cuales son OK
 * 
 * @author bruno
 * 
 */
public class MSVColumnMultiResultSQL extends MSVGenericColumnValidator implements MSVColumnSQLValidator {

	private String sql;
	
	private Map<Integer, MSVResultadoValidacionSQL> resultConfig;
	
	public MSVColumnMultiResultSQL(String sql, Map<Integer, MSVResultadoValidacionSQL> list) {
		super(sql);
		if (Checks.esNulo(sql)){
			throw new IllegalArgumentException("'sql' no puede ser NULL");
		}
		
		if (Checks.estaVacio(list)){
			throw new IllegalArgumentException("'resultConfig' no puede ser NULL ni estar VACIO");
		}
		this.sql = sql;
		this.resultConfig = list;
	}


	@Override
	public String getTipoValidacion() {
		return CONFIGURABLE;
	}

	@Override
	public String getErrorMessage() {
		// Se devuelve NULL porque esto viene en la configracion
		return null;
	}

	@Override
	public boolean isRequired() {
		// Gestionamos si el valor es requerido o no durante la validación de
		// formato
		return false;
	}


	@Override
	public Map<Integer, MSVResultadoValidacionSQL> getResultConfig() {
		return this.resultConfig;
	}


	public String getSql() {
		return sql;
	}
	
}
