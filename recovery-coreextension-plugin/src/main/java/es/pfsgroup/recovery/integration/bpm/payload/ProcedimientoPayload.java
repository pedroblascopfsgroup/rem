package es.pfsgroup.recovery.integration.bpm.payload;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.integration.IntegrationClassCastException;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;

public class ProcedimientoPayload {
	
	public static final String JBPM_TRANSICION = "transicion";
	public static final String JBPM_TAR_GUID_ORIGEN = "tar-guid-origen";
	public static final String EXTRA_FIELD = "$extra";
	
	public final static String KEY_PROCEDIMIENTO = "@prc";
	public final static String KEY_PROCEDIMIENTO_PADRE = "@prc.padre";
	
	private static final String CAMPO_DECIDIDO = String.format("%s.decidido", KEY_PROCEDIMIENTO);
	private static final String CAMPO_FECHA_RECOPILACION = String.format("%s.recopilacion", KEY_PROCEDIMIENTO);
	private static final String CAMPO_TIPO_RECLAMACION = String.format("%s.tipoReclamacion", KEY_PROCEDIMIENTO);
	private static final String CAMPO_ESTADO = String.format("%s.estado", KEY_PROCEDIMIENTO);
	private static final String CAMPO_JUZGADO = String.format("%s.juzgado", KEY_PROCEDIMIENTO);
	private static final String CAMPO_COD_PROC_EN_JUZGADO = String.format("%s.codProcEnJuzgado", KEY_PROCEDIMIENTO);
	private static final String CAMPO_OBSERVACIONES = String.format("%s.observaciones", KEY_PROCEDIMIENTO);
	private static final String CAMPO_PLAZO_RECUPERACION = String.format("%s.plazoRecuperacion", KEY_PROCEDIMIENTO);
	private static final String CAMPO_PORCENTAJE_RECUPERACION = String.format("%s.porcentajeRecuperacion", KEY_PROCEDIMIENTO);
	private static final String CAMPO_SALDO_ORIG_NO_VENCIDO = String.format("%s.saldoOriginalNoVencido", KEY_PROCEDIMIENTO);
	private static final String CAMPO_SALDO_ORIG_VENCIDO = String.format("%s.saldoOriginalVencido", KEY_PROCEDIMIENTO);
	private static final String CAMPO_SALDO_RECUPERACION = String.format("%s.saldoRecuperacion", KEY_PROCEDIMIENTO);
	private static final String RELACION_PERSONAS = String.format("%s.per", KEY_PROCEDIMIENTO);
	private static final String RELACION_CONTRATOS_EXPEDIENTES = String.format("%s.cex", KEY_PROCEDIMIENTO);
	private static final String CAMPO_TIPO_ACTUACION = String.format("%s.tipoActuacion", KEY_PROCEDIMIENTO);

	private static final String CAMPO_ESTA_PARALIZADO = String.format("%s.estaParalizado", KEY_PROCEDIMIENTO);
	private static final String CAMPO_ESTA_FECHA_ULT_PARALIZACION = String.format("%s.fechaUltParalizacion", KEY_PROCEDIMIENTO);
	private static final String CAMPO_PLAZO_PARALIZACION = String.format("%s.plazoParalizacion", KEY_PROCEDIMIENTO);

	private final DataContainerPayload data;
	public DataContainerPayload getData() {
		return data;
	}

	private final AsuntoPayload asunto;

	public ProcedimientoPayload(DataContainerPayload data) {
		this.data = data;
		this.asunto = new AsuntoPayload(data);
	}
	
	public ProcedimientoPayload(String tipo, Procedimiento procedimiento) {
		this(new DataContainerPayload(null, null), procedimiento);
	}

	public ProcedimientoPayload(DataContainerPayload data, Procedimiento procedimiento) {
		this.data = data;
		this.asunto = new AsuntoPayload(data, procedimiento.getAsunto());
		build(procedimiento);
	}

	public AsuntoPayload getAsunto() {
		return asunto;
	}

