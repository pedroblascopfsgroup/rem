package es.pfsgroup.recovery.ext.impl.bpm.handler.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.ext.api.contrato.EXTContratoApi;
import es.pfsgroup.recovery.ext.api.contrato.model.EXTInfoAdicionalContratoInfo;
import es.pfsgroup.recovery.ext.api.expediente.EXTExpedienteApi;
import es.pfsgroup.recovery.ext.api.itinerario.EXTInfoAdicionalItinerarioApi;
import es.pfsgroup.recovery.ext.api.itinerario.model.EXTDDTipoInfoAdicionalItinerarioInfo;
import es.pfsgroup.recovery.ext.api.itinerario.model.EXTInfoAdicionalItinerarioInfo;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;

class ContratosPersona {

	public class InfoMarcaContrato {
		private Float maxResgo = 0F;
		private Long idContrato = 0L;

		public Float getMaxResgo() {
			return maxResgo;
		}

		public void setMaxResgo(Float maxResgo) {
			this.maxResgo = maxResgo;
		}

		public Long getIdContrato() {
			return idContrato;
		}

		public void setIdContrato(Long idContrato) {
			this.idContrato = idContrato;
		}

	}

	private Cliente cliente;
	private ApiProxyFactory proxyFactory;

	private Map<String, InfoMarcaContrato> marcasContratos;

	public ContratosPersona(BPMParametros parametros,
			ApiProxyFactory proxyFactory) {
		this.cliente = parametros.getCliente();
		this.proxyFactory = proxyFactory;

		String tipo = getMarcaAcumulacionContratos().getValue();

		for (Contrato c : this.cliente.getPersona().getContratos()) {
			if (estaLibre(c)) {
				EXTInfoAdicionalContratoInfo marca = proxyFactory.proxy(
						EXTContratoApi.class).getInfoAdicionalContratoByTipo(
						c.getId(), tipo);
				if (!Checks.esNulo(marca)) {
					addMarcaContrato(marca);
				}
			}
		}
	}

	private boolean estaLibre(Contrato c) {
		if (c == null)
			return false;
		List<? extends Expediente> expedientes = proxyFactory.proxy(
				EXTExpedienteApi.class).buscaExpedientesConContrato(
				c.getId(),
				new String[] { DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO,
						DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO,
						DDEstadoExpediente.ESTADO_EXPEDIENTE_PROPUESTO,
						DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO });
		List<? extends Procedimiento> procedimientos = proxyFactory
				.proxy(EXTProcedimientoApi.class)
				.buscaProcedimientoConContrato(
						c.getId(),
						new String[] {
								DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO,
								DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO,
								DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION,
								DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO,
								DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO });

		return Checks.estaVacio(expedientes)
				&& Checks.estaVacio(procedimientos);
	}

	public boolean hayDiferentesMarcas() {
		if (Checks.estaVacio(marcasContratos)) {
			return false;
		}
		return marcasContratos.keySet().size() > 1;
	}

	public List<Long> getContratosPase() {
		ArrayList<Long> contratos = new ArrayList<Long>();
		if (!Checks.estaVacio(marcasContratos)) {
			for (String marca : marcasContratos.keySet()) {
				contratos.add(marcasContratos.get(marca).getIdContrato());
			}
		}
		return contratos;
	}

	private EXTInfoAdicionalItinerarioInfo getMarcaAcumulacionContratos() {
		EXTInfoAdicionalItinerarioInfo marca = proxyFactory
				.proxy(EXTInfoAdicionalItinerarioApi.class)
				.getInfoAdicionalItinerarioByTipo(
						this.cliente.getArquetipo().getItinerario().getId(),
						EXTDDTipoInfoAdicionalItinerarioInfo.MARCA_ACUMULAR_CONTRATOS);
		return marca;
	}

	private void addMarcaContrato(EXTInfoAdicionalContratoInfo marca) {
		InfoMarcaContrato info = marcasContratos.get(marca.getValue());
		if (info == null) {
			info = new InfoMarcaContrato();
			marcasContratos.put(marca.getValue(), info);
		}
		if (marca.getContrato().getRiesgo() > info.getMaxResgo()) {
			info.setMaxResgo(marca.getContrato().getRiesgo());
			info.setIdContrato(marca.getContrato().getId());
		}
	}
}
