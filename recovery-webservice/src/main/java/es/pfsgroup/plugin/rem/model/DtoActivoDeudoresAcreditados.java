package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoActivoDeudoresAcreditados extends WebDto {
	
	private static final long serialVersionUID = 0L;

	
	private long id;
	private String idActivo;
	private Date fechaAlta;
	private String gestorAlta;
	private String nombre;
	private String apellido1;
	private String apellido2;
	private String tipoDocIdentificativoDesc;
	private String docIdentificativo;
	
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getGestorAlta() {
		return gestorAlta;
	}
	public void setGestorAlta(String gestorAlta) {
		this.gestorAlta = gestorAlta;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellido1() {
		return apellido1;
	}
	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}
	public String getApellido2() {
		return apellido2;
	}
	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}
	public String getTipoDocIdentificativoDesc() {
		return tipoDocIdentificativoDesc;
	}
	public void setTipoDocIdentificativoDesc(String tipoDocIdentificativoDesc) {
		this.tipoDocIdentificativoDesc = tipoDocIdentificativoDesc;
	}
	public String getDocIdentificativo() {
		return docIdentificativo;
	}
	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}
	
}
