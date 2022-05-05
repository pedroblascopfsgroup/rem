package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;

public class ConductasInapropiadasDto{
	
	private LongDataType idConductaInapropiada;
	private StringDataType fechaAlta;
	private StringDataType usuarioAlta;
	private StringDataType codTipologia;
	private StringDataType codCategoria;
	private StringDataType codNivel;
	private StringDataType comentarios;
	private LongDataType idDelegacion;
	
	
	public LongDataType getIdConductaInapropiada() {
		return idConductaInapropiada;
	}
	public void setIdConductaInapropiada(LongDataType idConductaInapropiada) {
		this.idConductaInapropiada = idConductaInapropiada;
	}
	public StringDataType getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(StringDataType fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public StringDataType getUsuarioAlta() {
		return usuarioAlta;
	}
	public void setUsuarioAlta(StringDataType usuarioAlta) {
		this.usuarioAlta = usuarioAlta;
	}
	public StringDataType getCodTipologia() {
		return codTipologia;
	}
	public void setCodTipologia(StringDataType codTipologia) {
		this.codTipologia = codTipologia;
	}
	public StringDataType getCodCategoria() {
		return codCategoria;
	}
	public void setCodCategoria(StringDataType codCategoria) {
		this.codCategoria = codCategoria;
	}
	public StringDataType getCodNivel() {
		return codNivel;
	}
	public void setCodNivel(StringDataType codNivel) {
		this.codNivel = codNivel;
	}
	public StringDataType getComentarios() {
		return comentarios;
	}
	public void setComentarios(StringDataType comentarios) {
		this.comentarios = comentarios;
	}
	public LongDataType getIdDelegacion() {
		return idDelegacion;
	}
	public void setIdDelegacion(LongDataType idDelegacion) {
		this.idDelegacion = idDelegacion;
	}
}
