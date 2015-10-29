package es.pfsgroup.recovery.integration.bpm.payload;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public class ProcedimientoDerivadoPayload {
	
	public static final String KEY = "@prd";
	private static final String CAMPO_GUID_DECISION_PROCEDIMIENTO = String.format("%s.dpr_guid", KEY);
	private static final String CAMPO_PERSONAS = String.format("%s.personas", KEY);
	private static final String CAMPO_GUID_PROCEDIMIENTO_PADRE = String.format("%s.procedimientoPadre", KEY);
	private static final String CAMPO_TIPO_ACTUACION = String.format("%s.tipoActuacion", KEY);
	private static final String CAMPO_TIPO_RECLAMACION = String.format("%s.tipoReclamacion", KEY);
	private static final String CAMPO_TIPO_PROCEDIMIENTO = String.format("%s.tipoProcedimiento", KEY);
	private static final String CAMPO_PORCENTAJE_RECUPERACION = String.format("%s.porcentajeRecuperacion", KEY);
	private static final String CAMPO_PLAZO_RECUPERACION = String.format("%s.plazoRecuperacion", KEY);
	private static final String CAMPO_SALDO_RECUPERACION = String.format("%s.saldoRecuperacion", KEY);
	
	private final DataContainerPayload data;
	private final ProcedimientoPayload procedimiento;

	public ProcedimientoDerivadoPayload(DataContainerPayload data) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data);
	}
	
	public ProcedimientoDerivadoPayload(String tipo) {
		this(new DataContainerPayload(null, null));
	}
	
	public ProcedimientoDerivadoPayload(DataContainerPayload data, ProcedimientoDerivado procedimientoDerivado) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data, procedimientoDerivado.getProcedimiento());
	}
	
	public ProcedimientoPayload getProcedimiento() {
		return procedimiento;
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
	
	private void setPersonas(String guidPersona) {
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

	public void build(ProcedimientoDerivado procedimientoDerivado) {

		setGuid(procedimientoDerivado.getGuid());
		setId(procedimientoDerivado.getId());
		
		DecisionProcedimiento decisionProcedimiento = procedimientoDerivado.getDecisionProcedimiento();
		
		if (Checks.esNulo(decisionProcedimiento.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] La decisión de procedimiento ID: %d no tiene referencia de sincronización", decisionProcedimiento.getId()));
		}
		
		setGuidDecisionProcedimiento(decisionProcedimiento.getGuid());
		
		MEJProcedimiento procedimiento = (MEJProcedimiento) procedimientoDerivado.getProcedimiento();
		if(procedimiento != null && procedimiento.getProcedimientoPadre() != null) {
			setGuidProcedimientoPadre(((MEJProcedimiento)procedimiento.getProcedimientoPadre()).getGuid());
		}
		
		if(procedimiento != null && procedimiento.getPersonasAfectadas() != null) {
			List<Persona> personas = procedimiento.getPersonasAfectadas();
			for(Persona per : personas) {
				if (per.getAuditoria().isBorrado()) {
					continue;
				}
				
				setPersonas(per.getCodClienteEntidad().toString());
			}
		}
			
		if(procedimiento != null && procedimiento.getTipoActuacion() != null) {
			setTipoActuacion(procedimiento.getTipoActuacion().getCodigo());
		}
		
		if(procedimiento != null && procedimiento.getTipoReclamacion() != null) {
			setTipoReclamacion(procedimiento.getTipoReclamacion().getCodigo());
		}
		
		if(procedimiento != null && procedimiento.getTipoProcedimiento() != null) {
			setTipoProcedimiento(procedimiento.getTipoProcedimiento().getCodigo());
		}
		
		if(procedimiento != null) {
			setPorcentajeRecuperacion(procedimiento.getPorcentajeRecuperacion());
		}
		
		if(procedimiento != null) {
			setPlazoRecuperacion(procedimiento.getPlazoRecuperacion());
		}
		
		if(procedimiento != null) {
			setSaldoRecuperacion(procedimiento.getSaldoRecuperacion());
		}
	}
}
