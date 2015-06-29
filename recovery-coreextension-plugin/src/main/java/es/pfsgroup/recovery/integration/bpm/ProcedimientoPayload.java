package es.pfsgroup.recovery.integration.bpm;

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

public class ProcedimientoPayload {
	
	public static final String JBPM_TRANSICION = "transicion";
	public static final String JBPM_TAR_GUID_ORIGEN = "tar-guid-origen";
	
	
	public final static String KEY_PROCEDIMIENTO = "@prc";
	public final static String KEY_PROCEDIMIENTO_PADRE = "@prc.padre";

	private final DataContainerPayload data;
	private final AsuntoPayload asunto;

	public ProcedimientoPayload(DataContainerPayload data) {
		this.data = data;
		this.asunto = new AsuntoPayload(data);
	}
	
	public ProcedimientoPayload(String tipo, Procedimiento procedimiento) {
		this(new DataContainerPayload(tipo), procedimiento);
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
		
		data.addSourceId(KEY_PROCEDIMIENTO, procedimiento.getId());
		setTipoProcedimiento(procedimiento.getTipoProcedimiento().getCodigo());
		data.addGuid(KEY_PROCEDIMIENTO, procedimiento.getGuid());
		if (procedimiento.getTipoActuacion()!=null) {
			data.addCodigo(String.format("%s.tipoActuacion", KEY_PROCEDIMIENTO), procedimiento.getTipoActuacion().getCodigo()); 
		}
		if (procedimiento.getTipoReclamacion()!=null) {
			data.addCodigo(String.format("%s.tipoReclamacion", KEY_PROCEDIMIENTO), procedimiento.getTipoReclamacion().getCodigo()); 
		}
		if (procedimiento.getEstadoProcedimiento()!=null) {
			data.addCodigo(String.format("%s.estado", KEY_PROCEDIMIENTO), procedimiento.getEstadoProcedimiento().getCodigo());
		}
		data.addFlag(String.format("%s.decidido", KEY_PROCEDIMIENTO), procedimiento.getDecidido());
		data.addNumber(String.format("%s.porcentajeRecuperacion", KEY_PROCEDIMIENTO), procedimiento.getPorcentajeRecuperacion());
		data.addNumber(String.format("%s.plazoRecuperacion", KEY_PROCEDIMIENTO), procedimiento.getPlazoRecuperacion());
		data.addNumber(String.format("%s.saldoOriginalVencido", KEY_PROCEDIMIENTO), procedimiento.getSaldoOriginalVencido());
		data.addNumber(String.format("%s.saldoOriginalNoVencido", KEY_PROCEDIMIENTO), procedimiento.getSaldoOriginalNoVencido());
		data.addNumber(String.format("%s.saldoRecuperacion", KEY_PROCEDIMIENTO), procedimiento.getSaldoRecuperacion());
		data.addExtraInfo(String.format("%s.codProcEnJuzgado", KEY_PROCEDIMIENTO), procedimiento.getCodigoProcedimientoEnJuzgado());
		if (procedimiento.getJuzgado()!=null) {
			data.addCodigo(String.format("%s.juzgado", KEY_PROCEDIMIENTO), procedimiento.getJuzgado().getCodigo());
		}
		data.addFecha(String.format("%s.recopilacion", KEY_PROCEDIMIENTO), procedimiento.getFechaRecopilacion());
		data.addExtraInfo(String.format("%s.observaciones", KEY_PROCEDIMIENTO), procedimiento.getObservacionesRecopilacion());

		// PERSONAS relacionadas con el procedimiento codClienteEntidad
		List<Persona> personas = procedimiento.getPersonasAfectadas();
		for(Persona per : personas) {
			if (per.getAuditoria().isBorrado()) {
				continue;
			}
			data.addRelacion(String.format("%s.per", KEY_PROCEDIMIENTO), per.getCodClienteEntidad().toString());
		}

		// CONTRATOS relacionadas con el procedimiento
		List<ProcedimientoContratoExpediente> prcCntExpList = procedimiento.getProcedimientosContratosExpedientes();
		for(ProcedimientoContratoExpediente prcCntExp : prcCntExpList) {
			if (prcCntExp.getExpedienteContrato().getAuditoria().isBorrado()) {
				continue;
			}
			data.addRelacion(String.format("%s.cex", KEY_PROCEDIMIENTO), prcCntExp.getExpedienteContrato().getGuid());
		}
		
		// BIENES relacionadas con el procedimiento 
		List<ProcedimientoBien> prcBienes = procedimiento.getBienes();
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
		
		Procedimiento procedimientoPadre = procedimiento.getProcedimientoPadre();
		if (procedimientoPadre!=null) {
			MEJProcedimiento mejProcedimientoPadre = MEJProcedimiento.instanceOf(procedimientoPadre);
			if (mejProcedimientoPadre==null) {
				throw new IntegrationClassCastException(MEJProcedimiento.class, procedimientoPadre.getClass(), String.format("No se puede recuperar SYS_GUID para el procedimiento padre %d.", procedimientoPadre.getId()));
			}
			data.addSourceId(KEY_PROCEDIMIENTO_PADRE, procedimientoPadre.getId());
			data.addCodigo(KEY_PROCEDIMIENTO_PADRE, procedimientoPadre.getTipoProcedimiento().getCodigo());
			data.addGuid(KEY_PROCEDIMIENTO_PADRE, mejProcedimientoPadre.getGuid());
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
	
	public String getTipoProcedimientoPadre() {
		return data.getCodigo(KEY_PROCEDIMIENTO_PADRE);
	}

	public void setTipoProcedimientoPadre(String valor) {
		data.addCodigo(KEY_PROCEDIMIENTO_PADRE, valor);
	}
	
	public String getGuid() {
		return data.getGuid(KEY_PROCEDIMIENTO);
	}

	public String getGuidProcedimientoPadre() {
		return data.getGuid(KEY_PROCEDIMIENTO_PADRE);
	}

	public Boolean getDecidido() {
		return data.getFlag(String.format("%s.decidido", KEY_PROCEDIMIENTO));
	}

	public Date getFechaRecopilacion() {
		return data.getFecha(String.format("%s.recopilacion", KEY_PROCEDIMIENTO));
	}

	public String getTipoReclamacion() {
		 return data.getCodigo(String.format("%s.tipoReclamacion", KEY_PROCEDIMIENTO));
	}

	public String getEstado() {
		return data.getCodigo(String.format("%s.estado", KEY_PROCEDIMIENTO));		
	}

	public String getJuzgado() {
		return data.getCodigo(String.format("%s.juzgado", KEY_PROCEDIMIENTO));		
	}

	public String getCodigoProcedimientoEnJuzgado() {
		return data.getExtraInfo(String.format("%s.codProcEnJuzgado", KEY_PROCEDIMIENTO));
	}

	public String getObservacionesRecopilacion() {
		return data.getExtraInfo(String.format("%s.observaciones", KEY_PROCEDIMIENTO));
	}

	public Integer getPlazoRecuperacion() {
		return data.getValInt(String.format("%s.plazoRecuperacion", KEY_PROCEDIMIENTO));
	}

	public Integer getPorcentajeRecuperacion() {
		return data.getValInt(String.format("%s.porcentajeRecuperacion", KEY_PROCEDIMIENTO));
	}

	public BigDecimal getSaldoOriginalNoVencido() {
		return data.getValBDec(String.format("%s.saldoOriginalNoVencido", KEY_PROCEDIMIENTO));
	}

	public BigDecimal getSaldoOriginalVencido() {
		return data.getValBDec(String.format("%s.saldoOriginalVencido", KEY_PROCEDIMIENTO));
	}

	public BigDecimal getSaldoRecuperacion() {
		return data.getValBDec(String.format("%s.saldoRecuperacion", KEY_PROCEDIMIENTO));
	}

	private void addProcedimientoBien(ProcedimientoBienPayload valor) {
		this.data.addChildren(ProcedimientoBienPayload.KEY_PROCEDIMIENTOBIEN, valor.getData());
	}
	
	public List<ProcedimientoBienPayload> getProcedimientoBien() {
		List<ProcedimientoBienPayload> listado = new ArrayList<ProcedimientoBienPayload>();
		if (!data.getChildren().containsKey(ProcedimientoBienPayload.KEY_PROCEDIMIENTOBIEN)) {
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
		return data.getRelaciones(String.format("%s.cex", KEY_PROCEDIMIENTO));
	}

	public List<String> getGuidPersonas() {
		return data.getRelaciones(String.format("%s.per", KEY_PROCEDIMIENTO));
	}

	public String getTransicionBPM() {
		return data.getExtraInfo(JBPM_TRANSICION);
	}

	public String getTareaOrigenDelBPM() {
		return data.getExtraInfo(JBPM_TAR_GUID_ORIGEN);
	}
	
}
