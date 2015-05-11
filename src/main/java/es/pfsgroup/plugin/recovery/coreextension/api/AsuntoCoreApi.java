package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.Date;

import es.capgemini.pfs.asunto.model.Asunto;

/**
 * Api base de cancelaci�n y paralizaci�n de asuntos. 
 * Creada para evitar la dependencia del batch con la api de mejoras.
 * 
 *  Ver {@link MEJFinalizarAsuntoApi}
 * 
 * @author manuel
 *
 */
public interface AsuntoCoreApi {

	/**
	 * Cancela un asunto. Implementado en el plugin de mejoras. 
	 * 
	 * @param asunto {@link Asunto}
	 * @param fechaCancelacion Fecha de cancelaci�n
	 */
	public void cancelaAsunto(Asunto asunto, Date fechaCancelacion);
	
	/**
	 * Paraliza un asunto. Implementado en el plugin de mejoras. 
	 * 
	 * @param asunto {@link Asunto}
	 * @param fechaParalizacion Fecha de paralizaci�n.
	 */
	public void paralizaAsunto(Asunto asunto, Date fechaParalizacion);
	
	/**
	 * Cancela un asunto con motivo. Implementado en el plugin de mejoras. 
	 * 
	 * @param asunto {@link Asunto}
	 * @param fechaCancelacion Fecha de cancelaci�n
	 * @param motivoCancelacion Motivo Cancelaci�n
	 */
	public void cancelaAsuntoConMotivo(Asunto asunto, Date fechaCancelacion,String motivoCancelacion);

	
}
