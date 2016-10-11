package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class CabeceraObrasNuevasDto implements WebcomRESTDto {
	@WebcomRequired
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired
	@MappedColumn("ID_SUBDIVISION_REM")
	private LongDataType idSubdivisionAgrupacionRem;
	@WebcomRequired
	private LongDataType idAgrupacionRem;
	@WebcomRequired
	private StringDataType codTipoActivo;
	@WebcomRequired
	private StringDataType codSubtipoActivo;
	@WebcomRequired
	private StringDataType nombre;
	@WebcomRequired
	private LongDataType plantas;
	@WebcomRequired
	private LongDataType habitaciones;
	@WebcomRequired
	private LongDataType banyos;
	@WebcomRequired
	private LongDataType asociadosActivos;

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

	public LongDataType getIdSubdivisionAgrupacionRem() {
		return idSubdivisionAgrupacionRem;
	}

	public void setIdSubdivisionAgrupacionRem(LongDataType idSubdivisionAgrupacionRem) {
		this.idSubdivisionAgrupacionRem = idSubdivisionAgrupacionRem;
	}

	public LongDataType getIdAgrupacionRem() {
		return idAgrupacionRem;
	}

	public void setIdAgrupacionRem(LongDataType idAgrupacionRem) {
		this.idAgrupacionRem = idAgrupacionRem;
	}

	public StringDataType getCodTipoActivo() {
		return codTipoActivo;
	}

	public void setCodTipoActivo(StringDataType codTipoActivo) {
		this.codTipoActivo = codTipoActivo;
	}

	public StringDataType getCodSubtipoActivo() {
		return codSubtipoActivo;
	}

	public void setCodSubtipoActivo(StringDataType codSubtipoActivo) {
		this.codSubtipoActivo = codSubtipoActivo;
	}

	public StringDataType getNombre() {
		return nombre;
	}

	public void setNombre(StringDataType nombre) {
		this.nombre = nombre;
	}

	public LongDataType getPlantas() {
		return plantas;
	}

	public void setPlantas(LongDataType plantas) {
		this.plantas = plantas;
	}

	public LongDataType getHabitaciones() {
		return habitaciones;
	}

	public void setHabitaciones(LongDataType habitaciones) {
		this.habitaciones = habitaciones;
	}

	public LongDataType getBanyos() {
		return banyos;
	}

	public void setBanyos(LongDataType banyos) {
		this.banyos = banyos;
	}

	public LongDataType getAsociadosActivos() {
		return asociadosActivos;
	}

	public void setAsociadosActivos(LongDataType asociadosActivos) {
		this.asociadosActivos = asociadosActivos;
	}

}
