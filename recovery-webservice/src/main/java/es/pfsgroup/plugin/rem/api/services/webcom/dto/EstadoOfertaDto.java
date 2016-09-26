package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class EstadoOfertaDto implements WebcomRESTDto{
	
	@WebcomRequired
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idOfertaWebcom;
	@WebcomRequired
	private LongDataType idOfertaRem;
	private LongDataType idActivoHaya;
	@WebcomRequired
	private StringDataType codEstadoOferta;
	private StringDataType codEstadoExpediente;
	private BooleanDataType vendido;
	
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
	public LongDataType getIdOfertaWebcom() {
		return idOfertaWebcom;
	}
	public void setIdOfertaWebcom(LongDataType idOfertaWebcom) {
		this.idOfertaWebcom = idOfertaWebcom;
	}
	public LongDataType getIdOfertaRem() {
		return idOfertaRem;
	}
	public void setIdOfertaRem(LongDataType idOfertaRem) {
		this.idOfertaRem = idOfertaRem;
	}
	public LongDataType getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(LongDataType idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public StringDataType getCodEstadoOferta() {
		return codEstadoOferta;
	}
	public void setCodEstadoOferta(StringDataType codEstadoOferta) {
		this.codEstadoOferta = codEstadoOferta;
	}
	public StringDataType getCodEstadoExpediente() {
		return codEstadoExpediente;
	}
	public void setCodEstadoExpediente(StringDataType codEstadoExpediente) {
		this.codEstadoExpediente = codEstadoExpediente;
	}
	public BooleanDataType getVendido() {
		return vendido;
	}
	public void setVendido(BooleanDataType vendido) {
		this.vendido = vendido;
	}

}
