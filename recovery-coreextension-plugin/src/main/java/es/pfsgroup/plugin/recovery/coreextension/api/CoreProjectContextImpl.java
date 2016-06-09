package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;


public class CoreProjectContextImpl implements CoreProjectContext {
	
	private Map<String, Set<String>> categoriasSubTareas;
	private List<String> tiposPrcAdjudicados;
	private Set<String> tiposGestorGestoria;
	private Set<String> tiposGestorProcurador;
	private Set<String> tiposGestorCentroProcura;
	private Set<String> entidadesDesparalizacion;
	private List<String> codigosDocumentosConFechaCaducidad;
	private Set<String> tipoGestorLetrado;
	private Map<String, String> tipoSupervisorProrroga;
	private Set<String> tiposGestoresDeProcuradores;
	private Set<String> perfilesConsulta;
	private HashMap<String, HashMap<String, Set<String>>> tiposAsuntosTiposGestores;
	private HashMap<String, HashMap<String, Set<String>>> perfilesGestoresEspeciales;
	private HashMap<String, HashMap<String, Set<String>>> supervisorAsunto;
	private HashMap<String, HashMap<String, Set<String>>> despachoSupervisorAsunto;
	private HashMap<String, HashMap<String, Set<String>>> tipoGestorSupervisorAsunto;
	private Map<String, List<String>> despachosProcuradores;
	private Map<String, String> mapaContratoVigor;
	private Map<String, String> mapaClasificacionDespachoPerfil;
	private Map<String, String> mapaRelacionBankia;
	private Map<String, String> mapaDescripcionIVA;
	private Map<String, String> mapaCodEstAse;
	
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

	public HashMap<String, HashMap<String, Set<String>>> getTiposAsuntosTiposGestores() {
		return tiposAsuntosTiposGestores;
	}

	public void setTiposAsuntosTiposGestores(
			HashMap<String, HashMap<String, Set<String>>> tiposAsuntosTiposGestores) {
		this.tiposAsuntosTiposGestores = tiposAsuntosTiposGestores;
	}

	public HashMap<String, HashMap<String, Set<String>>> getPerfilesGestoresEspeciales() {
		return perfilesGestoresEspeciales;
	}

	public void setPerfilesGestoresEspeciales(
			HashMap<String, HashMap<String, Set<String>>> perfilesGestoresEspeciales) {
		this.perfilesGestoresEspeciales = perfilesGestoresEspeciales;
	}

	public HashMap<String, HashMap<String, Set<String>>> getSupervisorAsunto() {
		return supervisorAsunto;
	}

	public void setSupervisorAsunto(
			HashMap<String, HashMap<String, Set<String>>> supervisorAsunto) {
		this.supervisorAsunto = supervisorAsunto;
	}

	public HashMap<String, HashMap<String, Set<String>>> getDespachoSupervisorAsunto() {
		return despachoSupervisorAsunto;
	}

	public void setDespachoSupervisorAsunto(
			HashMap<String, HashMap<String, Set<String>>> despachoSupervisorAsunto) {
		this.despachoSupervisorAsunto = despachoSupervisorAsunto;
	}

	public HashMap<String, HashMap<String, Set<String>>> getTipoGestorSupervisorAsunto() {
		return tipoGestorSupervisorAsunto;
	}

	public void setTipoGestorSupervisorAsunto(
			HashMap<String, HashMap<String, Set<String>>> tipoGestorSupervisorAsunto) {
		this.tipoGestorSupervisorAsunto = tipoGestorSupervisorAsunto;
	}

	/**
	 * PRODUCTO-1272 Getters and Setters para el mapeo del contrato en vigr, perfil despacho y relacion bankia 
	 */
	
	public Map<String, String> getMapaContratoVigor() {
		return mapaContratoVigor;
	}

	public void setMapaContratoVigor(Map<String, String> mapaContratoVigor) {
		this.mapaContratoVigor = mapaContratoVigor;
	}

	@Override
	public Map<String, List<String>> getDespachosProcuradores() {
		return despachosProcuradores;
	}

	public void setDespachosProcuradores(Map<String, List<String>> despachosProcuradores) {
		this.despachosProcuradores = despachosProcuradores;
	}
	
	public Map<String, String> getMapaClasificacionDespachoPerfil() {
		return mapaClasificacionDespachoPerfil;
	}

	public void setMapaClasificacionDespachoPerfil(Map<String, String> mapaClasificacionDespachoPerfil) {
		this.mapaClasificacionDespachoPerfil = mapaClasificacionDespachoPerfil;
	}

	
	public Map<String, String> getMapaRelacionBankia() {
		return mapaRelacionBankia;
	}

	public void setMapaRelacionBankia(Map<String, String> mapaRelacionBankia) {
		this.mapaRelacionBankia = mapaRelacionBankia;
	}

	
	public Map<String, String> getMapaDescripcionIVA() {
		return mapaDescripcionIVA;
	}

	public void setMapaDescripcionIVA(Map<String, String> mapaDescripcionIva) {
		this.mapaDescripcionIVA = mapaDescripcionIva;
	}	
	
	
	public Map<String, String> getMapaCodEstAse() {
		return mapaCodEstAse;
	}
	
	public void setMapaCodEstAse(Map<String, String> mapaCodEstAse) {
		this.mapaCodEstAse = mapaCodEstAse;
	}

	public Set<String> getTiposGestorCentroProcura() {
		return tiposGestorCentroProcura;
	}

	public void setTiposGestorCentroProcura(Set<String> tiposGestorCentroProcura) {
		this.tiposGestorCentroProcura = tiposGestorCentroProcura;
	}
}
