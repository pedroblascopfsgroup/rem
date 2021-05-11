package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoMantenimientoFilter extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	private Long id;
	private String codCartera;	
	private String codSubCartera;
	private Long codPropietario;
	private String nombrePropietario;
	private String nombreCartera;
	private String nombreSubcartera;
	private String carteraMacc;
	private Date fechaCrear;
	private String usuarioCrear;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}
	public String getCodSubCartera() {
		return codSubCartera;
	}
	public void setCodSubCartera(String codSubCartera) {
		this.codSubCartera = codSubCartera;
	}
	
	public Long getCodPropietario() {
		return codPropietario;
	}
	public void setCodPropietario(Long codPropietario) {
		this.codPropietario = codPropietario;
	}
	public String getNombrePropietario() {
		return nombrePropietario;
	}
	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}
	public String getNombreCartera() {
		return nombreCartera;
	}
	public void setNombreCartera(String nombreCartera) {
		this.nombreCartera = nombreCartera;
	}
	public String getNombreSubcartera() {
		return nombreSubcartera;
	}
	public void setNombreSubcartera(String nombreSubcartera) {
		this.nombreSubcartera = nombreSubcartera;
	}
	public Date getFechaCrear() {
		return fechaCrear;
	}
	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}
	public String getUsuarioCrear() {
		return usuarioCrear;
	}
	public void setUsuarioCrear(String usuarioCrear) {
		this.usuarioCrear = usuarioCrear;
	}
	public String getCarteraMacc() {
		return carteraMacc;
	}
	public void setCarteraMacc(String carteraMacc) {
		this.carteraMacc = carteraMacc;
	}

	
	
	
}
