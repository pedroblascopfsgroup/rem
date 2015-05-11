package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroProcesosFacturacionDto extends WebDto{

	private static final long serialVersionUID = 7707942407367705916L;
	
	private Long id;
	private String nombre;
	private String estadoProcesoFacturable;
	private String fechaInicioDesde;	 
	private String fechaInicioHasta;
	private String fechaFinDesde;	 
	private String fechaFinHasta;
	
	private String fechaDesde;
	private String fechaHasta;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getEstadoProcesoFacturable() {
		return estadoProcesoFacturable;
	}
	public void setEstadoProcesoFacturable(String estadoProcesoFacturable) {
		this.estadoProcesoFacturable = estadoProcesoFacturable;
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
	public String getFechaFinDesde() {
		return fechaFinDesde;
	}
	public void setFechaFinDesde(String fechaFinDesde) {
		this.fechaFinDesde = fechaFinDesde;
	}
	public String getFechaFinHasta() {
		return fechaFinHasta;
	}
	public void setFechaFinHasta(String fechaFinHasta) {
		this.fechaFinHasta = fechaFinHasta;
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
}
