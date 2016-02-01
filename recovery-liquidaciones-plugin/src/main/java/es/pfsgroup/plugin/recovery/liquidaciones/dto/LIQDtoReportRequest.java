package es.pfsgroup.plugin.recovery.liquidaciones.dto;

import java.text.ParseException;
import java.util.Date;

import javax.validation.constraints.NotNull;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.DateFormat;

public class LIQDtoReportRequest extends WebDto {

	private static final long serialVersionUID = -6715794663560594941L;

	@NotNull(message = "plugin.liquidaciones.reportrequest.message.actuacion.null")
	private Long actuacion;

	@NotNull(message = "plugin.liquidaciones.reportrequest.message.contrato.null")
	private Long contrato;

	@NotNull(message = "plugin.liquidaciones.reportrequest.message.fechacierre.null")
	private String fechaCierre;

	@NotNull(message = "plugin.liquidaciones.reportrequest.message.intereses.null")
	private Float intereses;
	
	@NotNull(message = "plugin.liquidaciones.reportrequest.message.principal.null")
	private Float principal;
	
	@NotNull(message = "plugin.liquidaciones.reportrequest.message.nombre.null")
	private String nombre;
	
	@NotNull(message = "plugin.liquidaciones.reportrequest.message.dni.null")
	private String dni;
	
	@NotNull(message = "plugin.liquidaciones.reportrequest.message.fechaliquidacion.null")
	private String fechaLiquidacion;
	

	public Long getActuacion() {
		return actuacion;
	}

	public void setActuacion(Long actuacion) {
		this.actuacion = actuacion;
	}

	public Long getContrato() {
		return contrato;
	}

	public void setContrato(Long contrato) {
		this.contrato = contrato;
	}

	public String getFechaCierre() {
		return fechaCierre;
	}

	public void setFechaCierre(String fechaCierre) {
		this.fechaCierre = fechaCierre;
	}

	public Float getIntereses() {
		return intereses;
	}

	public void setIntereses(Float intereses) {
		this.intereses = intereses;
	}

	public void setPrincipal(Float principal) {
		this.principal = principal;
	}

	public Float getPrincipal() {
		return principal;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombre() {
		return nombre;
	}

	public void setDni(String dni) {
		this.dni = dni;
	}

	public String getDni() {
		return dni;
	}

	public void setFechaLiquidacion(String fechaLiquidacion) {
		this.fechaLiquidacion = fechaLiquidacion;
	}

	public String getFechaLiquidacion() {
		return fechaLiquidacion;
	}

}
