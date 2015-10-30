package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class DecisionProcedimientoPayload {
	
	public static final String KEY = "@dpr";
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);
	private static final String CAMPO_FINALIZADA = String.format("%s.finalizada", KEY);
	private static final String CAMPO_PARALIZADA = String.format("%s.paralizada", KEY);
	private static final String CAMPO_CAUSA_DECISION = String.format("%s.causaDecision", KEY);
	private static final String CAMPO_CAUSA_DECISION_FINALIZAR = String.format("%s.causaDecisionFinalizar", KEY);
	private static final String CAMPO_CAUSA_DECISION_PARALIZAR = String.format("%s.causaDecisionParalizar", KEY);
	private static final String CAMPO_ENTIDAD = String.format("%s.entidad", KEY);
	private static final String CAMPO_FECHA_PARALIZACION = String.format("%s.fechaParalizacion", KEY);
	private static final String CAMPO_COMENTARIOS = String.format("%s.comentarios", KEY);
	private static final String CAMPO_ESTADO_DECISION =  String.format("%s.estadoDecision", KEY);

	private final DataContainerPayload data;
	private final ProcedimientoPayload procedimiento;
	
	@Autowired
	private UsuarioManager usuarioManager;

	public DecisionProcedimientoPayload(DataContainerPayload data) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data);
	}
	
	public DecisionProcedimientoPayload(String tipo) {
		this(new DataContainerPayload(null, null));
	}
	
	public DecisionProcedimientoPayload(DataContainerPayload data, DecisionProcedimiento decisionProcedimiento) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data, decisionProcedimiento.getProcedimiento());
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

	private void setCausaDecision(String codigo) {
		data.addCodigo(CAMPO_CAUSA_DECISION, codigo);	
	}

	public String getCausaDecision() {
		return data.getCodigo(CAMPO_CAUSA_DECISION);
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
	
	private void setEntidad(String entidad) {
		data.addExtraInfo(CAMPO_ENTIDAD, entidad);	
	}

	public String getEntidad() {
		return data.getExtraInfo(CAMPO_ENTIDAD);
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

	public void setBorrado(boolean borrado) {
		data.addFlag(CAMPO_BORRADO, borrado);
	}
	
	public boolean getBorrado() {
		return data.getFlag(CAMPO_BORRADO);
	}	
	
	public void build(DecisionProcedimiento decisionProcedimiento) {

		setGuid(decisionProcedimiento.getGuid());
		setId(decisionProcedimiento.getId());
		
		setFinalizada(decisionProcedimiento.getFinalizada());
		setParalizada(decisionProcedimiento.getParalizada());
		
		if(decisionProcedimiento.getCausaDecision() != null) {
			setCausaDecision(decisionProcedimiento.getCausaDecision().getCodigo());
		}
		else {
			setCausaDecision("");
		}
		
		if(decisionProcedimiento.getCausaDecisionFinalizar() != null) {
			setCausaDecisionFinalizar(decisionProcedimiento.getCausaDecisionFinalizar().getCodigo());
		}
		else {
			setCausaDecisionFinalizar("");
		}
		
		if(decisionProcedimiento.getCausaDecisionParalizar() != null) {
			setCausaDecisionParalizar(decisionProcedimiento.getCausaDecisionParalizar().getCodigo());
		}
		else {
			setCausaDecisionParalizar("");
		}
		
		if(decisionProcedimiento.getEstadoDecision() != null) {
			setEstadoDecision(decisionProcedimiento.getEstadoDecision().getCodigo());
		}
		else {
			setEstadoDecision("");
		}
		
		setFechaParalizacion(decisionProcedimiento.getFechaParalizacion());
		setComentarios(decisionProcedimiento.getComentarios());
		
		// La entidad desde la que se toma la decisión solo se envía por mensaje. En la misma entidad el valor del campo es nulo.
		Usuario usuario = usuarioManager.getUsuarioLogado();
		setEntidad(usuario.getEntidad().getDescripcion());
		
		setBorrado(decisionProcedimiento.getAuditoria().isBorrado());
		
		List<ProcedimientoDerivado> procedimientoDerivados = decisionProcedimiento.getProcedimientosDerivados();
		if (procedimientoDerivados != null) {
			for(ProcedimientoDerivado procedimientoDerivado : procedimientoDerivados) {
				
				ProcedimientoDerivadoPayload derivadoPayload = new ProcedimientoDerivadoPayload(ProcedimientoDerivadoPayload.KEY);
				derivadoPayload.build(procedimientoDerivado);

				addProcedimientoDerivado(derivadoPayload);
			}
		}
	}

}
