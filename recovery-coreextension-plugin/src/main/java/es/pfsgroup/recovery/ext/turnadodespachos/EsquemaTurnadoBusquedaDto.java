package es.pfsgroup.recovery.ext.turnadodespachos;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class EsquemaTurnadoBusquedaDto extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String tipoEstado;
	private String nombreEsquemaTurnado;
	private String autor;
	private String fechaAlta;
	private String fechaVigente;
	private String fechaFinalizado;
	
	public String getTipoEstado() {
		return tipoEstado;
	}
	public void setTipoEstado(String tipoEstado) {
		this.tipoEstado = tipoEstado;
	}
	public String getNombreEsquemaTurnado() {
		return nombreEsquemaTurnado;
	}
	public void setNombreEsquemaTurnado(String nombreEsquemaTurnado) {
		this.nombreEsquemaTurnado = nombreEsquemaTurnado;
	}
	public String getAutor() {
		return autor;
	}
	public void setAutor(String autor) {
		this.autor = autor;
	}
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getFechaVigente() {
		return fechaVigente;
	}
	public void setFechaVigente(String fechaVigente) {
		this.fechaVigente = fechaVigente;
	}
	public String getFechaFinalizado() {
		return fechaFinalizado;
	}
	public void setFechaFinalizado(String fechaFinalizado) {
		this.fechaFinalizado = fechaFinalizado;
	}
	public Date convertirFechaToDate(String fecha) throws ParseException{
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		Date fechaBuena=format.parse(fecha);
		return fechaBuena;
	}
}
