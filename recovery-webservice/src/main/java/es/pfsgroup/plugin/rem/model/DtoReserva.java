package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los datos básicos de una reserva.
 *  
 * @author Jose Villel
 *
 */
public class DtoReserva extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idReserva;
	
	private Long numReserva;
	
	private String tipoArrasCodigo;
	
	private Date fechaEnvio;
	
	private Double importe;
	
	private String estadoReservaDescripcion;
	
	private Date fechaFirma;
	
	private Integer conImpuesto;
	
	private Date fechaVencimiento;

	public Long getIdReserva() {
		return idReserva;
	}

	public void setIdReserva(Long idReserva) {
		this.idReserva = idReserva;
	}

	public Long getNumReserva() {
		return numReserva;
	}

	public void setNumReserva(Long numReserva) {
		this.numReserva = numReserva;
	}

	public String getTipoArrasCodigo() {
		return tipoArrasCodigo;
	}

	public void setTipoArrasCodigo(String tipoArrasCodigo) {
		this.tipoArrasCodigo = tipoArrasCodigo;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public String getEstadoReservaDescripcion() {
		return estadoReservaDescripcion;
	}

	public void setEstadoReservaDescripcion(String estadoReservaDescripcion) {
		this.estadoReservaDescripcion = estadoReservaDescripcion;
	}

	public Date getFechaFirma() {
		return fechaFirma;
	}

	public void setFechaFirma(Date fechaFirma) {
		this.fechaFirma = fechaFirma;
	}

	public Integer getConImpuesto() {
		return conImpuesto;
	}

	public void setConImpuesto(Integer conImpuesto) {
		this.conImpuesto = conImpuesto;
	}

	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}  
   
   	
   	
   	
}
