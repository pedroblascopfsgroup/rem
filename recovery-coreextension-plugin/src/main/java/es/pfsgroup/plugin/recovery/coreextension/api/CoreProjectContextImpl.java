package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.Map;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;


public class CoreProjectContextImpl implements CoreProjectContext {
	
	private Map<String, Set<String>> categoriasSubTareas;
	private List<String> tiposPrcAdjudicados;
	private List<String> tiposGestorGestoria;

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
	public List<String> getTiposGestorGestoria() {
		return tiposGestorGestoria;
	}

	public void setTiposGestorGestoria(List<String> tiposGestorGestoria) {
		this.tiposGestorGestoria = tiposGestorGestoria;
	}
	
	
	
}
