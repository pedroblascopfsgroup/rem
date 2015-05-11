package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroAccionesExtrajudiciales;

public class RecobroAccionAgenciaDto extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2498327979612106085L;
	
	
	private RecobroAccionesExtrajudiciales accion;
	private String agencia;
	
	
	public RecobroAccionesExtrajudiciales getAccion() {
		return accion;
	}
	public void setAccion(RecobroAccionesExtrajudiciales accion) {
		this.accion = accion;
	}
	public String getAgencia() {
		return agencia;
	}
	public void setAgencia(String agencia) {
		this.agencia = agencia;
	}

}
