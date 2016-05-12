package es.pfsgroup.plugin.recovery.liquidaciones.api;

import java.util.Map;


public class LiquidacionesProjectContextImpl implements LiquidacionesProjectContext {
	private Map<String, String> codigosSubTarea;
	private Map<String, Long> plazoTarea;

	@Override
	public void setCodigosSubTarea(Map<String, String> codigosSubTarea) {
		this.codigosSubTarea = codigosSubTarea;
	}

	@Override
	public Map<String, String> getCodigosSubTarea() {
		
		return this.codigosSubTarea;
	}

	@Override
	public Map<String, Long> getPlazoTarea() {
		return this.plazoTarea;
	}

	@Override
	public void setPlazoTarea(Map<String, Long> plazoTarea) {
		this.plazoTarea = plazoTarea;
	}
	
}
