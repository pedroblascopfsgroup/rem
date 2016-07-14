package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class TurnadoHistoricoDto extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String asunto;
	private String letrado;
	private String procurador;
	private String fechaDesde;
	private String fechaHasta;
	private String importeMax;
	private String importeMin;
	private String plaza;
	private String tpo;

	public String getAsunto() {
		return asunto;
	}

	public void setAsunto(String asunto) {
		this.asunto = asunto;
	}

	public String getLetrado() {
		return letrado;
	}

	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}

	public String getProcurador() {
		return procurador;
	}

	public void setProcurador(String procurador) {
		this.procurador = procurador;
	}

	public String getFechaDesde() {
		return fechaDesde;
	}

	public void setFechaDesde(String fechaDesde) {
		this.fechaDesde = fechaDesde;
	}

	public String getFechaHasta() {
		return fechaHasta;
	}

	public void setFechaHasta(String fechaHasta) {
		this.fechaHasta = fechaHasta;
	}

	public String getImporteMax() {
		return importeMax;
	}

	public void setImporteMax(String importeMax) {
		this.importeMax = importeMax;
	}

	public String getImporteMin() {
		return importeMin;
	}

	public void setImporteMin(String importeMin) {
		this.importeMin = importeMin;
	}

	public String getPlaza() {
		return plaza;
	}

	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}

	public String getTpo() {
		return tpo;
	}

	public void setTpo(String tpo) {
		this.tpo = tpo;
	}
	
	public Date convertirFechaToDate(String fecha) throws ParseException{
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Date fechaBuena=format.parse(fecha);
		return fechaBuena;
	}

}
