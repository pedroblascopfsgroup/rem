package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.List;

public class ActivoDto implements Serializable{
	
	private static final long serialVersionUID = -6901301764485295835L;
	
	private Long activoId;
	private String descripcion;
	private String pais;
	private String provincia;
	private String direccion;
	private Long numActivo;
	private List<Long> idActivoBien;
	
	private String municipio;
	private String fincaRegistral;
	private String tipoActivo;
	private String subtipoActivo;
	
	
	public Long getActivoId() {
		return activoId;
	}

	public void setActivoId(Long activoId) {
		this.activoId = activoId;
	}

	public List<Long> getIdActivoBien() {
		return idActivoBien;
	}

	public void setIdActivoBien(List<Long> idActivoBien) {
		this.idActivoBien = idActivoBien;
	}
	

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getPais() {
		return pais;
	}

	public void setPais(String pais) {
		this.pais = pais;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getFincaRegistral() {
		return fincaRegistral;
	}

	public void setFincaRegistral(String fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}
	
	

}
