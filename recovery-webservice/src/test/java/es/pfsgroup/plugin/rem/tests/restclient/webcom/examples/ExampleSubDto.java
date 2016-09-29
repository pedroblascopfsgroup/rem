package es.pfsgroup.plugin.rem.tests.restclient.webcom.examples;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

/**
 * Este es un SubDto (se supone que siempre vendrá anidado en uno principal) de ejemplo para usarlo durante los tests
 * @author bruno
 *
 */
public class ExampleSubDto{

	@WebcomRequired
	private StringDataType campoObligatorio;
	
	
	private StringDataType campoOpcional;


	public StringDataType getCampoObligatorio() {
		return campoObligatorio;
	}


	public void setCampoObligatorio(StringDataType campoObligatorio) {
		this.campoObligatorio = campoObligatorio;
	}


	public StringDataType getCampoOpcional() {
		return campoOpcional;
	}


	public void setCampoOpcional(StringDataType campoOpcional) {
		this.campoOpcional = campoOpcional;
	}
	
}
