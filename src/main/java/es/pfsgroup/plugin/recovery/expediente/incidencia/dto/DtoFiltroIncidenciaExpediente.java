package es.pfsgroup.plugin.recovery.expediente.incidencia.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class DtoFiltroIncidenciaExpediente extends PaginationParamsImpl {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6416991189101245169L;
	private Long idTipoIncidencia;
	private Long idProveedor;
	private String fechaDesde;
	private String fechaHasta;
	private Long idExpediente;
	private Long idUsuario;

	public Long getIdTipoIncidencia() {
		return idTipoIncidencia;
	}

	public void setIdTipoIncidencia(Long idTipoIncidencia) {
		this.idTipoIncidencia = idTipoIncidencia;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
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

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getIdUsuario() {
		return idUsuario;
	}

	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}

}
