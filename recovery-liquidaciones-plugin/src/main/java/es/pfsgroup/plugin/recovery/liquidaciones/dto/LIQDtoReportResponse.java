package es.pfsgroup.plugin.recovery.liquidaciones.dto;

import java.util.ArrayList;
import java.util.List;

public class LIQDtoReportResponse {
	
	private LIQDtoLiquidacionCabecera cabecera = new LIQDtoLiquidacionCabecera();
	
	private List<LIQDtoTramoLiquidacion> cuerpo = new ArrayList<LIQDtoTramoLiquidacion>();

	public void setCabecera(LIQDtoLiquidacionCabecera cabecera) {
		this.cabecera = cabecera;
	}

	public LIQDtoLiquidacionCabecera getCabecera() {
		return cabecera;
	}

	public List<LIQDtoTramoLiquidacion> getCuerpo(){
		return cuerpo;
	}
	
	public void addTramoLiquidacion(LIQDtoTramoLiquidacion tramo){
		this.cuerpo.add(tramo);
	}

}
