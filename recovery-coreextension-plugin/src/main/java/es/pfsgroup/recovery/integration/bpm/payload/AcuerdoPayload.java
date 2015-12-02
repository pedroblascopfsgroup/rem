package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.Date;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.AnalisisAcuerdo;
import es.capgemini.pfs.integration.IntegrationClassCastException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public class AcuerdoPayload {

	public final static String HEADER_ACCION = "acu-accion";
	
	public final static String KEY = "@acu";
	public final static String KEY_ANALISIS = "@acu@ana";

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
	private static final String CAMPO_ES_GESTOR = String.format("%s@esGestor", KEY);
	private static final String CAMPO_ES_SUPERVISOR = String.format("%s@esSupervisor", KEY);

	private static final String CAMPO_ANALISIS_OBSERVACIONES_TITULOS = String.format("%s@observacionesTit", KEY_ANALISIS);
	private static final String CAMPO_ANALISIS_OBSERVACIONES_SOLVENCIA = String.format("%s@observacionesSolv", KEY_ANALISIS);
	private static final String CAMPO_ANALISIS_OBSERVACIONES_PAGO = String.format("%s@observacionesPag", KEY_ANALISIS);
	private static final String CAMPO_ANALISIS_IMPORTE_SOLVENCIA = String.format("%s@importeSolv", KEY_ANALISIS);
	private static final String CAMPO_ANALISIS_IMPORTE_PAGO = String.format("%s@importePago", KEY_ANALISIS);
	private static final String CAMPO_ANALISIS_CONCLUSION_TIPO_ACUERDO = String.format("%s@conclusionTipoAcu", KEY_ANALISIS);
	private static final String CAMPO_ANALISIS_CAMBIO_SOLVENCIA = String.format("%s@cambioSolvencia", KEY_ANALISIS);
	private static final String CAMPO_ANALISIS_CAPACIDAD_PAGO = String.format("%s@capacidadPago", KEY_ANALISIS);
	
	private final DataContainerPayload data;
	private final AsuntoPayload asunto;

	public AcuerdoPayload(DataContainerPayload data) {
		this.data = data;
		this.asunto = new AsuntoPayload(data);
	}

	public AcuerdoPayload(String tipo, Acuerdo acuerdo) {
		this(new DataContainerPayload(null, null), acuerdo);
	}
	
	public AcuerdoPayload(DataContainerPayload data, Acuerdo acuerdo) {
		this.data = data;
		this.asunto = new AsuntoPayload(data, acuerdo.getAsunto());
		build(acuerdo);
	}
	
	public AsuntoPayload getAsunto() {
		return asunto;
	}

	public DataContainerPayload getData() {
		return data;
	}

	public AcuerdoPayload build(Acuerdo acuerdo) {
		EXTAcuerdo extAcuerdo = EXTAcuerdo.instanceOf(acuerdo);
		if (extAcuerdo==null) {
			throw new IntegrationClassCastException(EXTAcuerdo.class, acuerdo.getClass(), String.format("No se puede recuperar SYS_GUID para el procedimiento %d.", acuerdo.getId()));
		}
		if (Checks.esNulo(extAcuerdo.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El acuerdo ID: %d no tiene referencia de sincronización", acuerdo.getId()));
		}
		
		setEsSupervisor(false);
		setEsGestor(false);
		setGuid(extAcuerdo.getGuid());
		setId(acuerdo.getId());
		
		if (acuerdo.getTipoAcuerdo()!=null) {
			setTipoAcuerdo(acuerdo.getTipoAcuerdo().getCodigo());
		}
		if (acuerdo.getSolicitante()!=null) {
			setSolicitante(acuerdo.getSolicitante().getCodigo());
		}
		if (acuerdo.getEstadoAcuerdo()!=null) {
			setEstadoAcuerdo(acuerdo.getEstadoAcuerdo().getCodigo());
		}
		if (acuerdo.getTipoPagoAcuerdo()!=null) {
			setTipoPagoAcuerdo(acuerdo.getTipoPagoAcuerdo().getCodigo());
		}
		if (acuerdo.getPeriodicidadAcuerdo()!=null) {
			setPeriodicidadAcuerdo(acuerdo.getPeriodicidadAcuerdo().getCodigo());
		}
		if (acuerdo.getTipoPalanca()!=null) {
			setTipoPalanca(acuerdo.getTipoPalanca().getCodigo());
		}
		if (acuerdo.getSubTipoPalanca()!=null) {
			setSubTipoPalanca(acuerdo.getSubTipoPalanca().getCodigo());
		}
		//if (extAcuerdo.getDespacho()!=null) {
		//	newPayload.addCodigo("despacho", extAcuerdo.getDespacho().getCodigo());
		//}

		setObservaciones(acuerdo.getObservaciones());
		setMotivo(extAcuerdo.getMotivo());

		setFechaCierre(acuerdo.getFechaCierre());
		setFechaLimite(extAcuerdo.getFechaLimite());
		setFechaPropuesta(acuerdo.getFechaPropuesta());
		setFechaEstado(acuerdo.getFechaEstado());
		setFechaSolucionPropuesta(acuerdo.getFechaResolucionPropuesta());
		

		setImportePago(acuerdo.getImportePago());
		setPeriodo(acuerdo.getPeriodo());
		setPorcentajeQuita(acuerdo.getPorcentajeQuita());
		
		return this;
	}


	public AcuerdoPayload build(AnalisisAcuerdo analisis) {
		if (analisis==null) {
			return this;
		}

		if (analisis.getDdAnalisisCapacidadPago()!=null) {
			setAnalisisCapacidadPago(analisis.getDdAnalisisCapacidadPago().getCodigo());
		}
		if (analisis.getDdCambioSolvenciaAcuerdo()!=null) {
			setAnalisisCambioSolvenciaAcuerdo(analisis.getDdCambioSolvenciaAcuerdo().getCodigo());
		}
		if (analisis.getDdConclusionTituloAcuerdo()!=null) {
			setAnalisisConclusionTituloAcuerdo(analisis.getDdConclusionTituloAcuerdo().getCodigo());
		}
		
		setAnalisisImportePago(analisis.getImportePago());
		setAnalisisImporteSolvencia(analisis.getImporteSolvencia());
		setAnalisisObservacionesPago(analisis.getObservacionesPago());
		setAnalisisObservacionesSolvencia(analisis.getObservacionesSolvencia());
		setAnalisisObservacionesTitulos(analisis.getObservacionesTitulos());
		
		return this;
	}
	
	private void setAnalisisObservacionesTitulos(String valor) {
		data.addExtraInfo(CAMPO_ANALISIS_OBSERVACIONES_TITULOS, valor);
	}
	public String getAnalisisObservacionesTitulos() {
		return data.getExtraInfo(CAMPO_ANALISIS_OBSERVACIONES_TITULOS);
	}

	private void setAnalisisObservacionesSolvencia(String valor) {
		data.addExtraInfo(CAMPO_ANALISIS_OBSERVACIONES_SOLVENCIA, valor);
	}
	public String getAnalisisObservacionesSolvencia() {
		return data.getExtraInfo(CAMPO_ANALISIS_OBSERVACIONES_SOLVENCIA);
	}
	
	private void setAnalisisObservacionesPago(String valor) {
		data.addExtraInfo(CAMPO_ANALISIS_OBSERVACIONES_PAGO, valor);
	}
	public String getAnalisisObservacionesPago() {
		return data.getExtraInfo(CAMPO_ANALISIS_OBSERVACIONES_PAGO);
	}

	private void setAnalisisImporteSolvencia(Double valor) {
		data.addNumber(CAMPO_ANALISIS_IMPORTE_SOLVENCIA, valor);
	}
	public Double getAnalisisImporteSolvencia() {
		return data.getValDouble(CAMPO_ANALISIS_IMPORTE_SOLVENCIA);
	}
	private void setAnalisisImportePago(Double valor) {
		data.addNumber(CAMPO_ANALISIS_IMPORTE_PAGO, valor);
	}
	public Double getAnalisisImportePago() {
		return data.getValDouble(CAMPO_ANALISIS_IMPORTE_PAGO);
	}

	private void setAnalisisConclusionTituloAcuerdo(String valor) {
		data.addCodigo(CAMPO_ANALISIS_CONCLUSION_TIPO_ACUERDO, valor);
	}
	public String getAnalisisConclusionTituloAcuerdo() {
		return data.getCodigo(CAMPO_ANALISIS_CONCLUSION_TIPO_ACUERDO);
	}

	private void setAnalisisCambioSolvenciaAcuerdo(String valor) {
		data.addCodigo(CAMPO_ANALISIS_CAMBIO_SOLVENCIA, valor);
	}
	public String getAnalisisCambioSolvenciaAcuerdo() {
		return data.getCodigo(CAMPO_ANALISIS_CAMBIO_SOLVENCIA);
	}

	private void setAnalisisCapacidadPago(String valor) {
		data.addCodigo(CAMPO_ANALISIS_CAPACIDAD_PAGO, valor);
	}
	public String getAnalisisCapacidadPago() {
		return data.getCodigo(CAMPO_ANALISIS_CAPACIDAD_PAGO);
	}
	
	public Long getId() {
		return data.getIdOrigen(KEY);
	}
	private void setId(Long valor) {
		data.addSourceId(KEY, valor);
	}

	public String getGuid() {
		return data.getGuid(KEY);
	}
	private void setGuid(String valor) {
		data.addGuid(KEY, valor);
	}

	public Long getPeriodo() {
		return data.getValLong(CAMPO_PERIODO);
	}
	private void setPeriodo(Long valor) {
		data.addNumber(CAMPO_PERIODO, valor);
	}

	public Double getImportePago() {
		return data.getValDouble(CAMPO_IMPORTE_PAGO);
	}
	private void setImportePago(Double valor) {
		data.addNumber(CAMPO_IMPORTE_PAGO, valor);
	}

	public Date getFechaLimite() {
		return data.getFecha(CAMPO_FECHA_LIMITE);
	}
	private void setFechaLimite(Date valor) {
		data.addFecha(CAMPO_FECHA_LIMITE, valor);
	}

	public Date getFechaCierre() {
		return data.getFecha(CAMPO_FECHA_CIERRE);
	}
	private void setFechaCierre(Date valor) {
		data.addFecha(CAMPO_FECHA_CIERRE, valor);
	}

	public String getObservaciones() {
		return data.getExtraInfo(CAMPO_OBSERVACIONES);
	}
	private void setObservaciones(String valor) {
		data.addExtraInfo(CAMPO_OBSERVACIONES, valor);
	}

	public String getMotivo() {
		return data.getExtraInfo(CAMPO_MOTIVO);
	}
	private void setMotivo(String valor) {
		data.addExtraInfo(CAMPO_MOTIVO, valor);
	}
	
	public String getPeriodicidadAcuerdo() {
		return data.getCodigo(CAMPO_PERIODICIDAD_ACUERDO);
	}
	private void setPeriodicidadAcuerdo(String valor) {
		data.addCodigo(CAMPO_PERIODICIDAD_ACUERDO, valor);
	}

	public String getTipoPagoAcuerdo() {
		return data.getCodigo(CAMPO_TIPO_PAGO_ACUERDO);
	}
	private void setTipoPagoAcuerdo(String valor) {
		data.addCodigo(CAMPO_TIPO_PAGO_ACUERDO, valor);
	}

	public String getEstadoAcuerdo() {
		return data.getCodigo(CAMPO_ESTADO_ACUERDO);
	}
	private void setEstadoAcuerdo(String valor) {
		data.addCodigo(CAMPO_ESTADO_ACUERDO, valor);
	}

	public String getSolicitante() {
		return data.getCodigo(CAMPO_SOLICITANTE);
	}
	private void setSolicitante(String valor) {
		data.addCodigo(CAMPO_SOLICITANTE, valor);
	}

	public String getTipoAcuerdo() {
		return data.getCodigo(CAMPO_TIPO_ACUERDO);
	}
	private void setTipoAcuerdo(String valor) {
		data.addCodigo(CAMPO_TIPO_ACUERDO, valor);
	}

	public String getTipoPalanca() {
		return data.getCodigo(CAMPO_TIPO_PALANCA);
	}
	private void setTipoPalanca(String valor) {
		data.addCodigo(CAMPO_TIPO_PALANCA, valor);
	}

	public String getSubTipoPalanca() {
		return data.getCodigo(CAMPO_SUBTIPO_PALANCA);
	}
	private void setSubTipoPalanca(String valor) {
		data.addCodigo(CAMPO_SUBTIPO_PALANCA, valor);
	}

	public Integer getPorcentajeQuita() {
		return data.getValInt(CAMPO_PORCENTAJE_QUITA);
	}
	private void setPorcentajeQuita(Integer valor) {
		data.addNumber(CAMPO_PORCENTAJE_QUITA, valor);
	}

	public Date getFechaSolucionPropuesta() {
		return data.getFecha(CAMPO_FECHA_SOLUCION_PROPUESTA);
	}
	private void setFechaSolucionPropuesta(Date valor) {
		data.addFecha(CAMPO_FECHA_SOLUCION_PROPUESTA, valor);
	}

	public Date getFechaEstado() {
		return data.getFecha(CAMPO_FECHA_ESTADO);
	}
	private void setFechaEstado(Date valor) {
		data.addFecha(CAMPO_FECHA_ESTADO, valor);
	}

	public Date getFechaPropuesta() {
		return data.getFecha(CAMPO_FECHA_PROPUESTA);
	}
	private void setFechaPropuesta(Date valor) {
		data.addFecha(CAMPO_FECHA_PROPUESTA, valor);
	}

	public Boolean getEsGestor() {
		return data.getFlag(CAMPO_ES_GESTOR);
	}
	public void setEsGestor(Boolean valor) {
		data.addFlag(CAMPO_ES_GESTOR, valor);
	}
	public Boolean getEsSupervisor() {
		return data.getFlag(CAMPO_ES_SUPERVISOR);
	}
	public void setEsSupervisor(Boolean valor) {
		data.addFlag(CAMPO_ES_SUPERVISOR, valor);
	}

}
