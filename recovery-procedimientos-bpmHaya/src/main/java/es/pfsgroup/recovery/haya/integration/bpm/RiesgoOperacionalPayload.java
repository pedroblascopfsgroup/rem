package es.pfsgroup.recovery.haya.integration.bpm;

import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class RiesgoOperacionalPayload {
	
	public static final String KEY = "@rio";
	private static final String CAMPO_CODIGO_RIESGO_OPERACIONAL = String.format("%s.codRiesgoOperacional", KEY);

	private final DataContainerPayload data;
	
	public RiesgoOperacionalPayload(DataContainerPayload data) {
		this.data = data;
	}
	
	public RiesgoOperacionalPayload(String tipo) {
		this(new DataContainerPayload(null, null));
	}
	
	public DataContainerPayload getData() {
		return data;
	}

	public String getGuid() {
		return data.getGuid(KEY);
	}
	
	public void setGuid(String guid) {
		data.addGuid(KEY, guid);
	}
	
	public String getCodigoRiesgoOperacional() {
		return data.getCodigo(CAMPO_CODIGO_RIESGO_OPERACIONAL);
	}
	
	public void setCodigoRiesgoOperacional(String codigoRiesgoOperacional) {
		data.addCodigo(CAMPO_CODIGO_RIESGO_OPERACIONAL, codigoRiesgoOperacional);
	}
	
	public void build(ActualizarRiesgoOperacionalDto riesgoOperacionalDto, String nroContrato) 
	{
		setGuid(nroContrato);
		setCodigoRiesgoOperacional(riesgoOperacionalDto.getCodRiesgoOperacional());
	}
}
