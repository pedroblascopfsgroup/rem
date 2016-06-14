package es.pfsgroup.plugin.precontencioso.tipoProdPlantilla.manager;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.contrato.model.DDAplicativoOrigen;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.tipoProdPlantilla.api.TipoProductoPlantillaApi;
import es.pfsgroup.plugin.precontencioso.tipoProdPlantilla.model.TipoProductoPlantilla;

@Service("tipoProductoPlantillaApi")
public class TipoProductoPlantillaManager implements TipoProductoPlantillaApi {

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public List<DDTipoLiquidacionPCO> dameValoresPosiblesTipoLiquidacion(
			DDAplicativoOrigen aplicativoOrigen) {
		
		List<DDTipoLiquidacionPCO> resultado = new ArrayList<DDTipoLiquidacionPCO>();
		
		List<TipoProductoPlantilla> listaMapeos = genericDao.getList(TipoProductoPlantilla.class, 
				genericDao.createFilter(FilterType.EQUALS, "aplicativoOrigen.id", aplicativoOrigen.getId()));
		for (TipoProductoPlantilla tipoProductoPlantilla : listaMapeos) {
			DDTipoLiquidacionPCO tipoLiq = tipoProductoPlantilla.getTipoLiquidacion();
			if (!Checks.esNulo(tipoLiq)) {
				resultado.add(tipoLiq);
			}
		}
		return resultado;
	}

	@Override
	public List<DDTipoBurofaxPCO> dameValoresPosiblesTipoBurofax(
			DDAplicativoOrigen aplicativoOrigen) {
		
		List<DDTipoBurofaxPCO> resultado = new ArrayList<DDTipoBurofaxPCO>();
		
		List<TipoProductoPlantilla> listaMapeos = genericDao.getList(TipoProductoPlantilla.class, 
				genericDao.createFilter(FilterType.EQUALS, "aplicativoOrigen.id", aplicativoOrigen.getId()));
		for (TipoProductoPlantilla tipoProductoPlantilla : listaMapeos) {
			DDTipoBurofaxPCO tipoBur = tipoProductoPlantilla.getTipoBurofax();
			if (!Checks.esNulo(tipoBur)) {
				resultado.add(tipoBur);
			}
		}
		return resultado;
	}

}