	public void build(Procedimiento proc) {
		MEJProcedimiento procedimiento = MEJProcedimiento.instanceOf(proc);
		if (procedimiento==null) {
			throw new IntegrationClassCastException(MEJProcedimiento.class, proc.getClass(), String.format("No se puede recuperar SYS_GUID para el procedimiento %d.", proc.getId()));
		}
		if (Checks.esNulo(procedimiento.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento ID: %d no tiene referencia de sincronización", procedimiento.getId()));
		}
		
		setIdOrigen(procedimiento.getId());
		setTipoProcedimiento(procedimiento.getTipoProcedimiento().getCodigo());
		setGuid(procedimiento.getGuid());
		if (procedimiento.getTipoActuacion()!=null) {
			setTipoActuacion(procedimiento.getTipoActuacion().getCodigo()); 
		}
		if (procedimiento.getTipoReclamacion()!=null) {
			setTipoReclamacion(procedimiento.getTipoReclamacion().getCodigo()); 
		}
		if (procedimiento.getEstadoProcedimiento()!=null) {
			setEstado(procedimiento.getEstadoProcedimiento().getCodigo());
		}
		setDecidido(procedimiento.getDecidido());
		setPorcentajeRecuperacion(procedimiento.getPorcentajeRecuperacion());
		setPlazoRecuperacion(procedimiento.getPlazoRecuperacion());
		setSaldoOriginalVencido(procedimiento.getSaldoOriginalVencido());
		setSaldoOriginalNoVencido(procedimiento.getSaldoOriginalNoVencido());
		setSaldoRecuperacion(procedimiento.getSaldoRecuperacion());
		setCodigoProcedimientoEnJuzgado(procedimiento.getCodigoProcedimientoEnJuzgado());
		if (procedimiento.getJuzgado()!=null) {
			setJuzgado(procedimiento.getJuzgado().getCodigo());
		}
		setFechaRecopilacion(procedimiento.getFechaRecopilacion());
		setObservacionesRecopilacion(procedimiento.getObservacionesRecopilacion());

		setEstaParalizado(procedimiento.isEstaParalizado());
		setFechaUltParalizacion(procedimiento.getFechaUltimaParalizacion());
		setPlazoParalizacion(procedimiento.getPlazoParalizacion());
		
		// PERSONAS relacionadas con el procedimiento codClienteEntidad
		List<Persona> personas = procedimiento.getPersonasAfectadas();
		for(Persona per : personas) {
			if (per.getAuditoria().isBorrado()) {
				continue;
			}
			data.addRelacion(RELACION_PERSONAS, per.getCodClienteEntidad().toString());
		}

		// CONTRATOS relacionadas con el procedimiento
		List<ProcedimientoContratoExpediente> prcCntExpList = procedimiento.getProcedimientosContratosExpedientes();
		for(ProcedimientoContratoExpediente prcCntExp : prcCntExpList) {
			if (prcCntExp.getExpedienteContrato().getAuditoria().isBorrado()) {
				continue;
			}
			data.addRelacion(RELACION_CONTRATOS_EXPEDIENTES, prcCntExp.getExpedienteContrato().getGuid());
		}
		
		// BIENES relacionadas con el procedimiento 
		List<ProcedimientoBien> prcBienes = procedimiento.getBienes();
		if (prcBienes!=null) {
			for(ProcedimientoBien prcBien : prcBienes) {
				NMBBien bien = NMBBien.instanceOf(prcBien.getBien());
				ProcedimientoBienPayload prbPayload = new ProcedimientoBienPayload(ProcedimientoBienPayload.KEY_PROCEDIMIENTOBIEN);
				prbPayload.setIdOrigen(prcBien.getId());
				prbPayload.setGuid(prcBien.getGuid());
				prbPayload.setCodigoInternoDelBien(bien.getCodigoInterno());
				prbPayload.setBorrado(bien.getAuditoria().isBorrado());
				if (prcBien.getSolvenciaGarantia()!=null) {
					prbPayload.setSolvenciaGarantia(prcBien.getSolvenciaGarantia().getCodigo());
				}
				addProcedimientoBien(prbPayload);
			}
		}
		
		Procedimiento procedimientoPadre = procedimiento.getProcedimientoPadre();
		if (procedimientoPadre!=null) {
			MEJProcedimiento mejProcedimientoPadre = MEJProcedimiento.instanceOf(procedimientoPadre);
			if (mejProcedimientoPadre==null) {
				throw new IntegrationClassCastException(MEJProcedimiento.class, procedimientoPadre.getClass(), String.format("No se puede recuperar SYS_GUID para el procedimiento padre %d.", procedimientoPadre.getId()));
			}
			data.addSourceId(KEY_PROCEDIMIENTO_PADRE, procedimientoPadre.getId());
			data.addCodigo(KEY_PROCEDIMIENTO_PADRE, procedimientoPadre.getTipoProcedimiento().getCodigo());
			setGuidProcedimientoPadre(mejProcedimientoPadre.getGuid());
		}
		
	}
	
	public void translate(DiccionarioDeCodigos diccionarioCodigos) {
		String valor;
		
		// P
		valor = getTipoProcedimiento();
		valor = diccionarioCodigos.getCodigoProcedimientoFinal(valor);
		this.setTipoProcedimiento(valor);
	
		// PP
		valor = getTipoProcedimientoPadre();
		valor = diccionarioCodigos.getCodigoProcedimientoFinal(valor);
		setTipoProcedimientoPadre(valor);
	}

	public void setIdOrigen(Long id) {
		data.addSourceId(KEY_PROCEDIMIENTO, id);
	}
	
	public Long getIdOrigen() {
		return data.getIdOrigen(KEY_PROCEDIMIENTO);
	}

	public Long getIdOrigenProcedimientoPadre() {
		return data.getIdOrigen(KEY_PROCEDIMIENTO_PADRE);
	}

	public String getTipoProcedimiento() {
		return data.getCodigo(KEY_PROCEDIMIENTO);
	}

	public void setTipoProcedimiento(String valor) {
		data.addCodigo(KEY_PROCEDIMIENTO, valor);
	}

	public String getTipoActuacion() {
		return data.getCodigo(CAMPO_TIPO_ACTUACION);
	}

	public void setTipoActuacion(String valor) {
		data.addCodigo(CAMPO_TIPO_ACTUACION, valor);
	}
	
	public String getTipoProcedimientoPadre() {
		return data.getCodigo(KEY_PROCEDIMIENTO_PADRE);
	}

	public void setTipoProcedimientoPadre(String valor) {
		data.addCodigo(KEY_PROCEDIMIENTO_PADRE, valor);
	}
	
	public void setGuid(String guid) {
		data.addGuid(KEY_PROCEDIMIENTO, guid);
	}
	public String getGuid() {
		return data.getGuid(KEY_PROCEDIMIENTO);
	}

	public void setGuidProcedimientoPadre(String guid) {
		data.addGuid(KEY_PROCEDIMIENTO_PADRE, guid);
	}
	
	public String getGuidProcedimientoPadre() {
		return data.getGuid(KEY_PROCEDIMIENTO_PADRE);
	}

	public void setDecidido(Boolean decidido) {
		data.addFlag(CAMPO_DECIDIDO, decidido);
	}
	
	public Boolean getDecidido() {
		return data.getFlag(CAMPO_DECIDIDO);
	}

	public void setFechaRecopilacion(Date fecha) {
		data.addFecha(CAMPO_FECHA_RECOPILACION, fecha);
	}
	
	public Date getFechaRecopilacion() {
		return data.getFecha(CAMPO_FECHA_RECOPILACION);
	}

	public void setTipoReclamacion(String tipo) {
		data.addCodigo(CAMPO_TIPO_RECLAMACION, tipo);
	}
	
	public String getTipoReclamacion() {
		 return data.getCodigo(CAMPO_TIPO_RECLAMACION);
	}

	public void setEstado(String estado) {
		data.addCodigo(CAMPO_ESTADO, estado);
	}
	
	public String getEstado() {
		return data.getCodigo(CAMPO_ESTADO);		
	}

	public void setJuzgado(String juzgado) {
		data.addCodigo(CAMPO_JUZGADO, juzgado);
	}

	public String getJuzgado() {
		return data.getCodigo(CAMPO_JUZGADO);		
	}

	public void setCodigoProcedimientoEnJuzgado(String codProcEnJuzgado) {
		data.addExtraInfo(CAMPO_COD_PROC_EN_JUZGADO, codProcEnJuzgado);
	}

	public String getCodigoProcedimientoEnJuzgado() {
		return data.getExtraInfo(CAMPO_COD_PROC_EN_JUZGADO);
	}

	public void setObservacionesRecopilacion(String valor) {
		data.addExtraInfo(CAMPO_OBSERVACIONES, valor);
	}

	public String getObservacionesRecopilacion() {
		return data.getExtraInfo(CAMPO_OBSERVACIONES);
	}

	public void setPlazoRecuperacion(Integer valor) {
		data.addNumber(CAMPO_PLAZO_RECUPERACION, valor);
	}

	public Integer getPlazoRecuperacion() {
		return data.getValInt(CAMPO_PLAZO_RECUPERACION);
	}

	public void setPorcentajeRecuperacion(Integer valor) {
		data.addNumber(CAMPO_PORCENTAJE_RECUPERACION, valor);
	}

	public Integer getPorcentajeRecuperacion() {
		return data.getValInt(CAMPO_PORCENTAJE_RECUPERACION);
	}

	public void setSaldoOriginalNoVencido(BigDecimal valor) {
		data.addNumber(CAMPO_SALDO_ORIG_NO_VENCIDO, valor);
	}

	public BigDecimal getSaldoOriginalNoVencido() {
		return data.getValBDec(CAMPO_SALDO_ORIG_NO_VENCIDO);
	}

	public void setSaldoOriginalVencido(BigDecimal valor) {
		data.addNumber(CAMPO_SALDO_ORIG_VENCIDO, valor);
	}

	public BigDecimal getSaldoOriginalVencido() {
		return data.getValBDec(CAMPO_SALDO_ORIG_VENCIDO);
	}

	public void setSaldoRecuperacion(BigDecimal valor) {
		data.addNumber(CAMPO_SALDO_RECUPERACION, valor);
	}

	public BigDecimal getSaldoRecuperacion() {
		return data.getValBDec(CAMPO_SALDO_RECUPERACION);
	}

	private void addProcedimientoBien(ProcedimientoBienPayload valor) {
		this.data.addChildren(ProcedimientoBienPayload.KEY_PROCEDIMIENTOBIEN, valor.getData());
	}
	
	public List<ProcedimientoBienPayload> getProcedimientoBien() {
		List<ProcedimientoBienPayload> listado = new ArrayList<ProcedimientoBienPayload>();
		if (data.getChildren()==null ||
				!data.getChildren().containsKey(ProcedimientoBienPayload.KEY_PROCEDIMIENTOBIEN)) {
			return listado;
		}
		List<DataContainerPayload> dataList = data.getChildren(ProcedimientoBienPayload.KEY_PROCEDIMIENTOBIEN);
		for (DataContainerPayload child : dataList) {
			ProcedimientoBienPayload container = new ProcedimientoBienPayload(child);
			listado.add(container);
		}
		return listado;
	}
	
	public List<String> getGuidContratos() {
		return data.getRelaciones(RELACION_CONTRATOS_EXPEDIENTES);
	}

	public List<String> getGuidPersonas() {
		return data.getRelaciones(RELACION_PERSONAS);
	}

	public String getTransicionBPM() {
		return data.getExtraInfo(JBPM_TRANSICION);
	}

	public String getTareaOrigenDelBPM() {
		return data.getExtraInfo(JBPM_TAR_GUID_ORIGEN);
	}

	public Boolean getEstaParalizado() {
		return data.getFlag(CAMPO_ESTA_PARALIZADO);
	}

	public void setEstaParalizado(Boolean paralizado) {
		data.addFlag(CAMPO_ESTA_PARALIZADO, paralizado);
	}

	public Date getFechaUltParalizacion() {
		return data.getFecha(CAMPO_ESTA_FECHA_ULT_PARALIZACION);
	}

	public void setFechaUltParalizacion(Date valor) {
		data.addFecha(CAMPO_ESTA_FECHA_ULT_PARALIZACION, valor);
	}
	
	public Long getPlazoParalizacion() {
		return data.getValLong(CAMPO_PLAZO_PARALIZACION);
	}

	public void setPlazoParalizacion(Long valor) {
		data.addNumber(CAMPO_PLAZO_PARALIZACION, valor);
	}
	
}
