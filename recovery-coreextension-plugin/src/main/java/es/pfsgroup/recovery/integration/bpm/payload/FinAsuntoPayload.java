package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.Date;

import es.capgemini.pfs.asunto.model.Asunto;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class FinAsuntoPayload {
	
	private final static String KEY = "@fasu";

	private static final String CAMPO_MOTIVO = String.format("%s.motivo", KEY);
	private static final String CAMPO_OBSERVACIONES = String.format("%s.observaciones", KEY);
	private static final String CAMPO_FECHA_FIN = String.format("%s.fechaFin", KEY);

	private final DataContainerPayload data;
	private final AsuntoPayload asunto;
	
	public FinAsuntoPayload(String tipo, Asunto asunto, MEJFinalizarAsuntoDto asuntoDto) {
		this(new DataContainerPayload(null, null), asunto, asuntoDto);
	}
	
	public FinAsuntoPayload(DataContainerPayload data, Asunto asunto, MEJFinalizarAsuntoDto asuntoDto) {
		this.data = data;
		this.asunto = new AsuntoPayload(data, asunto);
		build(asuntoDto);
	}
	
	public FinAsuntoPayload(DataContainerPayload data) {
		this.data = data;
		this.asunto = new AsuntoPayload(data);
	}

	public AsuntoPayload getAsunto() {
		return asunto;
	}

	public void build(MEJFinalizarAsuntoDto asuntoDto) {
		this.setMotivo(asuntoDto.getMotivoFinalizacion());
		this.setObservaciones(asuntoDto.getObservaciones());
		this.setFechaFin(asuntoDto.getFechaFinalizacion());
	}
	
	public void setMotivo(String valor) {
		this.data.addCodigo(CAMPO_MOTIVO, valor);
	}
	
	public String getMotivo() {
		return this.data.getCodigo(CAMPO_MOTIVO);
	}
	
	public void setObservaciones(String valor) {
		this.data.addExtraInfo(CAMPO_OBSERVACIONES, valor);
	}
	
	public String getObservaciones() {
		return this.data.getExtraInfo(CAMPO_OBSERVACIONES);
	}

	public void setFechaFin(Date valor) {
		this.data.addFecha(CAMPO_FECHA_FIN, valor);
	}
	
	public Date getFechaFin() {
		return this.data.getFecha(CAMPO_FECHA_FIN);
	}
	
}
