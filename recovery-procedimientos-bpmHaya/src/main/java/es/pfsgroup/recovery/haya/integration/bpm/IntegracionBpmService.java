package es.pfsgroup.recovery.haya.integration.bpm;

import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;

public interface IntegracionBpmService {

	public final static String TIPO_CAB_CONVENIO = "DATOS-CONVENIO";
	public static final String TIPO_DATOS_RIESGO_OPERACIONAL = "DATOS-RIESGO-OPERACIONAL";
	
	/**
     * Enviar cabecera de convenio
     * 
     * @param convenio
     */
	void enviarDatos(Convenio convenio);

	void enviarDatos(ActualizarRiesgoOperacionalDto riesgoOperacional);
}
