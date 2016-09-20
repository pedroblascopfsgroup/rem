package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;

public class EstadoTrabajoDto implements WebcomRESTDto{
	
	private LongDataType idUsuarioRemAccion;
	private DateDataType fechaAccion;	
	private LongDataType idTrabajoRem;
	private LongDataType idTrabajoWebcom;
	private StringDataType codEstadoTrabajo;
	private StringDataType motivoRechazo;
	public LongDataType getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(LongDataType idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public DateDataType getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(DateDataType fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public LongDataType getIdTrabajoRem() {
		return idTrabajoRem;
	}
	public void setIdTrabajoRem(LongDataType idTrabajoRem) {
		this.idTrabajoRem = idTrabajoRem;
	}
	public LongDataType getIdTrabajoWebcom() {
		return idTrabajoWebcom;
	}
	public void setIdTrabajoWebcom(LongDataType idTrabajoWebcom) {
		this.idTrabajoWebcom = idTrabajoWebcom;
	}
	public StringDataType getCodEstadoTrabajo() {
		return codEstadoTrabajo;
	}
	public void setCodEstadoTrabajo(StringDataType codEstadoTrabajo) {
		this.codEstadoTrabajo = codEstadoTrabajo;
	}
	public StringDataType getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(StringDataType motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	



}
