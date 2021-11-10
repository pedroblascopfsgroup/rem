package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoAccionVentaContabilizada extends WebDto{

    private String fechaReal;

    private Long idExpediente;

    private Long numOferta;

	private Long idTarea;

	private String ventaDirecta;

	private String ventaSuspensiva;


	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getNumOferta() {
		return numOferta;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public String getFechaReal() {
		return fechaReal;
	}

	public void setFechaReal(String fechaReal) {
		this.fechaReal = fechaReal;
	}

	public Long getIdTarea() {
		return idTarea;
	}

	public String getVentaDirecta() {
		return ventaDirecta;
	}

	public void setVentaDirecta(String ventaDirecta) {
		this.ventaDirecta = ventaDirecta;
	}

	public String getVentaSuspensiva() {
		return ventaSuspensiva;
	}

	public void setVentaSuspensiva(String ventaSuspensiva) {
		this.ventaSuspensiva = ventaSuspensiva;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
}
