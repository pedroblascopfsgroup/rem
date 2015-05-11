package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto;

import java.io.Serializable;

public class MSVTipoInputAccionDto implements Serializable {
	
	private static final long serialVersionUID = 3173507841222588523L;

	private String codigoTipoInput;
	
	private String codigoTipoAccion;

	public String getCodigoTipoInput() {
		return codigoTipoInput;
	}

	public void setCodigoTipoInput(String codigoTipoInput) {
		this.codigoTipoInput = codigoTipoInput;
	}

	public String getCodigoTipoAccion() {
		return codigoTipoAccion;
	}

	public void setCodigoTipoAccion(String codigoTipoAccion) {
		this.codigoTipoAccion = codigoTipoAccion;
	}

}
