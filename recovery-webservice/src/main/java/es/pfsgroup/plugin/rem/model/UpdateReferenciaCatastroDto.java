package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;




/**
 * Dto para la modificación de datos de las referencias catastrales
 * @author Julián Dolz
 *
 */
public class UpdateReferenciaCatastroDto extends WebDto {

	private static final long serialVersionUID = 0L;

	
	private long idActivoCatastro;
	private String refCatastral;
	private Double valorCatastralConst;
	private Double valorCatastralSuelo;
	private Date fechaRevValorCatastral;
	
	public long getIdActivoCatastro() {
		return idActivoCatastro;
	}
	public void setIdActivoCatastro(long idActivoCatastro) {
		this.idActivoCatastro = idActivoCatastro;
	}
	public String getRefCatastral() {
		return refCatastral;
	}
	public void setRefCatastral(String refCatastral) {
		this.refCatastral = refCatastral;
	}
	public Double getValorCatastralConst() {
		return valorCatastralConst;
	}
	public void setValorCatastralConst(Double valorCatastralConst) {
		this.valorCatastralConst = valorCatastralConst;
	}
	public Double getValorCatastralSuelo() {
		return valorCatastralSuelo;
	}
	public void setValorCatastralSuelo(Double valorCatastralSuelo) {
		this.valorCatastralSuelo = valorCatastralSuelo;
	}
	public Date getFechaRevValorCatastral() {
		return fechaRevValorCatastral;
	}
	public void setFechaRevValorCatastral(Date fechaRevValorCatastral) {
		this.fechaRevValorCatastral = fechaRevValorCatastral;
	}
}