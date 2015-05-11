package es.pfsgroup.plugin.recovery.masivo.bvfactory.types;

/**
 * Resultado devuelto por una SQL de valiación. Esta interfaz se usa en las validaciones de negocio de tipo Multi Result SQL
 * @author bruno
 *
 */
public interface MSVResultadoValidacionSQL {
	
	public boolean isError();
	
	public String getErrorMessage();

}
