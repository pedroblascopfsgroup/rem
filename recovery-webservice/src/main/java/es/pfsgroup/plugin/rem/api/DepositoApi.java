package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.Deposito;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface DepositoApi {
	
	boolean esNecesarioDeposito(Oferta oferta);

	boolean isDepositoIngresado(Deposito deposito);

}
