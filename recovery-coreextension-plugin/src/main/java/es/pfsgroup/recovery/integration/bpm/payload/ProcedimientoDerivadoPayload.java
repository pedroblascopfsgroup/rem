package es.pfsgroup.recovery.integration.bpm.payload;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class ProcedimientoDerivadoPayload {
	
	public static final String KEY = "@prd";
	private static final String CAMPO_GUID_DECISION_PROCEDIMIENTO = String.format("%s.dpr_guid", KEY);
	private static final String CAMPO_PERSONAS = String.format("%s.personas", KEY);
	private static final String CAMPO_GUID_PROCEDIMIENTO_PADRE = String.format("%s.procedimientoPadre", KEY);
	private static final String CAMPO_GUID_PROCEDIMIENTO_HIJO = String.format("%s.procedimientoHijo", KEY);
	private static final String CAMPO_TIPO_ACTUACION = String.format("%s.tipoActuacion", KEY);
	private static final String CAMPO_TIPO_RECLAMACION = String.format("%s.tipoReclamacion", KEY);
	private static final String CAMPO_TIPO_PROCEDIMIENTO = String.format("%s.tipoProcedimiento", KEY);
	private static final String CAMPO_PORCENTAJE_RECUPERACION = String.format("%s.porcentajeRecuperacion", KEY);
	private static final String CAMPO_PLAZO_RECUPERACION = String.format("%s.plazoRecuperacion", KEY);
	private static final String CAMPO_SALDO_RECUPERACION = String.format("%s.saldoRecuperacion", KEY);
	
	private final DataContainerPayload data;
	
	public ProcedimientoDerivadoPayload(DataContainerPayload data) {
		this.data = data;
	}
	
	public ProcedimientoDerivadoPayload(String tipo) {
		this(new DataContainerPayload(null, null));
	}
	
	public ProcedimientoDerivadoPayload(DataContainerPayload data, ProcedimientoDerivado procedimientoDerivado) {
		this.data = data;
	}
	
	public DataContainerPayload getData() {
		return data;
	}

	public Long getId() {
		return data.getIdOrigen(KEY);
	}
	
	public void setId(Long id) {
		data.addSourceId(KEY, id);
	}

	public String getGuid() {
		return data.getGuid(KEY);
	}
	
	public void setGuid(String guid) {
		data.addGuid(KEY, guid);
	}
	
	private void setGuidDecisionProcedimiento(String guidDecisionProcedimiento)
	{
		data.addGuid(CAMPO_GUID_DECISION_PROCEDIMIENTO, guidDecisionProcedimiento);
	}
	
	public String getGuidDecisionProcedimiento() 
	{
		return data.getGuid(CAMPO_GUID_DECISION_PROCEDIMIENTO);
	}
	
	private void setGuidProcedimientoPadre(String guidProcedimientoPadre) {
		data.addGuid(CAMPO_GUID_PROCEDIMIENTO_PADRE, guidProcedimientoPadre);		
	}

	public String getGuidProcedimientoPadre() {
		return data.getGuid(CAMPO_GUID_PROCEDIMIENTO_PADRE);		
	}
	
	public void setGuidProcedimientoHijo(String guidProcedimientoHijo) {
		data.addGuid(CAMPO_GUID_PROCEDIMIENTO_HIJO, guidProcedimientoHijo);		
	}

	public String getGuidProcedimientoHijo() {
		return data.getGuid(CAMPO_GUID_PROCEDIMIENTO_HIJO);
	}

	public void setPersonas(String guidPersona) {
		data.addRelacion(CAMPO_PERSONAS, guidPersona);		
	}

	public List<String> getPersonas() {
		return data.getRelaciones(CAMPO_PERSONAS);		
	}
	
	private void setTipoActuacion(String tipoActuacion) {
		data.addCodigo(CAMPO_TIPO_ACTUACION, tipoActuacion);	
	}

	public String getTipoActuacion() {
		return data.getCodigo(CAMPO_TIPO_ACTUACION);
	}

	private void setTipoReclamacion(String tipoReclamacion) {
		data.addCodigo(CAMPO_TIPO_RECLAMACION, tipoReclamacion);	
	}

	public String getTipoReclamacion() {
		return data.getCodigo(CAMPO_TIPO_RECLAMACION);
	}
	
	private void setTipoProcedimiento(String tipoProcedimiento) {
		data.addCodigo(CAMPO_TIPO_PROCEDIMIENTO, tipoProcedimiento);	
	}

	public String getTipoProcedimiento() {
		return data.getCodigo(CAMPO_TIPO_PROCEDIMIENTO);
	}

	private void setPorcentajeRecuperacion(Integer porcentajeRecuperacion) {
		data.addNumber(CAMPO_PORCENTAJE_RECUPERACION, porcentajeRecuperacion);	
	}

	public Integer getPorcentajeRecuperacion() {
		return data.getValInt(CAMPO_PORCENTAJE_RECUPERACION);
	}

	private void setPlazoRecuperacion(Integer plazoRecuperacion) {
		data.addNumber(CAMPO_PLAZO_RECUPERACION, plazoRecuperacion);	
	}

	public Integer getPlazoRecuperacion() {
		return data.getValInt(CAMPO_PLAZO_RECUPERACION);
	}

	private void setSaldoRecuperacion(BigDecimal saldoRecuperacion) {
		data.addNumber(CAMPO_SALDO_RECUPERACION, saldoRecuperacion);	
	}

	public BigDecimal getSaldoRecuperacion() {
		return data.getValBDec(CAMPO_SALDO_RECUPERACION);
	}

	public void build(DtoProcedimientoDerivado dtoProcedimientoDerivado, MEJDtoDecisionProcedimiento dtoDecisionProcedimiento, ProcedimientoPayload procedimiento) {

		setGuid(dtoProcedimientoDerivado.getGuid());
		setId(dtoProcedimientoDerivado.getId());
		
		if(dtoDecisionProcedimiento.getDecisionProcedimiento() != null) {
			setGuidDecisionProcedimiento(dtoDecisionProcedimiento.getDecisionProcedimiento().getGuid());
			
			if(dtoProcedimientoDerivado.getProcedimientoDerivado() != null) {
				setGuidProcedimientoHijo(dtoProcedimientoDerivado.getProcedimientoDerivado().getProcedimiento().getId().toString());
			}
			
			setGuidProcedimientoPadre(procedimiento.getGuid());
		}
		
		if(dtoProcedimientoDerivado.getPersonas() != null) {
			Long[] personas = dtoProcedimientoDerivado.getPersonas();
			for(Long idPer : personas) {
				if(idPer != 0) {
					setPersonas(idPer.toString());
				}
			}
		}
			
		setTipoActuacion(dtoProcedimientoDerivado.getTipoActuacion());
		setTipoReclamacion(dtoProcedimientoDerivado.getTipoReclamacion());
		setTipoProcedimiento(dtoProcedimientoDerivado.getTipoProcedimiento());
		setPorcentajeRecuperacion(dtoProcedimientoDerivado.getPorcentajeRecuperacion());
		setPlazoRecuperacion(dtoProcedimientoDerivado.getPlazoRecuperacion());
		setSaldoRecuperacion(dtoProcedimientoDerivado.getSaldoRecuperacion());
	}
}
