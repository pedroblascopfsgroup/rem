package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de configuración de propuestas de precios.
 */
public class DtoConfiguracionPropuestasPrecios extends WebDto {
	private static final long serialVersionUID = 0L;

	private String idRegla;
	private String carteraCodigo;
	private String propuestaPrecioCodigo;
	private String indicadorCondicionCodigo;
	private String menorQueText;
	private String mayorQueText;
	private String igualQueText;


	public String getIdRegla() {
		return idRegla;
	}

	public void setIdRegla(String idRegla) {
		this.idRegla = idRegla;
	}

	public String getCarteraCodigo() {
		return carteraCodigo;
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}

	public String getPropuestaPrecioCodigo() {
		return propuestaPrecioCodigo;
	}

	public void setPropuestaPrecioCodigo(String propuestaPrecioCodigo) {
		this.propuestaPrecioCodigo = propuestaPrecioCodigo;
	}

	public String getIndicadorCondicionCodigo() {
		return indicadorCondicionCodigo;
	}

	public void setIndicadorCondicionCodigo(String indicadorCondicionCodigo) {
		this.indicadorCondicionCodigo = indicadorCondicionCodigo;
	}

	public String getMenorQueText() {
		return menorQueText;
	}

	public void setMenorQueText(String menorQueText) {
		this.menorQueText = menorQueText;
	}

	public String getMayorQueText() {
		return mayorQueText;
	}

	public void setMayorQueText(String mayorQueText) {
		this.mayorQueText = mayorQueText;
	}

	public String getIgualQueText() {
		return igualQueText;
	}

	public void setIgualQueText(String igualQueText) {
		this.igualQueText = igualQueText;
	}

}