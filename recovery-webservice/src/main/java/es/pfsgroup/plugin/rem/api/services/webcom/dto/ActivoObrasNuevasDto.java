package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class ActivoObrasNuevasDto implements WebcomRESTDto {
	@WebcomRequired
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired
	private LongDataType idAgrupacionRem;
	
	//@WebcomRequired
	//@MappedColumn("ID_SUBDIVISION_REM")
	//private LongDataType idSubdivisionAgrupacionRem;
	//@NestedDto(groupBy="idSubdivisionAgrupacionRem", type=CabeceraDto.class)
	//private List<CabeceraDto> cabeceras;
	
	//@WebcomRequired
	//private LongDataType idActivoHaya;
	@WebcomRequired
	@NestedDto(groupBy="idAgrupacionRem", type=ActivoVinculadoDto.class)
	private List<ActivoVinculadoDto> activosVinculados;
	
	
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
/*	public LongDataType getIdSubdivisionAgrupacionRem() {
		return idSubdivisionAgrupacionRem;
	}
	public void setIdSubdivisionAgrupacionRem(LongDataType idSubdivisionAgrupacionRem) {
		this.idSubdivisionAgrupacionRem = idSubdivisionAgrupacionRem;
	}*/
/*	public LongDataType getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(LongDataType idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}*/
	public List<ActivoVinculadoDto> getActivosVinculados() {
		return activosVinculados;
	}
	public void setActivosVinculados(List<ActivoVinculadoDto> activosVinculados) {
		this.activosVinculados = activosVinculados;
	}
/*	public List<CabeceraDto> getCabeceras() {
		return cabeceras;
	}
	public void setCabeceras(List<CabeceraDto> cabeceras) {
		this.cabeceras = cabeceras;
	}
	*/
	

}
