package es.pfsgroup.plugin.rem.model;

import java.util.Date;




/**
 * Dto para los incrementos de presupuesto del activo
 * @author Benjamín Guerrero
 *
 */
public class DtoIncrementoPresupuestoActivo {

private Long id;	
private Double presupuestoActivoImporte;
private Long codigoTrabajo;
private Double importeIncremento;
private Date fechaAprobacion;

public Long getId() {
	return id;
}
public void setId(Long id) {
	this.id = id;
}
public Double getPresupuestoActivoImporte() {
	return presupuestoActivoImporte;
}
public void setPresupuestoActivoImporte(Double presupuestoActivoImporte) {
	this.presupuestoActivoImporte = presupuestoActivoImporte;
}
public Long getCodigoTrabajo() {
	return codigoTrabajo;
}
public void setCodigoTrabajo(Long codigoTrabajo) {
	this.codigoTrabajo = codigoTrabajo;
}
public Double getImporteIncremento() {
	return importeIncremento;
}
public void setImporteIncremento(Double importeIncremento) {
	this.importeIncremento = importeIncremento;
}
public Date getFechaAprobacion() {
	return fechaAprobacion;
}
public void setFechaAprobacion(Date fechaAprobacion) {
	this.fechaAprobacion = fechaAprobacion;
}


    
}