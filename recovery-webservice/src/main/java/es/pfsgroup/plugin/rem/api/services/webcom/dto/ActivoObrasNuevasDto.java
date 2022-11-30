package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class ActivoObrasNuevasDto implements WebcomRESTDto {
	@WebcomRequired
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired
	private LongDataType idAgrupacionRem;	
	@WebcomRequired
	@MappedColumn("ID_SUBDIVISION_REM")
	private LongDataType idSubdivisionAgrupacionRem;
	@WebcomRequired
	private LongDataType idActivoHaya;
	
	//Petición HREOS-7226
	private LongDataType agrVisitable;
	private LongDataType esPisoPiloto;
	
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
	public LongDataType getIdAgrupacionRem() {
		return idAgrupacionRem;
	}
	public void setIdAgrupacionRem(LongDataType idAgrupacionRem) {
		this.idAgrupacionRem = idAgrupacionRem;
	}
	public LongDataType getIdSubdivisionAgrupacionRem() {
		return idSubdivisionAgrupacionRem;
	}
	public void setIdSubdivisionAgrupacionRem(LongDataType idSubdivisionAgrupacionRem) {
		this.idSubdivisionAgrupacionRem = idSubdivisionAgrupacionRem;
	}
	public LongDataType getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(LongDataType idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public LongDataType getAgrVisitable() {
		return agrVisitable;
	}
	public void setAgrVisitable(LongDataType agrVisitable) {
		this.agrVisitable = agrVisitable;
	}
	public LongDataType getEsPisoPiloto() {
		return esPisoPiloto;
	}
	public void setEsPisoPiloto(LongDataType esPisoPiloto) {
		this.esPisoPiloto = esPisoPiloto;
	}
}
