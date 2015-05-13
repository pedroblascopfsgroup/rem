package es.pfsgroup.plugin.controlcalidad.manager.api;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.controlcalidad.constantes.ControlCalidadConstants.ControlCalidadConstantes;
import es.pfsgroup.plugin.controlcalidad.model.ControlCalidadProcedimientoDto;

/**
 * Interfaz de constantes para el manager de Control de Calidad
 * @author Guillem
 *
 */
public interface ControlCalidadManager {

	/**
	 * Método para registrar eventos de los procedimeintos de recobro en el modelo del control de calidad 
	 * @param controlCalidadProcedimientoDto
	 */
	@BusinessOperation(ControlCalidadConstantes.BO_CONTROL_CALIDAD_REGISTRAR_INCIDENCIA_PROCEDIMIENTO_RECOBRO)
	public void registrarIncidenciaProcedimientoRecobro(ControlCalidadProcedimientoDto controlCalidadProcedimientoDto);
	
}
