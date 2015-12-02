package es.pfsgroup.recovery.haya.integration.bpm;

import es.pfsgroup.concursal.convenio.model.Convenio;

public interface IntegracionBpmService {

	public final static String TIPO_CAB_CONVENIO = "DATOS-CONVENIO";
	
	/**
     * Enviar cabecera de convenio
     * 
     * @param convenio
     */
	void enviarDatos(Convenio convenio);
}
