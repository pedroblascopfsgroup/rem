package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoEmailReserva extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long numeroOferta;
	private Double importeOferta;
	private Double importeReserva;
	private Date fechaFirmaReserva;
	private Date fechaVenta;
	private List <DtoEmailReservaDatosCompradores> listaEmailReservaCompradores;
	private List <DtoEmailReservaDatosActivos> lisDtoEmailReservaDatosActivos;
	
	
	public Long getNumeroOferta() {
		return numeroOferta;
	}
	public void setNumeroOferta(Long numeroOferta) {
		this.numeroOferta = numeroOferta;
	}
	public Double getImporteOferta() {
		return importeOferta;
	}
	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}
	public Double getImporteReserva() {
		return importeReserva;
	}
	public void setImporteReserva(Double importeReserva) {
		this.importeReserva = importeReserva;
	}
	public Date getFechaFirmaReserva() {
		return fechaFirmaReserva;
	}
	public void setFechaFirmaReserva(Date fechaFirmaReserva) {
		this.fechaFirmaReserva = fechaFirmaReserva;
	}
	public List<DtoEmailReservaDatosCompradores> getListaEmailReservaCompradores() {
		return listaEmailReservaCompradores;
	}
	public void setListaEmailReservaCompradores(List<DtoEmailReservaDatosCompradores> listaEmailReservaCompradores) {
		this.listaEmailReservaCompradores = listaEmailReservaCompradores;
	}
	public List<DtoEmailReservaDatosActivos> getLisDtoEmailReservaDatosActivos() {
		return lisDtoEmailReservaDatosActivos;
	}
	public void setLisDtoEmailReservaDatosActivos(List<DtoEmailReservaDatosActivos> lisDtoEmailReservaDatosActivos) {
		this.lisDtoEmailReservaDatosActivos = lisDtoEmailReservaDatosActivos;
	}
	public Date getFechaVenta() {
		return fechaVenta;
	}
	public void setFechaVenta(Date fechaVenta) {
		this.fechaVenta = fechaVenta;
	}
}