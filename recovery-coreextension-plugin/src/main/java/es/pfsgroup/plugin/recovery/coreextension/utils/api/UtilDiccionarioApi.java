package es.pfsgroup.plugin.recovery.coreextension.utils.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Manager creado para recuperar los valores de un diccionario de datos
 * @author Carlos
 *
 */
public interface UtilDiccionarioApi {
	
	public static final String BO_DAME_VALORES_DICCIONARIO = "es.pfsgroup.plugin.recovery.coreextension.utils.api.dameValoresDiccionario";
	public static final String BO_DAME_TODOS_VALORES_DICCIONARIO = "es.pfsgroup.plugin.recovery.coreextension.utils.api.dameValoresDiccionarioSinBorrado";
	public static final String BO_DAME_VALOR_DICCIONARIO = "es.pfsgroup.plugin.recovery.coreextension.utils.api.dameValorDiccionario";
	public static final String BO_DAME_VALOR_DICCIONARIO_BY_COD = "es.pfsgroup.plugin.recovery.coreextension.utils.api.dameValorDiccionarioByCod";
	public static final String BO_DAME_VALOR_DICCIONARIO_BY_DES = "es.pfsgroup.plugin.recovery.coreextension.utils.api.dameValorDiccionarioByDes";
	
	/**
	 * Devuelve el listado completo de objetos de un diccionario que no han sido borrados.
	 * @param clase
	 * @return listado de objetos de tipo clase
	 */
	@BusinessOperationDefinition(BO_DAME_VALORES_DICCIONARIO)
	List dameValoresDiccionario(Class clase);

	/**
	 * Devuelve el listado completo de objetos de un diccionario.
	 * Este método se ha creado específicamente para la clase Localidad que no es auditable, 
	 * por lo tanto al acceder al campo borrado da un error
	 * @param class1
	 * @return
	 */
	@BusinessOperationDefinition(BO_DAME_TODOS_VALORES_DICCIONARIO)
	List dameValoresDiccionarioSinBorrado(Class clase);

	/**
	 * Devuelve un objeto del diccionario por id
	 * @param clase
	 * @param valor
	 * @return
	 */
	@BusinessOperationDefinition(BO_DAME_VALOR_DICCIONARIO)
	Object dameValorDiccionario(Class clase, Long valor);

	/**
	 * Devuelve un objeto del diccionario por código
	 * @param clase
	 * @param valor
	 * @return
	 */
	@BusinessOperationDefinition(BO_DAME_VALOR_DICCIONARIO_BY_COD)
	Object dameValorDiccionarioByCod(Class clase, String valor);
	
	
	/**
	 * Devuelve un objeto del diccionario por descripcion
	 * @param clase
	 * @param valor
	 * @return
	 */
	@BusinessOperationDefinition(BO_DAME_VALOR_DICCIONARIO_BY_DES)
	Object dameValorDiccionarioByDes(Class clase, String valor);

}
