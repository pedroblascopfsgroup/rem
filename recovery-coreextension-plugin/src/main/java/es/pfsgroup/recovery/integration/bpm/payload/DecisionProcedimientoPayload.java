package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class DecisionProcedimientoPayload {
	
	public static final String KEY = "@dpr";
	private static final String CAMPO_FINALIZADA = String.format("%s.finalizada", KEY);
	private static final String CAMPO_PARALIZADA = String.format("%s.paralizada", KEY);
	private static final String CAMPO_CAUSA_DECISION_FINALIZAR = String.format("%s.causaDecisionFinalizar", KEY);
	private static final String CAMPO_CAUSA_DECISION_PARALIZAR = String.format("%s.causaDecisionParalizar", KEY);
	private static final String CAMPO_FECHA_PARALIZACION = String.format("%s.fechaParalizacion", KEY);
	private static final String CAMPO_COMENTARIOS = String.format("%s.comentarios", KEY);
	private static final String CAMPO_ESTADO_DECISION =  String.format("%s.estadoDecision", KEY);

	private final DataContainerPayload data;
	private final ProcedimientoPayload procedimiento;
	
	public DecisionProcedimientoPayload(DataContainerPayload data) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data);
	}
	
	public DecisionProcedimientoPayload(String tipo) {
		this(new DataContainerPayload(null, null));
	}
	
	public DecisionProcedimientoPayload(DataContainerPayload data, Procedimiento procedimiento) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data, procedimiento);
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
	
	private void setFinalizada(Boolean finalizada) {
		data.addFlag(CAMPO_FINALIZADA, finalizada);
	}
	
	public Boolean getFinalizada() {
		return data.getFlag(CAMPO_FINALIZADA);
	}

	private void setParalizada(Boolean paralizada) {
		data.addFlag(CAMPO_PARALIZADA, paralizada);
	}
	
	public Boolean getParalizada() {
		return data.getFlag(CAMPO_PARALIZADA);
	}

	private void setCausaDecisionFinalizar(String codigo) {
		data.addCodigo(CAMPO_CAUSA_DECISION_FINALIZAR, codigo);	
	}

	public String getCausaDecisionFinalizar() {
		return data.getCodigo(CAMPO_CAUSA_DECISION_FINALIZAR);
	}

	private void setCausaDecisionParalizar(String codigo) {
		data.addCodigo(CAMPO_CAUSA_DECISION_PARALIZAR, codigo);	
	}

	public String getCausaDecisionParalizar() {
		return data.getCodigo(CAMPO_CAUSA_DECISION_PARALIZAR);
	}
	
	public String getEntidad() {
		return data.getEntidad();
	}
	
	private void setFechaParalizacion(Date fechaParalizacion) {
		data.addFecha(CAMPO_FECHA_PARALIZACION, fechaParalizacion);	
	}

	public Date getFechaParalizacion() {
		return data.getFecha(CAMPO_FECHA_PARALIZACION);
	}
	
	private void setComentarios(String comentarios) {
		data.addExtraInfo(CAMPO_COMENTARIOS, comentarios);	
	}

	public String getComentarios() {
		return data.getExtraInfo(CAMPO_COMENTARIOS);
	}
	
	public String getEstadoDecision() {
		return data.getCodigo(CAMPO_ESTADO_DECISION);
	}
	
	private void setEstadoDecision(String estadoDecision) {
		data.addCodigo(CAMPO_ESTADO_DECISION, estadoDecision);	
	}
	
	private void addProcedimientoDerivado(ProcedimientoDerivadoPayload valor) 
	{
		this.data.addChildren(ProcedimientoDerivadoPayload.KEY, valor.getData());
	}
	
	public List<ProcedimientoDerivadoPayload> getProcedimientoDerivado() 
	{
		if (data.getChildren() == null || !data.getChildren().containsKey(ProcedimientoDerivadoPayload.KEY)) {
			return null;
		}
		
		List<ProcedimientoDerivadoPayload> listado = new ArrayList<ProcedimientoDerivadoPayload>();
		List<DataContainerPayload> dataList = data.getChildren(ProcedimientoDerivadoPayload.KEY);
		for (DataContainerPayload child : dataList) {
			ProcedimientoDerivadoPayload container = new ProcedimientoDerivadoPayload(child);
			listado.add(container);
		}
		
		return listado;
	}

	public void build(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {

		if(dtoDecisionProcedimiento.getDecisionProcedimiento() != null) {
			setGuid(dtoDecisionProcedimiento.getDecisionProcedimiento().getGuid());
			setId(dtoDecisionProcedimiento.getDecisionProcedimiento().getId());
		}
		
		setFinalizada(dtoDecisionProcedimiento.getFinalizar());
		setParalizada(dtoDecisionProcedimiento.getParalizar());
		
		if(dtoDecisionProcedimiento.getCausaDecisionFinalizar() != null) {
			setCausaDecisionFinalizar(dtoDecisionProcedimiento.getCausaDecisionFinalizar());
		}
		else {
			setCausaDecisionFinalizar("");
		}
		
		if(dtoDecisionProcedimiento.getCausaDecisionParalizar() != null) {
			setCausaDecisionParalizar(dtoDecisionProcedimiento.getCausaDecisionParalizar());
		}
		else {
			setCausaDecisionParalizar("");
		}
		
		if(dtoDecisionProcedimiento.getStrEstadoDecision() != null) {
			setEstadoDecision(dtoDecisionProcedimiento.getStrEstadoDecision());
		}
		else {
			setEstadoDecision("");
		}
		
		setFechaParalizacion(dtoDecisionProcedimiento.getFechaParalizacion());
		setComentarios(dtoDecisionProcedimiento.getComentarios());
		
		List<DtoProcedimientoDerivado> procedimientoDerivados = dtoDecisionProcedimiento.getProcedimientosDerivados();
		if (procedimientoDerivados != null) {
			for(DtoProcedimientoDerivado dtoProcedimientoDerivado : procedimientoDerivados) {
				
				ProcedimientoDerivadoPayload derivadoPayload = new ProcedimientoDerivadoPayload(ProcedimientoDerivadoPayload.KEY);
				derivadoPayload.build(dtoProcedimientoDerivado, dtoDecisionProcedimiento, procedimiento);

				addProcedimientoDerivado(derivadoPayload);
			}
		}
	}

}
