package es.pfsgroup.recovery.recobroCommon.esquema.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroEsquemaDto extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7707942407367705916L;
	
	private String id;
	private String nombre;
	private String descripcion;
	private String estado;
	private String plazoActivacion;
	private String modeloTransicion;
	private String autor;
	private Long idGrupoVersion;
	private Integer versionrelease;
	private Integer majorRelease;
	private Integer minorRelease;
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getAutor() {
		return autor;
	}
	public void setAutor(String autor) {
		this.autor = autor;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPlazoActivacion() {
		return plazoActivacion;
	}
	public void setPlazoActivacion(String plazoActivacion) {
		this.plazoActivacion = plazoActivacion;
	}
	public String getModeloTransicion() {
		return modeloTransicion;
	}
	public void setModeloTransicion(String modeloTransicion) {
		this.modeloTransicion = modeloTransicion;
	}
	public Long getIdGrupoVersion() {
		return idGrupoVersion;
	}
	public void setIdGrupoVersion(Long idGrupoVersion) {
		this.idGrupoVersion = idGrupoVersion;
	}
	public Integer getVersionrelease() {
		return versionrelease;
	}
	public void setVersionrelease(Integer versionrelease) {
		this.versionrelease = versionrelease;
	}
	public Integer getMajorRelease() {
		return majorRelease;
	}
	public void setMajorRelease(Integer majorRelease) {
		this.majorRelease = majorRelease;
	}
	public Integer getMinorRelease() {
		return minorRelease;
	}
	public void setMinorRelease(Integer minorRelease) {
		this.minorRelease = minorRelease;
	}
	
	

}
