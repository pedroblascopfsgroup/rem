package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class ComisionDto implements Serializable {

	private static final long serialVersionUID = 1L;

	@Diccionary(clase = GastosExpediente.class, foreingField = "id", message = "El idComisionRem no existe", groups = {
			Insert.class, Update.class })
	@NotNull(groups = { Insert.class, Update.class })
	private Long idComisionRem;

	@Diccionary(clase = Oferta.class, foreingField = "numOferta", message = "El idOfertaRem no existe", groups = {
			Insert.class, Update.class })
	private Long idOfertaRem;
/*	@Diccionary(clase = Oferta.class, foreingField = "idWebCom", message = "El idOfertaWebcom no existe", groups = {
			Insert.class, Update.class })*/
	private Long idOfertaWebcom;
	@Diccionary(clase = ActivoProveedor.class, foreingField = "codigoProveedorRem", message = "El idProveedorRem no existe", groups = {
			Insert.class, Update.class })
	private Long idProveedorRem;
	private Boolean esPrescripcion;
	private Boolean esColaboracion;
	private Boolean esResponsable;
	private Boolean esDoblePrescripcion;
	private Boolean esFdv;
	@Size(max = 250, groups = { Insert.class, Update.class })
	private String observaciones;
	@NotNull(groups = { Insert.class, Update.class })
	private Boolean aceptacion;
	@NotNull(groups = { Insert.class, Update.class })
	private Date fechaAccion;
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Usuario.class, message = "El usuario no existe", groups = { Insert.class,
			Update.class }, foreingField = "id")
	private Long idUsuarioRemAccion;

	public Long getIdComisionRem() {
		return idComisionRem;
	}

	public void setIdComisionRem(Long idComisionRem) {
		this.idComisionRem = idComisionRem;
	}

	public Long getIdOfertaRem() {
		return idOfertaRem;
	}

	public void setIdOfertaRem(Long idOfertaRem) {
		this.idOfertaRem = idOfertaRem;
	}

	public Long getIdOfertaWebcom() {
		return idOfertaWebcom;
	}

	public void setIdOfertaWebcom(Long idOfertaWebcom) {
		this.idOfertaWebcom = idOfertaWebcom;
	}

	public Long getIdProveedorRem() {
		return idProveedorRem;
	}

	public void setIdProveedorRem(Long idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
	}

	public Boolean getEsPrescripcion() {
		return esPrescripcion;
	}

	public void setEsPrescripcion(Boolean esPrescripcion) {
		this.esPrescripcion = esPrescripcion;
	}

	public Boolean getEsColaboracion() {
		return esColaboracion;
	}

	public void setEsColaboracion(Boolean esColaboracion) {
		this.esColaboracion = esColaboracion;
	}

	public Boolean getEsResponsable() {
		return esResponsable;
	}

	public void setEsResponsable(Boolean esResponsable) {
		this.esResponsable = esResponsable;
	}

	public Boolean getEsDoblePrescripcion() {
		return esDoblePrescripcion;
	}

	public void setEsDoblePrescripcion(Boolean esDoblePrescripcion) {
		this.esDoblePrescripcion = esDoblePrescripcion;
	}

	public Boolean getEsFdv() {
		return esFdv;
	}

	public void setEsFdv(Boolean esFdv) {
		this.esFdv = esFdv;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Boolean getAceptacion() {
		return aceptacion;
	}

	public void setAceptacion(Boolean aceptacion) {
		this.aceptacion = aceptacion;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}

	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}

}
