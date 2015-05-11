package es.pfsgroup.plugin.recovery.masivo.bvfactory.types;

/**
 * Resultado de la ejecuci�n de una SQL OK
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
