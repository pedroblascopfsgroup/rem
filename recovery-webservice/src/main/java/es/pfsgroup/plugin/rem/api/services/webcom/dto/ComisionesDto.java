package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.DecimalDataTypeFormat;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class ComisionesDto implements WebcomRESTDto {
	@WebcomRequired
	private LongDataType idComisionRem;
	@WebcomRequired
	private LongDataType idActivoRem;
	@WebcomRequired
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired
	private LongDataType idOfertaRem;
	@WebcomRequired
	private LongDataType idOfertaWebcom;
	@WebcomRequired
	private LongDataType idProveedorRem;
	@WebcomRequired
	private BooleanDataType esPrescripcion;
	@WebcomRequired
	private BooleanDataType esColaboracion;
	@WebcomRequired
	private BooleanDataType esResponsable;
	@WebcomRequired
	private BooleanDataType esFdv;
	@WebcomRequired
	private BooleanDataType esDoblePrescripcion;

	private StringDataType observaciones;
	
	@DecimalDataTypeFormat(decimals = 2)
	@WebcomRequired
	private DoubleDataType importe;
	@DecimalDataTypeFormat(decimals = 2)
	@WebcomRequired
	private DoubleDataType porcentaje;
	
	private LongDataType baja;
	
	@NestedDto(groupBy="idComisionRem", type=ActivoComisionDto.class)
	private List<ActivoComisionDto> actComisiones;

	public List<ActivoComisionDto> getActivoComisiones() {
		return actComisiones;
	}

	public void setActivoComisiones(List<ActivoComisionDto> activoComisiones) {
		this.actComisiones = activoComisiones;
	}

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

	public LongDataType getIdProveedorRem() {
		return idProveedorRem;
	}

	public void setIdProveedorRem(LongDataType idProveedorRem) {
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

	public LongDataType getIdComisionRem() {
		return idComisionRem;
	}

	public void setIdComisionRem(LongDataType idComisionRem) {
		this.idComisionRem = idComisionRem;
	}

	public LongDataType getBaja() {
		return baja;
	}

	public void setBaja(LongDataType baja) {
		this.baja = baja;
	}
	
	public LongDataType getIdActivoRem() {
		return idActivoRem;
	}

	public void setIdActivoRem(LongDataType idActivoRem) {
		this.idActivoRem = idActivoRem;
	}

}
