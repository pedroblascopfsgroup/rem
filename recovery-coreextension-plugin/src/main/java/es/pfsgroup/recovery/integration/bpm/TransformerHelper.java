package es.pfsgroup.recovery.integration.bpm;

import es.pfsgroup.recovery.integration.DataContainerPayload;

public interface TransformerHelper {

	/**
	 * Amplia la información del contenedor de datos.
	 * 
	 * @param dataPayload
	 */
	public void ampliar(DataContainerPayload dataPayload);
	
}
