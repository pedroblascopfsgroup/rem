package es.pfsgroup.plugin.precontencioso.tipoProdPlantilla.api;

import java.util.List;

import es.capgemini.pfs.contrato.model.DDAplicativoOrigen;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;

public interface TipoProductoPlantillaApi {

	List<DDTipoLiquidacionPCO> dameValoresPosiblesTipoLiquidacion(DDAplicativoOrigen aplicativoOrigen);
	
	List<DDTipoBurofaxPCO> dameValoresPosiblesTipoBurofax(DDAplicativoOrigen aplicativoOrigen);
	
}
