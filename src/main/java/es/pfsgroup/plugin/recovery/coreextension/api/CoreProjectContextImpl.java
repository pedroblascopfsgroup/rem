package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;


public class CoreProjectContextImpl implements CoreProjectContext {
	
	private Set<String> tareasTipoDecision;
	private List<String> tiposPrcAdjudicados;
	
	
	@Override
	public Set<String> getTareasTipoDecision() {
		return this.tareasTipoDecision;
	}

	public void setTareasTipoDecision(Set<String> tareasTipoDecision) {
		this.tareasTipoDecision = tareasTipoDecision;
	}
	
	/**
	 * Devuelve los tipos de procedimientos que son de adjudicados
	 */
	@Override
	public List<String> getTiposProcedimientosAdjudicados() {
		return tiposPrcAdjudicados;
	}

	public void setTiposProcedimientosAdjudicados(List<String> tiposPrcAdjudicados) {
		this.tiposPrcAdjudicados = tiposPrcAdjudicados;
	}
	
}
