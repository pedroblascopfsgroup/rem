package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.CuentasVirtuales;
import es.pfsgroup.plugin.rem.model.Deposito;
import es.pfsgroup.plugin.rem.model.DtoDeposito;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GeneraDepositoDto;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface DepositoApi {
	
	boolean esNecesarioDeposito(Oferta oferta);

	boolean isDepositoIngresado(Deposito deposito);

	CuentasVirtuales vincularCuentaVirtual(Oferta oferta);

	Double getImporteDeposito(Oferta oferta);

    void generaDeposito(Oferta oferta);

    Boolean generaDepositoFromRem3(GeneraDepositoDto dto);
	
	void modificarEstadoDepositoSiIngresado(Oferta oferta);

    Deposito getDepositoByNumOferta(Long numOferta);

	boolean cambiaEstadoDeposito(Deposito dep, String codDeposito);

	DtoDeposito expedienteToDtoDeposito(ExpedienteComercial expediente);

	boolean esOfertaConDeposito(Oferta oferta);

	boolean esUsuarioCrearOfertaDepositoExterno(Oferta oferta);

	/**
	 * Modifica los datos del depósito
	 *
	 * @param dto
	 * @param idEntidad
	 * @return
	 */
	boolean saveDeposito(DtoDeposito dto, Long idExpediente);
}
