package es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Dto para Procedimientos Derivados.
 *
 * @author Lisandro Medrano
 *
 */
public class MEJDtoBusquedaActas extends WebDto {
	
	private static final long serialVersionUID = 6015680735564006223L;
	
	private Long id;
	private boolean busqueda;
	private Usuario usuarioLogado;
	private Long idComite;
	private String fechaFinDesde;
    private String fechaFinDesdeOperador;
    private String fechaFinHasta;
    private String fechaFinHastaOperador;
    private String fechaInicioDesde;
    private String fechaInicioDesdeOperador;
    private String fechaInicioHasta;
    private String fechaInicioHastaOperador;
   
    public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getFechaFinDesde() {
		return fechaFinDesde;
	}
	public void setFechaFinDesde(String fechaFinDesde) {
		this.fechaFinDesde = fechaFinDesde;
	}
	public String getFechaFinDesdeOperador() {
		return fechaFinDesdeOperador;
	}
	public void setFechaFinDesdeOperador(String fechaFinDesdeOperador) {
		this.fechaFinDesdeOperador = fechaFinDesdeOperador;
	}
	public String getFechaFinHasta() {
		return fechaFinHasta;
	}
	public void setFechaFinHasta(String fechaFinHasta) {
		this.fechaFinHasta = fechaFinHasta;
	}
	public String getFechaFinHastaOperador() {
		return fechaFinHastaOperador;
	}
	public void setFechaFinHastaOperador(String fechaFinHastaOperador) {
		this.fechaFinHastaOperador = fechaFinHastaOperador;
	}
	public String getFechaInicioDesde() {
		return fechaInicioDesde;
	}
	public void setFechaInicioDesde(String fechaInicioDesde) {
		this.fechaInicioDesde = fechaInicioDesde;
	}
	public String getFechaInicioDesdeOperador() {
		return fechaInicioDesdeOperador;
	}
	public void setFechaInicioDesdeOperador(String fechaInicioDesdeOperador) {
		this.fechaInicioDesdeOperador = fechaInicioDesdeOperador;
	}
	public String getFechaInicioHasta() {
		return fechaInicioHasta;
	}
	public void setFechaInicioHasta(String fechaInicioHasta) {
		this.fechaInicioHasta = fechaInicioHasta;
	}
	public String getFechaInicioHastaOperador() {
		return fechaInicioHastaOperador;
	}
	public void setFechaInicioHastaOperador(String fechaInicioHastaOperador) {
		this.fechaInicioHastaOperador = fechaInicioHastaOperador;
	}
	public void setUsuarioLogado(Usuario usuarioLogado) {
		this.usuarioLogado = usuarioLogado;
	}
	public Usuario getUsuarioLogado() {
		return usuarioLogado;
	}
    /**
     * @return the busqueda
     */
    public boolean isBusqueda() {
        return busqueda;
    }

    /**
     * @param busqueda the busqueda to set
     */
    public void setBusqueda(boolean busqueda) {
        this.busqueda = busqueda;
    }
	public void setIdComite(Long idComite) {
		this.idComite = idComite;
	}
	public Long getIdComite() {
		return idComite;
	}
	
}
