package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.*;

public interface DepositoApi {
	
	boolean esNecesarioDeposito(Oferta oferta);

    boolean esNecesarioDepositoBySubcartera(String codSubcartera);

    boolean isDepositoIngresado(Deposito deposito);

	Double getImporteDeposito(Oferta oferta);

	Deposito generaDeposito(Oferta oferta);

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

	Deposito generaDepositoAndIban(Oferta oferta, String iban);

	boolean validarIban(String iban);
	
	boolean esNecesarioDepositoNuevaOferta(Activo ActivoCuentaVirtual);

	CuentasVirtuales vincularCuentaVirtual(String codigoSubTipoOferta);

	void ingresarDeposito(Deposito deposito);

	boolean incautaODevuelveDeposito(Deposito dep, String codDeposito);

	boolean isDepositoDecidido(Deposito deposito);

	List<CuentasVirtualesAlquiler> vincularCuentaVirtualAlquiler(Activo activo, Fianzas fia);

}
