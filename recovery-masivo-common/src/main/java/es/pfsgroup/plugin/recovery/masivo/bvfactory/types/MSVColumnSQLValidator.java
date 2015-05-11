package es.pfsgroup.plugin.recovery.masivo.bvfactory.types;


/**
 * Sub-tipo de valdiador que usa una query SQL para validar.
 * @author bruno
 *
 */
public interface MSVColumnSQLValidator extends MSVColumnValidator{
	
	/**
	 * Devuelve la SQL de comprobaci�n que define este validador
	 * @param cellValue Valor de la celda del Excel que queremos validar
	 * @return
	 */
	String giveMeSqlChe(String cellValue);

}
