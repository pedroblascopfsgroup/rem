package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;


public class CoreProjectContextImpl implements CoreProjectContext {
	
	private Map<String, Set<String>> categoriasSubTareas;
	private List<String> tiposPrcAdjudicados;
	private Set<String> tiposGestorGestoria;
	private Set<String> tiposGestorProcurador;
	private Set<String> entidadesDesparalizacion;
	private List<String> codigosDocumentosConFechaCaducidad;
	private Set<String> tipoGestorLetrado;
	private Map<String, String> tipoSupervisorProrroga;
	private Set<String> tiposGestoresDeProcuradores;
	private Set<String> perfilesConsulta;
	
	public CoreProjectContextImpl() {
		entidadesDesparalizacion = new HashSet<String>();
	}

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

	@Override
	public Set<String> getEntidadesDesparalizacion() {
		return entidadesDesparalizacion;
	}

	public void setEntidadesDesparalizacion(Set<String> entidadesDesparalizacion) {
		this.entidadesDesparalizacion = entidadesDesparalizacion;
	}

	@Override
	public List<String> getCodigosDocumentosConFechaCaducidad() 
	{		
		return this.codigosDocumentosConFechaCaducidad;
	}
	
	public void setCodigosDocumentosConFechaCaducidad(List<String> codigosDocumentosConFechaCaducidad) 
	{
		this.codigosDocumentosConFechaCaducidad = codigosDocumentosConFechaCaducidad;
	}

	public Set<String> getTipoGestorLetrado() {
		return tipoGestorLetrado;
	}

	public void setTipoGestorLetrado(Set<String> tipoGestorLetrado) {
		this.tipoGestorLetrado = tipoGestorLetrado;
	}

	@Override
	public Map<String, String> getTipoSupervisorProrroga() {
		return this.tipoSupervisorProrroga;
	}
	
	public void setTipoSupervisorProrroga(Map<String, String>tipoSupervisorProrroga) {
		this.tipoSupervisorProrroga = tipoSupervisorProrroga;
	}

	public Set<String> getTiposGestoresDeProcuradores() {
		return tiposGestoresDeProcuradores;
	}

	public void setTiposGestoresDeProcuradores(Set<String> tiposGestoresDeProcuradores) {
		this.tiposGestoresDeProcuradores = tiposGestoresDeProcuradores;
	}

	/**
	 * @return the perfilesConsulta
	 */
	@Override
	public Set<String> getPerfilesConsulta() {
		return perfilesConsulta;
	}

	/**
	 * @param perfilesConsulta the perfilesConsulta to set
	 */
	public void setPerfilesConsulta(Set<String> perfilesConsulta) {
		this.perfilesConsulta = perfilesConsulta;
	}
}
