package es.pfsgroup.plugin.recovery.liquidaciones.dto;

import org.springframework.binding.message.MessageContext;

import es.capgemini.pfs.cobropago.dto.DtoCobroPago;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;

public class LIQDtoCobroPago extends DtoCobroPago {

	private static final long serialVersionUID = 4789880935076648527L;

	private LIQCobroPago liqCobroPago;

	private Long contrato;
	
	private String origenCobro;
	private String modalidadCobro;

	public void setContrato(Long contrato) {
		this.contrato = contrato;
	}

	public Long getContrato() {
		return contrato;
	}

	public void setLiqCobroPago(LIQCobroPago liqCobroPago) {
		this.liqCobroPago = liqCobroPago;
	}

	public LIQCobroPago getLiqCobroPago() {
		return liqCobroPago;
	}

	/**
	 * Valida el dto para el estado formulario.
	 * 
	 * @param messageContext
	 *            MessageContext
	 */
	@Override
	public void validateFormulario(MessageContext messageContext) {
		messageContext.clearMessages();
		addValidation(liqCobroPago, messageContext, "liqCobroPago")
				.addValidation(this, messageContext).validate();
	}

	public void setOrigenCobro(String origenCobro) {
		this.origenCobro = origenCobro;
	}

	public String getOrigenCobro() {
		return origenCobro;
	}

	public void setModalidadCobro(String modalidadCobro) {
		this.modalidadCobro = modalidadCobro;
	}

	public String getModalidadCobro() {
		return modalidadCobro;
	}

}
