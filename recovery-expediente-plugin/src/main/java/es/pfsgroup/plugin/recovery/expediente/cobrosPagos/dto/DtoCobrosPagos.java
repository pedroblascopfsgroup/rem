package es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.capgemini.pfs.cobropago.model.DDTipoCobroPago;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDOrigenCobro;

public class DtoCobrosPagos extends PaginationParamsImpl {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long idExpediente;
	private Long idCobro;
	private Contrato contrato;
	private Long id;
	private String fechaExtraccion;
	private DDTipoCobroPago tipoCobroPago;
	private DDOrigenCobro origenCobro;
	private Long importe;

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getIdCobro() {
		return idCobro;
	}

	public void setIdCobro(Long idCobro) {
		this.idCobro = idCobro;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getFechaExtraccion() {
		return fechaExtraccion;
	}

	public void setFechaExtraccion(String fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	public DDTipoCobroPago getTipoCobroPago() {
		return tipoCobroPago;
	}

	public void setTipoCobroPago(DDTipoCobroPago tipoCobroPago) {
		this.tipoCobroPago = tipoCobroPago;
	}

	public DDOrigenCobro getOrigenCobro() {
		return origenCobro;
	}

	public void setOrigenCobro(DDOrigenCobro origenCobro) {
		this.origenCobro = origenCobro;
	}

	public Long getImporte() {
		return importe;
	}

	public void setImporte(Long importe) {
		this.importe = importe;
	}

}
