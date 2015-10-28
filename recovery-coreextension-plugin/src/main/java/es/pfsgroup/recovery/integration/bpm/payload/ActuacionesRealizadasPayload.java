package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.Date;

import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public class ActuacionesRealizadasPayload {

	public final static String KEY = "@aar";

	private static final String CAMPO_OBSERVACIONES = String.format("%s.observaciones", KEY);
	private static final String CAMPO_FECHA = String.format("%s.fecha", KEY);
	private static final String CAMPO_TIPO_AYUDA = String.format("%s.tipoAyuda", KEY);
	private static final String CAMPO_TIPO = String.format("%s.tipo", KEY);
	private static final String CAMPO_RESULTADO = String.format("%s.resultado", KEY);
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);
	
	private final DataContainerPayload data;
	private final AcuerdoPayload acuerdo;

	public DataContainerPayload getData() {
		return data;
	}

	public ActuacionesRealizadasPayload(DataContainerPayload data) {
		this.data = data;
		this.acuerdo = new AcuerdoPayload(data);
	}
	
	public ActuacionesRealizadasPayload(String tipo, ActuacionesRealizadasAcuerdo actuacion) {
		this(new DataContainerPayload(null, null), actuacion);
	}

	public ActuacionesRealizadasPayload(DataContainerPayload data, ActuacionesRealizadasAcuerdo actuacion) {
		this.data = data;
		this.acuerdo = new AcuerdoPayload(data, actuacion.getAcuerdo());
		build(actuacion);
	}

	public ActuacionesRealizadasPayload build(ActuacionesRealizadasAcuerdo actuacion) {
		if (Checks.esNulo(actuacion.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] La Actuación Realizada con ID %d del Acuerdo no tiene referencia de sincronización GUID", actuacion.getId()));
		}
		this.addGuid(actuacion.getGuid());
		this.addId(actuacion.getId());
		if (actuacion.getDdResultadoAcuerdoActuacion()!=null) {
			setResultado(actuacion.getDdResultadoAcuerdoActuacion().getCodigo());
		}
		if (actuacion.getDdTipoActuacionAcuerdo()!=null) {
			setTipo(actuacion.getDdTipoActuacionAcuerdo().getCodigo());
		}
		if (actuacion.getTipoAyudaActuacion()!=null) {
			setTipoAyuda(actuacion.getTipoAyudaActuacion().getCodigo());
		}
		setFecha(actuacion.getFechaActuacion());
		setObservaciones(actuacion.getObservaciones());
		setBorrado(actuacion.getAuditoria().isBorrado());
		
		return this;
	}

	private void setObservaciones(String valor) {
		data.addExtraInfo(CAMPO_OBSERVACIONES, valor);
	}
	public String getObservaciones() {
		return data.getExtraInfo(CAMPO_OBSERVACIONES);
	}

	private void setFecha(Date valor) {
		data.addFecha(CAMPO_FECHA, valor);
	}
	public Date getFecha() {
		return data.getFecha(CAMPO_FECHA);
	}

	private void setTipoAyuda(String codigo) {
		data.addCodigo(CAMPO_TIPO_AYUDA, codigo);
	}
	public String getTipoAyudas() {
		return data.getCodigo(CAMPO_TIPO_AYUDA);
	}

	private void setTipo(String codigo) {
		data.addCodigo(CAMPO_TIPO, codigo);
	}
	public String getTipo() {
		return data.getCodigo(CAMPO_TIPO);
	}

	private void setResultado(String codigo) {
		data.addCodigo(CAMPO_RESULTADO, codigo);
	}
	public String getResultado() {
		return data.getCodigo(CAMPO_RESULTADO);
	}

	public Long getId() {
		return data.getIdOrigen(KEY);
	}
	public void addId(Long valor) {
		data.addSourceId(KEY, valor);
	}

	public String getGuid() {
		return data.getGuid(KEY);
	}
	public void addGuid(String valor) {
		data.addGuid(KEY, valor);
	}
	public Boolean isBorrado() {
		return data.getFlag(CAMPO_BORRADO);
	}
	public void setBorrado(Boolean valor) {
		data.addFlag(CAMPO_BORRADO, valor);
	}

	public AcuerdoPayload getAcuerdo() {
		return acuerdo;
	}
	
}
