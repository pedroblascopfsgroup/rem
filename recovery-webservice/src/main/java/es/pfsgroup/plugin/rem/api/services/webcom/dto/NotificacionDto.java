package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class NotificacionDto implements WebcomRESTDto{
	
	@WebcomRequired
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idUsuarioRemAccion;
	private LongDataType idNotificacionWebcom;
	@WebcomRequired
	private LongDataType idNotificacionRem;
	@WebcomRequired
	private LongDataType idActivoHaya;
	private StringDataType descripcion;
	
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
	public LongDataType getIdNotificacionWebcom() {
		return idNotificacionWebcom;
	}
	public void setIdNotificacionWebcom(LongDataType idNotificacionWebcom) {
		this.idNotificacionWebcom = idNotificacionWebcom;
	}
	public LongDataType getIdNotificacionRem() {
		return idNotificacionRem;
	}
	public void setIdNotificacionRem(LongDataType idNotificacionRem) {
		this.idNotificacionRem = idNotificacionRem;
	}
	public LongDataType getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(LongDataType idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public StringDataType getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(StringDataType descripcion) {
		this.descripcion = descripcion;
	}
	
	
	

}
