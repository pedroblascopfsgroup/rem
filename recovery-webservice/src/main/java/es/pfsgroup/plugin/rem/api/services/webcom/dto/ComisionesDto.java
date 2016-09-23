package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.DecimalDataTypeFormat;

public class ComisionesDto implements WebcomRESTDto{
	private DateDataType fechaAccion;
	private LongDataType idUsuarioRemAccion;
	private LongDataType idOfertaRem;
	private LongDataType idOfertaWebcom;
	private BooleanDataType idProveedorRem;
	private BooleanDataType esPrescripcion;
	private BooleanDataType esColaboracion;
	private BooleanDataType esResponsable;
	private BooleanDataType esFdv;
	private BooleanDataType esDoblePrescripcion;
	private StringDataType observaciones;
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType importe;
	@DecimalDataTypeFormat(decimals=2)
	private DoubleDataType porcentaje;
	
	
	public DateDataType getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(DateDataType fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public LongDataType getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(LongDataType idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public LongDataType getIdOfertaRem() {
		return idOfertaRem;
	}
	public void setIdOfertaRem(LongDataType idOfertaRem) {
		this.idOfertaRem = idOfertaRem;
	}
	public LongDataType getIdOfertaWebcom() {
		return idOfertaWebcom;
	}
	public void setIdOfertaWebcom(LongDataType idOfertaWebcom) {
		this.idOfertaWebcom = idOfertaWebcom;
	}
	public BooleanDataType getIdProveedorRem() {
		return idProveedorRem;
	}
	public void setIdProveedorRem(BooleanDataType idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
	}
	public BooleanDataType getEsPrescripcion() {
		return esPrescripcion;
	}
	public void setEsPrescripcion(BooleanDataType esPrescripcion) {
		this.esPrescripcion = esPrescripcion;
	}
	public BooleanDataType getEsColaboracion() {
		return esColaboracion;
	}
	public void setEsColaboracion(BooleanDataType esColaboracion) {
		this.esColaboracion = esColaboracion;
	}
	public BooleanDataType getEsResponsable() {
		return esResponsable;
	}
	public void setEsResponsable(BooleanDataType esResponsable) {
		this.esResponsable = esResponsable;
	}
	public BooleanDataType getEsFdv() {
		return esFdv;
	}
	public void setEsFdv(BooleanDataType esFdv) {
		this.esFdv = esFdv;
	}
	public BooleanDataType getEsDoblePrescripcion() {
		return esDoblePrescripcion;
	}
	public void setEsDoblePrescripcion(BooleanDataType esDoblePrescripcion) {
		this.esDoblePrescripcion = esDoblePrescripcion;
	}
	public StringDataType getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(StringDataType observaciones) {
		this.observaciones = observaciones;
	}
	public DoubleDataType getImporte() {
		return importe;
	}
	public void setImporte(DoubleDataType importe) {
		this.importe = importe;
	}
	public DoubleDataType getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(DoubleDataType porcentaje) {
		this.porcentaje = porcentaje;
	}
	
}
