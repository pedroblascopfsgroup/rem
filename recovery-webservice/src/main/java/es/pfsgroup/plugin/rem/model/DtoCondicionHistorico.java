package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para el histórico de condiciones específicas de las publicaciones de los activos
 * @author Daniel Gutiérrez
 *
 */
public class DtoCondicionHistorico extends WebDto {

	private static final long serialVersionUID = 0L;

	private String id;
	private Long idUsuarioAlta;
	private Long idUsuarioBaja;
	private String nombreUsuarioAlta;
	private String nombreUsuarioBaja;
	private String condicion;
	private Date fechaAlta;
	private Date fechaBaja;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Long getIdUsuarioAlta() {
		return idUsuarioAlta;
	}
	public void setIdUsuarioAlta(Long idUsuarioAlta) {
		this.idUsuarioAlta = idUsuarioAlta;
	}
	public Long getIdUsuarioBaja() {
		return idUsuarioBaja;
	}
	public void setIdUsuarioBaja(Long idUsuarioBaja) {
		this.idUsuarioBaja = idUsuarioBaja;
	}
	public String getNombreUsuarioAlta() {
		return nombreUsuarioAlta;
	}
	public void setNombreUsuarioAlta(String nombreUsuarioAlta) {
		this.nombreUsuarioAlta = nombreUsuarioAlta;
	}
	public String getNombreUsuarioBaja() {
		return nombreUsuarioBaja;
	}
	public void setNombreUsuarioBaja(String nombreUsuarioBaja) {
		this.nombreUsuarioBaja = nombreUsuarioBaja;
	}
	public String getCondicion() {
		return condicion;
	}
	public void setCondicion(String condicion) {
		this.condicion = condicion;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Date getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}


}