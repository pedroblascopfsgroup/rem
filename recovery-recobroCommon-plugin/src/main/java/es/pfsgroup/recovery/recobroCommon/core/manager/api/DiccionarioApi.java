package es.pfsgroup.recovery.recobroCommon.core.manager.api;

import java.util.List;

import es.capgemini.pfs.cirbe.model.DDPais;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Manager creado para recuperar los valores de un diccionario de datos
 * @author diana
 *
 */
public interface DiccionarioApi {
	
	public static final String BO_DAME_VALORES_DICCIONARIO = "es.pfsgroup.plugin.recovery.core.api.dameValoresDiccionario";
	public static final String BO_DAME_TODOS_VALORES_DICCIONARIO = "es.pfsgroup.plugin.recovery.core.api.dameValoresDiccionarioSinBorrado";
	public static final String BO_DAME_VALOR_DICCIONARIO = "es.pfsgroup.plugin.recovery.core.api.dameValorDiccionario";
	public static final String BO_DAME_VALOR_DICCIONARIO_BY_COD = "es.pfsgroup.plugin.recovery.core.api.dameValorDiccionarioByCod";
	public static final String BO_DAME_LOCALIDADES_POR_PROVINCIA = "es.pfsgroup.plugin.recovery.core.api.dameLocalidadesByProvincia";
	public static final String BO_GET_LOCALIDAD_BY_CODIGO = "es.pfsgroup.plugin.recovery.core.api.dameLocalidadByCodigo";
	public static final String BO_GET_PROVINCIA_BY_CODIGO = "es.pfsgroup.plugin.recovery.core.api.dameProvinciaByCodigo";
	public static final String BO_GET_PAIS_BY_CODIGO = "es.pfsgroup.plugin.recovery.core.api.damePaisByCodigo";
	public static final String BO_GET_TIPO_VIA_BY_CODIGO = "es.pfsgroup.plugin.recovery.core.api.dameTipoViaByCodigo";
	public static final String BO_GET_DD_RULE_DEFINITION = "es.pfsgroup.plugin.recovery.core.api.getReglas";
	public static final String BO_GET_DD_SI_NO = "es.pfsgroup.plugin.recovery.core.api.dameDDSiNo";
	
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
	 * Devuelve la lista de localidades que pertenecen a una provincia
	 * @param id de la provincia
	 * @return listado de localidades
	 */
	@BusinessOperationDefinition(BO_DAME_LOCALIDADES_POR_PROVINCIA)
	List<Localidad> getLocalidadesByProvincia(Long idProvincia);
	
	/**
	 * Devuelve el objeto de la clase localidad que tiene ese codigo
	 * He implementado aquí este método por comodidad, pero igual sería interesante crear el localidadApi
	 * @param codigo
	 * @return objeto de la clase Localidad
	 */
	@BusinessOperationDefinition(BO_GET_LOCALIDAD_BY_CODIGO)
	Localidad getLocalidadByCodigo(String codigo);
	
	/**
	 * Devuelve el objeto de la clase ddprovincia que tiene ese codigo
	 * He implementado aquí este método por comodidad, pero igual sería interesante crear el provinciaApi
	 * @param codigo
	 * @return objeto de la clase DDProvincia
	 */
	@BusinessOperationDefinition(BO_GET_PROVINCIA_BY_CODIGO)
	DDProvincia getProvinciaByCodigo (String codigo);
	
	/**
	 * Devuelve el objeto de la clase DDTipoVia que tiene ese codigo
	 * He implementado aquí este método por comodidad, pero igual sería interesante crear el DDTipoViaApi
	 * @param codigo
	 * @return objeto de la clase DDTipoVia
	 */
	@BusinessOperationDefinition(BO_GET_TIPO_VIA_BY_CODIGO)
	DDTipoVia getTipoViaByCodigo (String codigo);
	
	/**
	 * Devuelve el objeto de la clase ddprovincia que tiene ese codigo
	 * He implementado aquí este método por comodidad, pero igual sería interesante crear el provinciaApi
	 * @param codigo
	 * @return objeto de la clase DDPais
	 */
	@BusinessOperationDefinition(BO_GET_PAIS_BY_CODIGO)
	DDPais getPaisByCodigo (String codigo);
	
	/**
	 * Devuelve el listado de RuleDefinition
	 * @return lista de RuleDefinition
	 */
	@BusinessOperationDefinition(BO_GET_DD_RULE_DEFINITION)
	List<RuleDefinition> getReglas ();
	
	/**
	 * Devuelve el diccionario SiNo
	 * @return lista de DDSiNo
	 */
	@BusinessOperationDefinition(BO_GET_DD_SI_NO)
	List<DDSiNo> getDDsino();

}
