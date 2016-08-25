package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;




/**
 * Dto para las entregas de una reserva
 * @author Jose Villel
 *
 */
public class DtoEntregaReserva extends WebDto{

	private static final long serialVersionUID = 0L;

	private Long idEntrega;
	private String importe;
	private Date fechaCobro;
	private Date fechaComprador;
	private String observaciones;
	
	public Long getIdEntrega() {
		return idEntrega;
	}
	public void setIdEntrega(Long idEntrega) {
		this.idEntrega = idEntrega;
	}
	public String getImporte() {
		return importe;
	}
	public void setImporte(String importe) {
		this.importe = importe;
	}
	public Date getFechaCobro() {
		return fechaCobro;
	}
	public void setFechaCobro(Date fechaCobro) {
		this.fechaCobro = fechaCobro;
	}
	public Date getFechaComprador() {
		return fechaComprador;
	}
	public void setFechaComprador(Date fechaComprador) {
		this.fechaComprador = fechaComprador;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	
	
	
	
	

	

}