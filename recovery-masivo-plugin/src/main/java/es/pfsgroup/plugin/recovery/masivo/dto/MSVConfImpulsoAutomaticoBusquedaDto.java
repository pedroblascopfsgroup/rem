package es.pfsgroup.plugin.recovery.masivo.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * DTO que servirá para realizar las búsquedas que contendrá estos atributos
 * y otras transferencias de información
 * 
 * @author pedro
 *
 */
public class MSVConfImpulsoAutomaticoBusquedaDto extends WebDto {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6366484680831534647L;
	private Long id;
	private Long filtroTipoJuicio;
	private Long filtroTareaProcedimiento;
	private String filtroConProcurador;
	private Long filtroDespacho;
	private String filtroCartera;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getFiltroTipoJuicio() {
		return filtroTipoJuicio;
	}
	public void setFiltroTipoJuicio(Long filtroTipoJuicio) {
		this.filtroTipoJuicio = filtroTipoJuicio;
	}
	public Long getFiltroTareaProcedimiento() {
		return filtroTareaProcedimiento;
	}
	public void setFiltroTareaProcedimiento(Long filtroTareaProcedimiento) {
		this.filtroTareaProcedimiento = filtroTareaProcedimiento;
	}
	public String getFiltroConProcurador() {
		return filtroConProcurador;
	}
	public void setFiltroConProcurador(String filtroConProcurador) {
		this.filtroConProcurador = filtroConProcurador;
	}
	public Long getFiltroDespacho() {
		return filtroDespacho;
	}
	public void setFiltroDespacho(Long filtroDespacho) {
		this.filtroDespacho = filtroDespacho;
	}
	
	
	public MSVConfImpulsoAutomaticoBusquedaDto() {
		super();
	}
	
	public MSVConfImpulsoAutomaticoBusquedaDto(Long filtroTipoJuicio,
			Long filtroTareaProcedimiento, String filtroConProcurador,
			Long filtroDespacho, String filtroCartera) {
		super();
		this.filtroTipoJuicio = filtroTipoJuicio;
		this.filtroTareaProcedimiento = filtroTareaProcedimiento;
		this.filtroConProcurador = filtroConProcurador;
		this.filtroDespacho = filtroDespacho;
		this.filtroCartera = filtroCartera;
	}
	
	public String getFiltroCartera() {
		return filtroCartera;
	}
	public void setFiltroCartera(String filtroCartera) {
		this.filtroCartera = filtroCartera;
	}

}
