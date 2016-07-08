package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de tareas
 * @author Daniel Gutiérrez
 *
 */
public class DtoTareaFilter extends WebDto {

	private static final long serialVersionUID = 0L;
	private String numActivo;	
	private String numActivoRem;	
	private String nombreTarea;
	private String descripcionTarea;	
	private String fechaInicioDesde;	
	private String fechaInicioHasta;	
	private String fechaVencimientoDesde;	
	private String fechaVencimientoHasta;
	private String codigoTipoTarea;
	private String codigoSubtipoTarea;
	private Boolean esAlerta; 
	
	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getNumActivoRem() {
		return numActivoRem;
	}

	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}

	public String getNombreTarea() {
		return nombreTarea;
	}
	
	public void setNombreTarea(String nombreTarea) {
		this.nombreTarea = nombreTarea;
	}
	
	public String getDescripcionTarea() {
		return descripcionTarea;
	}

	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}

	public String getFechaInicioDesde() {
		return fechaInicioDesde;
	}

	public void setFechaInicioDesde(String fechaInicioDesde) {
		this.fechaInicioDesde = fechaInicioDesde;
	}

	public String getFechaInicioHasta() {
		return fechaInicioHasta;
	}

	public void setFechaInicioHasta(String fechaInicioHasta) {
		this.fechaInicioHasta = fechaInicioHasta;
	}

	public String getFechaVencimientoDesde() {
		return fechaVencimientoDesde;
	}

	public void setFechaVencimientoDesde(String fechaVencimientoDesde) {
		this.fechaVencimientoDesde = fechaVencimientoDesde;
	}

	public String getFechaVencimientoHasta() {
		return fechaVencimientoHasta;
	}

	public void setFechaVencimientoHasta(String fechaVencimientoHasta) {
		this.fechaVencimientoHasta = fechaVencimientoHasta;
	}

	public String getCodigoTipoTarea() {
		return codigoTipoTarea;
	}

	public void setCodigoTipoTarea(String codigoTipoTarea) {
		this.codigoTipoTarea = codigoTipoTarea;
	}

	public String getCodigoSubtipoTarea() {
		return codigoSubtipoTarea;
	}

	public void setCodigoSubtipoTarea(String codigoSubtipoTarea) {
		this.codigoSubtipoTarea = codigoSubtipoTarea;
	}

	public Boolean getEsAlerta() {
		return esAlerta;
	}

	public void setEsAlerta(Boolean esAlerta) {
		this.esAlerta = esAlerta;
	}
	
}