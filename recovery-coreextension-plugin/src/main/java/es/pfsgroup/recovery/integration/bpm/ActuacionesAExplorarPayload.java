package es.pfsgroup.recovery.integration.bpm;

import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public class ActuacionesAExplorarPayload {

	public final static String KEY = "@aea";

	private static final String CAMPO_OBSERVACIONES = String.format("%s.observaciones", KEY);
	private static final String CAMPO_TIPO_SOLUCION_AMISTOSA = String.format("%s.subtipoSolAmis", KEY);
	private static final String CAMPO_VALORACION_ACT_AMISTOSA = String.format("%s.valActAmis", KEY);
	
	private final DataContainerPayload data;

	public DataContainerPayload getData() {
		return data;
	}

	public ActuacionesAExplorarPayload(DataContainerPayload data) {
		this.data = data;
	}
	
	public ActuacionesAExplorarPayload(String tipo, ActuacionesAExplorarAcuerdo actuacion) {
		this.data = new DataContainerPayload(tipo);
		build(actuacion);
	}

	public ActuacionesAExplorarPayload build(ActuacionesAExplorarAcuerdo actuacion) {
		if (Checks.esNulo(actuacion.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] La Actuación Realizada con ID %d del Acuerdo no tiene referencia de sincronización GUID", actuacion.getId()));
		}
		this.addGuid(actuacion.getGuid());
		this.addIdOrigen(actuacion.getId());
		
		if (actuacion.getDdSubtipoSolucionAmistosaAcuerdo()!=null) {
			setSubtipoSolucionAmistosa(actuacion.getDdSubtipoSolucionAmistosaAcuerdo().getCodigo());
		}
		if (actuacion.getDdValoracionActuacionAmistosa()!=null) {
			setValoracionActuacionAmistosa(actuacion.getDdValoracionActuacionAmistosa().getCodigo());
		}
		setObservaciones(actuacion.getObservaciones());
		return this;
	}


	private void setValoracionActuacionAmistosa(String codigo) {
		data.addCodigo(CAMPO_VALORACION_ACT_AMISTOSA, codigo);
	}
	public String getValoracionActuacionAmistosa() {
		return data.getCodigo(CAMPO_VALORACION_ACT_AMISTOSA);
	}

	private void setSubtipoSolucionAmistosa(String codigo) {
		data.addCodigo(CAMPO_TIPO_SOLUCION_AMISTOSA, codigo);
	}
	public String getSubtipoSolucionAmistosa() {
		return data.getCodigo(CAMPO_TIPO_SOLUCION_AMISTOSA);
	}

	private void setObservaciones(String valor) {
		data.addExtraInfo(CAMPO_OBSERVACIONES, valor);
	}
	public String getObservaciones() {
		return data.getExtraInfo(CAMPO_OBSERVACIONES);
	}

	public Long getIdOrigen() {
		return data.getIdOrigen(KEY);
	}
	public void addIdOrigen(Long valor) {
		data.addSourceId(KEY, valor);
	}

	public String getGuid() {
		return data.getGuid(KEY);
	}
	public void addGuid(String valor) {
		data.addGuid(KEY, valor);
	}
	
}
