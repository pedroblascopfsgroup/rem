package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoFinanciero;

public interface AltaActivoService extends GenericService{
	
	public static final String CODIGO_ALTA_ACTIVO_FINANCIERO = "FINANCIERO";
	
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
	public String[] getTipoAltaActivo();
	
	/**
	 * Metodo principal que gestiona el alta de activo, del tipo indicado al servicio
	 * indicando como parametro un DTO con los datos a registrar
	 * @param activo
	 * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	public Boolean procesarAlta(DtoAltaActivoFinanciero dtoAAF) throws Exception;

	/**
	 * Metodo con validaciones para el alta de activos financieros.
	 * Las validaciones son gestionadas por excepciones de usuario.
	 * @param dtoAAF
	 * @throws Exception
	 */
	public void validarAlta(DtoAltaActivoFinanciero dtoAAF) throws Exception;

	/**
	 * Metodo que transfiere los datos del DTO a la entidad Activo
	 * @param dtoAAF
	 * @return
	 * @throws Exception
	 */
	public Activo dtoToEntityActivo(DtoAltaActivoFinanciero dtoAAF) throws Exception;
	
	/**
	 * Metodo que persiste el nuevo activo en BBDD
	 * @param activo
	 * @throws Exception
	 */
	public void saveEntityActivo(Activo activo) throws Exception;




	

}
