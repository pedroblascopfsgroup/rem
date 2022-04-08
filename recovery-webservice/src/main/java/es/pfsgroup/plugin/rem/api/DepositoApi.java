package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.CuentasVirtuales;
import es.pfsgroup.plugin.rem.model.Deposito;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface DepositoApi {
	
	boolean esNecesarioDeposito(Oferta oferta);

	boolean isDepositoIngresado(Deposito deposito);

	CuentasVirtuales vincularCuentaVirtual(Oferta oferta);

	Double getImporteDeposito(Oferta oferta);

    void generaDeposito(Oferta oferta);
}
