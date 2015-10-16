package es.pfsgroup.recovery.integration.bpm.payload;

import es.capgemini.pfs.asunto.model.Asunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public class AsuntoPayload {
	
	private final static String KEY_ASUNTO = "@asu";

	private final DataContainerPayload data;

	public AsuntoPayload(String tipo, Asunto asunto) {
		this(new DataContainerPayload(null, null), asunto);
	}
	
	public AsuntoPayload(DataContainerPayload data, Asunto asunto) {
		this.data = data;
		build(asunto);
	}
	
	public AsuntoPayload(DataContainerPayload data) {
		this.data = data;
	}

	public Long getIdOrigen() {
		return data.getIdOrigen().get(KEY_ASUNTO);
	}
	
	public String getGuid() {
		return data.getGuid().get(KEY_ASUNTO);
	}

	public void build(Asunto asunto) {
		EXTAsunto extAsunto = EXTAsunto.instanceOf(asunto);
		if (extAsunto.getGuid() == null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El asunto ID: %d no tiene código externo, no se puede sincronizar", asunto.getId()));
		}
		data.addGuid(KEY_ASUNTO, extAsunto.getGuid());
		data.addSourceId(KEY_ASUNTO, asunto.getId());
	}
	
	
}
