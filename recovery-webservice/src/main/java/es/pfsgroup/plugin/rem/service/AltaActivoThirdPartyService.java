package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoThirdParty;

public interface AltaActivoThirdPartyService extends GenericService{
	
	public static final String CODIGO_ALTA_ACTIVO_THIRD_PARTY = "THIRDPARTY";
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	
	/**
	 * C�digo de tipo de operaci�n para el que aplica este servicio.
	 * @return
	 */
	public String[] getKeys();

	/**
	 * Metodo que devuelve el tipo de alta del servicio
	 * @return
	 */
	public String[] getTipoAltaActivoThirdParty();

	/**
	 * Metodo principal que gestiona el alta de activo, del tipo indicado al servicio
	 * indicando como parametro un DTO con los datos a registrar
	 * @param activo
	 * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	public Boolean procesarAlta(DtoAltaActivoThirdParty dtoAATP) throws Exception;
}
