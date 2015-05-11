package es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto;

import java.util.Date;

public class BienProcedimientoDTO {
	private Long id;
	private Long numActivo;
	private String codigo;
	private String origen;
	private String descripcion;
	private String tipo;
	private Boolean viviendaHabitual;
	private String sitPosesoria;
	private Date revCargas;
	private Date fSolTasacion;
	private Date fTasacion;
	private String adjudicacion;
	private Double impAdjudicado;
	private Integer lote;
	private String codSolvencia;
	private String solvencia;
	private String numFinca;
	private String referenciaCatastral;
	
	
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public Boolean getViviendaHabitual() {
		return viviendaHabitual;
	}
	public void setViviendaHabitual(Boolean viviendaHabitual) {
		this.viviendaHabitual = viviendaHabitual;
	}
	public String getSitPosesoria() {
		return sitPosesoria;
	}
	public void setSitPosesoria(String sitPosesoria) {
		this.sitPosesoria = sitPosesoria;
	}
	public Date getRevCargas() {
		return revCargas;
	}
	public void setRevCargas(Date revCargas) {
		this.revCargas = revCargas;
	}
	public Date getfSolTasacion() {
		return fSolTasacion;
	}
	public void setfSolTasacion(Date fSolTasacion) {
		this.fSolTasacion = fSolTasacion;
	}
	public Date getfTasacion() {
		return fTasacion;
	}
	public void setfTasacion(Date fTasacion) {
		this.fTasacion = fTasacion;
	}
	public String getAdjudicacion() {
		return adjudicacion;
	}
	public void setAdjudicacion(String adjudicacion) {
		this.adjudicacion = adjudicacion;
	}
	public Double getImpAdjudicado() {
		return impAdjudicado;
	}
	public void setImpAdjudicado(Double impAdjudicado) {
		this.impAdjudicado = impAdjudicado;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Integer getLote() {
		return lote;
	}
	public void setLote(Integer lote) {
		this.lote = lote;
	}
	public String getSolvencia() {
		return solvencia;
	}
	public void setSolvencia(String solvencia) {
		this.solvencia = solvencia;
	}
	public String getCodSolvencia() {
		return codSolvencia;
	}
	public void setCodSolvencia(String codSolvencia) {
		this.codSolvencia = codSolvencia;
	}
	public String getNumFinca() {
		return numFinca;
	}
	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}
	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}
	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}
	
}
