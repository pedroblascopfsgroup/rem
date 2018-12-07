package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.types;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnSQLValidator;

/**
 * Clase genérica para los validadores de clolumna
 * @author bruno
 *
 */
public abstract class MSVGenericColumnValidator implements MSVColumnSQLValidator {
	
	public static final String VALUE_TOKEN = "1gV2GA3gL4GO5gR6G";
	
	private String query;
	
	public MSVGenericColumnValidator(String query) {
		super();
		this.query = query;
	}

	@Override
	public final String giveMeSqlChe(String cellValue) {
		return this.query.replaceAll(VALUE_TOKEN, cellValue);
	}
}
