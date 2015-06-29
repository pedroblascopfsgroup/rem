package es.pfsgroup.recovery.integration.bpm;

import java.util.Date;

import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class AcuerdoPayload {
	
	public final static String KEY = "@acu";

	private static final String CAMPO_SOLICITANTE = String.format("%s.solicitante", KEY);
	private static final String CAMPO_TIPO_ACUERDO = String.format("%s.tipo", KEY);
	private static final String CAMPO_ESTADO_ACUERDO = String.format("%s.estado", KEY);
	private static final String CAMPO_TIPO_PAGO_ACUERDO = String.format("%s.tipoPago", KEY);
	private static final String CAMPO_PERIODICIDAD_ACUERDO = String.format("%s.periodicidad", KEY);
	private static final String CAMPO_TIPO_PALANCA = String.format("%s.tipoPalanca", KEY);
	private static final String CAMPO_SUBTIPO_PALANCA = String.format("%s.subtipoPalanca", KEY);
	private static final String CAMPO_OBSERVACIONES = String.format("%s.observaciones", KEY);
	private static final String CAMPO_MOTIVO = String.format("%s.motivo", KEY);
	private static final String CAMPO_FECHA_PROPUESTA = String.format("%s.fechaPropuesta", KEY);
	private static final String CAMPO_FECHA_ESTADO = String.format("%s.fechaEstado", KEY);
	private static final String CAMPO_FECHA_CIERRE = String.format("%s.fechaCierre", KEY);
	private static final String CAMPO_FECHA_SOLUCION_PROPUESTA = String.format("%s.fechaSolucionPropuesta", KEY);
	private static final String CAMPO_FECHA_LIMITE = String.format("%s.fechaLimite", KEY);
	private static final String CAMPO_IMPORTE_PAGO = String.format("%s.importePago", KEY);
	private static final String CAMPO_PERIODO = String.format("%s.periodo", KEY);
	private static final String CAMPO_PORCENTAJE_QUITA = String.format("%s.porcentajeQuita", KEY);
	
	private final DataContainerPayload data;
	private final AsuntoPayload asunto;

	public AcuerdoPayload(DataContainerPayload data) {
		this.data = data;
		this.asunto = new AsuntoPayload(data);
	}
	
	public AcuerdoPayload(String tipo, EXTAcuerdo acuerdo) {
		this(new DataContainerPayload(tipo), acuerdo);
	}

	public AcuerdoPayload(DataContainerPayload data, EXTAcuerdo acuerdo) {
		this.data = data;
		this.asunto = new AsuntoPayload(data);
		build(acuerdo);
	}
	
	public AsuntoPayload getAsunto() {
		return asunto;
	}

	public void build(EXTAcuerdo acuerdo) {
		
		data.addGuid(KEY, acuerdo.getGuid());
		data.addSourceId(KEY, acuerdo.getId());
		
		if (acuerdo.getTipoAcuerdo()!=null) {
			data.addCodigo(CAMPO_TIPO_ACUERDO, acuerdo.getTipoAcuerdo().getCodigo());
		}
		if (acuerdo.getSolicitante()!=null) {
			data.addCodigo(CAMPO_SOLICITANTE, acuerdo.getSolicitante().getCodigo());
		}
		if (acuerdo.getEstadoAcuerdo()!=null) {
			data.addCodigo(CAMPO_ESTADO_ACUERDO, acuerdo.getEstadoAcuerdo().getCodigo());
		}
		if (acuerdo.getTipoPagoAcuerdo()!=null) {
			data.addCodigo(CAMPO_TIPO_PAGO_ACUERDO, acuerdo.getTipoPagoAcuerdo().getCodigo());
		}
		if (acuerdo.getPeriodicidadAcuerdo()!=null) {
			data.addCodigo(CAMPO_PERIODICIDAD_ACUERDO, acuerdo.getPeriodicidadAcuerdo().getCodigo());
		}
		if (acuerdo.getTipoPalanca()!=null) {
			data.addCodigo(CAMPO_TIPO_PALANCA, acuerdo.getTipoPalanca().getCodigo());
		}
		if (acuerdo.getSubTipoPalanca()!=null) {
			data.addCodigo(CAMPO_SUBTIPO_PALANCA, acuerdo.getSubTipoPalanca().getCodigo());
		}
		//if (extAcuerdo.getDespacho()!=null) {
		//	newPayload.addCodigo("despacho", extAcuerdo.getDespacho().getCodigo());
		//}
		
		data.addExtraInfo(CAMPO_OBSERVACIONES, acuerdo.getObservaciones());
		data.addExtraInfo(CAMPO_MOTIVO, acuerdo.getMotivo());

		data.addFecha(CAMPO_FECHA_PROPUESTA, acuerdo.getFechaPropuesta());
		data.addFecha(CAMPO_FECHA_ESTADO, acuerdo.getFechaEstado());
		data.addFecha(CAMPO_FECHA_CIERRE, acuerdo.getFechaCierre());
		data.addFecha(CAMPO_FECHA_SOLUCION_PROPUESTA, acuerdo.getFechaResolucionPropuesta());
		data.addFecha(CAMPO_FECHA_LIMITE, acuerdo.getFechaLimite());

		data.addNumber(CAMPO_IMPORTE_PAGO, acuerdo.getImportePago());
		data.addNumber(CAMPO_PERIODO, acuerdo.getPeriodo());
		data.addNumber(CAMPO_PORCENTAJE_QUITA, acuerdo.getPorcentajeQuita());
		
	}

	public Long getIdOrigen() {
		return data.getIdOrigen(KEY);
	}

	public String getGuid() {
		return data.getGuid(KEY);
	}

	public Long getPeriodo() {
		return data.getValLong(CAMPO_PERIODO);
	}

	public Double getImportePago() {
		return data.getValDouble(CAMPO_IMPORTE_PAGO);
	}

	public Date getFechaLimite() {
		return data.getFecha(CAMPO_FECHA_LIMITE);
	}

	public Date getFechaCierre() {
		return data.getFecha(CAMPO_FECHA_CIERRE);
	}

	public String getObservaciones() {
		return data.getExtraInfo(CAMPO_OBSERVACIONES);
	}

	public String getPeriodicidadAcuerdo() {
		return data.getCodigo(CAMPO_PERIODICIDAD_ACUERDO);
	}

	public String getTipoPagoAcuerdo() {
		return data.getCodigo(CAMPO_TIPO_PAGO_ACUERDO);
	}

	public String getEstadoAcuerdo() {
		return data.getCodigo(CAMPO_ESTADO_ACUERDO);
	}

	public String getSolicitante() {
		return data.getCodigo(CAMPO_SOLICITANTE);
	}

	public String getTipoAcuerdo() {
		return data.getCodigo(CAMPO_TIPO_ACUERDO);
	}
	
}
