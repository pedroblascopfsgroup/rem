package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types;

/**
 * Resultado de la ejecución de una SQL OK
 * @author bruno
 *
 */
public class MSVResultadoValidacionSQLOK implements MSVResultadoValidacionSQL{

	@Override
	public boolean isError() {
		return false;
	}

	@Override
	public String getErrorMessage() {
		return null;
	}

}
