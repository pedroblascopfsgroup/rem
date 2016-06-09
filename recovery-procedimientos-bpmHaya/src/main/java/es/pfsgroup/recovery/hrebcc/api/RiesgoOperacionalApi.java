package es.pfsgroup.recovery.hrebcc.api;


import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;

import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.model.CntRiesgoOperacional;
import es.pfsgroup.recovery.hrebcc.model.DDRiesgoOperacional;

public interface RiesgoOperacionalApi {

	public void actualizarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto);
	
	public void borrarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto);
	
	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_GET_RIESGO)
	public HashMap<String, Object> obtenerRiesgoOperacionalContratoHash(Long cntId) throws IllegalAccessException, InvocationTargetException;
	
	public DDRiesgoOperacional obtenerRiesgoOperacionalContrato(Long cntId);
	
	public CntRiesgoOperacional getRiesgoOperacionalContrato(Long cntId);

	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_GET_VENCIDOS)
	public HashMap<String, Object> obtenerVencidosByCntIdHash(Long cntId) throws IllegalAccessException, InvocationTargetException;
	
	
	public Boolean comprobarRiesgoProcedimiento(Long idProcedimiento);
	
	/**
	 * Comprueba si el tipo de expediente de los expedientes de un contrato son Recuperacion o Seguimiento
	 * @param idContrato
	 * @return
	 */
	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_COMPRUEBA_TIPO_EXP)
	public Boolean compruebaTipoExpediente(Long idContrato);
	
	/**
	 * Comprueba si el asunto del contrato es del tipo Concursal, litigio o precontencioso
	 * @param idContrato
	 * @return
	 */
	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_COMPRUEBA_TIPO_ASUNTO)
	public Boolean compruebaAsunto(Long idContrato);
}
