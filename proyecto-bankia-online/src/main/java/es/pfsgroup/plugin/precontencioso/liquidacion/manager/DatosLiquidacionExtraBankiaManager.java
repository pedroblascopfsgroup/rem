package es.pfsgroup.plugin.precontencioso.liquidacion.manager;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.precontencioso.liquidacion.api.DatosLiquidacionExtraApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosLiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.RecibosLiqVO;

@Component
public class DatosLiquidacionExtraBankiaManager implements DatosLiquidacionExtraApi {
	
	@Autowired
	private DatosLiquidacionDao datosLiquidacionDao;
	
	@Override
	public List<LiquidacionDTO> agregarDatosExtra(List<LiquidacionDTO> liquidacionesDto) {
		for(int i=0;i<liquidacionesDto.size();i++){
			liquidacionesDto.get(i).setInteresesOrdinarios(this.generarInteresesOrdinariosSum(liquidacionesDto.get(i).getId()));
		}
		return liquidacionesDto;
	}
	
	private BigDecimal generarInteresesOrdinariosSum(Long idLiquidacion) {
		List<RecibosLiqVO> recibosLiq = datosLiquidacionDao.getRecibosLiquidacion(idLiquidacion);
		BigDecimal sumatorioImprtv = BigDecimal.ZERO;
		
		for (RecibosLiqVO recibo : recibosLiq){
			sumatorioImprtv = sumatorioImprtv.add(recibo.getRCB_IMPRTV());
		}
		
		return sumatorioImprtv;
	}

}
