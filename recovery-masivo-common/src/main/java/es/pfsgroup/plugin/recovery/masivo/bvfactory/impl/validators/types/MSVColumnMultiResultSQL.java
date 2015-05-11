package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.types;

import java.util.Map;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnSQLValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;

/**
 * El prop�sito de esta clase es la de poder hacer una validaci�n de una columna
 * mediante una SQL que nos devuelve un �nico resultado num�rico, y poder
 * pasarle una configuraci�n que nos diga qu� n�meros devueltos por la SQL son
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
		// Gestionamos si el valor es requerido o no durante la validaci�n de
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
