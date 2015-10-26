package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.Map;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;


public class CoreProjectContextImpl implements CoreProjectContext {
	
	private Map<String, Set<String>> categoriasSubTareas;
	private List<String> tiposPrcAdjudicados;
	private Set<String> tiposGestorGestoria;
	private Set<String> tiposGestorProcurador;

	@Override
	public Map<String, Set<String>> getCategoriasSubTareas() {
		return categoriasSubTareas;
	}

	public void setCategoriasSubTareas(Map<String, Set<String>> categoriasSubTareas) {
		this.categoriasSubTareas = categoriasSubTareas;
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
	
	/**
	 * Devuelve los tipos de gestor que son gestoria
	 */
	@Override
	public Set<String> getTiposGestorGestoria() {
		return tiposGestorGestoria;
	}

	public void setTiposGestorGestoria(Set<String> tiposGestorGestoria) {
		this.tiposGestorGestoria = tiposGestorGestoria;
	}

	public List<String> getTiposPrcAdjudicados() {
		return tiposPrcAdjudicados;
	}

	public void setTiposPrcAdjudicados(List<String> tiposPrcAdjudicados) {
		this.tiposPrcAdjudicados = tiposPrcAdjudicados;
	}

	public Set<String> getTiposGestorProcurador() {
		return tiposGestorProcurador;
	}

	public void setTiposGestorProcurador(Set<String> tiposGestorProcurador) {
		this.tiposGestorProcurador = tiposGestorProcurador;
	}
	
	
}
