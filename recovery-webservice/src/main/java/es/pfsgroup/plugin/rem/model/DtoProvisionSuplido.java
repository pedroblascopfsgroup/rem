package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * DTO que gestiona las provisiones y suplidos
 *
 */
public class DtoProvisionSuplido extends WebDto {

	private static final long serialVersionUID = 1L;
	
	private String idProvisionSuplido;

	private Long idTrabajo;
	
	private String tipoCodigo;
	
	private String tipoDescripcion;	
	
	private Date fecha;
	
	private Double importe;
	
	private String concepto;
	

	public String getIdProvisionSuplido() {
		return idProvisionSuplido;
	}

	public void setIdProvisionSuplido(String idProvisionSuplido) {
		this.idProvisionSuplido = idProvisionSuplido;
	}

	public Long getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public String getTipoCodigo() {
		return tipoCodigo;
	}

	public void setTipoCodigo(String tipoCodigo) {
		this.tipoCodigo = tipoCodigo;
	}

	public String getTipoDescripcion() {
		return tipoDescripcion;
	}

	public void setTipoDescripcion(String tipoDescripcion) {
		this.tipoDescripcion = tipoDescripcion;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public String getConcepto() {
		return concepto;
	}

	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}

	
}