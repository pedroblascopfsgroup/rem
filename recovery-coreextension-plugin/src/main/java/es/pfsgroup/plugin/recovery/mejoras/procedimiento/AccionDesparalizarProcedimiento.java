package es.pfsgroup.plugin.recovery.mejoras.procedimiento;

import es.capgemini.pfs.asunto.model.Procedimiento;

public interface AccionDesparalizarProcedimiento {

	/**
	 * Ejecuta la acción.
	 * 
	 * @param prc
	 */
	void ejecutar(Procedimiento prc);
	
}
