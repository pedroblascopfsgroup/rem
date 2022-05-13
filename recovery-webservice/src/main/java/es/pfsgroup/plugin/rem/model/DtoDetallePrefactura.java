package es.pfsgroup.plugin.rem.model;
import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto para el grid de DetallePrefactura
 * @author Jonathan Ovalle
 *
 */
public class DtoDetallePrefactura extends WebDto{

	private static final long serialVersionUID = 0L;
	
	private Long idTrabajo;
	private Long numPrefactura;
	private Long numTrabajo;
	private String tipologiaTrabajo;
	private String subtipologiaTrabajo;
	private String descripcion;
	private Date fechaAlta;
	private String estadoTrabajo;
	private Double importeTotalPrefactura;
	private Double importeTotalClientePrefactura;
	private Boolean checkIncluirTrabajo;
	private String anyoTrabajo;
	private String nombrePropietario;
	
	public Long getIdTrabajo() {
		return idTrabajo;
	}
	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}
	public Long getNumTrabajo() {
		return numTrabajo;
	}
	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getEstadoTrabajo() {
		return estadoTrabajo;
	}
	public void setEstadoTrabajo(String estadoTrabajo) {
		this.estadoTrabajo = estadoTrabajo;
	}
	public Double getImporteTotalPrefactura() {
		return importeTotalPrefactura;
	}
	public void setImporteTotalPrefactura(Double importeTotalPrefactura) {
		this.importeTotalPrefactura = importeTotalPrefactura;
	}
	public Double getImporteTotalClientePrefactura() {
		return importeTotalClientePrefactura;
	}
	public void setImporteTotalClientePrefactura(Double importeTotalClientePrefactura) {
		this.importeTotalClientePrefactura = importeTotalClientePrefactura;
	}
	public Boolean getCheckIncluirTrabajo() {
		return checkIncluirTrabajo;
	}
	public void setCheckIncluirTrabajo(Boolean checkIncluirTrabajo) {
		this.checkIncluirTrabajo = checkIncluirTrabajo;
	}
	public String getTipologiaTrabajo() {
		return tipologiaTrabajo;
	}
	public void setTipologiaTrabajo(String tipologiaTrabajo) {
		this.tipologiaTrabajo = tipologiaTrabajo;
	}
	public String getSubtipologiaTrabajo() {
		return subtipologiaTrabajo;
	}
	public void setSubtipologiaTrabajo(String subtipologiaTrabajo) {
		this.subtipologiaTrabajo = subtipologiaTrabajo;
	}
	public Long getNumPrefactura() {
		return numPrefactura;
	}
	public void setNumPrefactura(Long numPrefactura) {
		this.numPrefactura = numPrefactura;
	}
	public String getAnyoTrabajo() {
		return anyoTrabajo;
	}
	public void setAnyoTrabajo(String anyoTrabajo) {
		this.anyoTrabajo = anyoTrabajo;
	}
	public String getNombrePropietario() {
		return nombrePropietario;
	}
	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}
	
}