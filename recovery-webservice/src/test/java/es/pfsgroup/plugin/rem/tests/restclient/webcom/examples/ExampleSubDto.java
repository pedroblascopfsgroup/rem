package es.pfsgroup.plugin.rem.tests.restclient.webcom.examples;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

/**
 * Este es un SubDto (se supone que siempre vendrá anidado en uno principal) de ejemplo para usarlo durante los tests
 * @author bruno
 *
 */
public class ExampleSubDto{
	
	public static final String SHORT_COLUMN_NAME = "SHORT_COLUMN";

	@WebcomRequired
	private StringDataType campoObligatorio;
	
	
	private StringDataType campoOpcional;
	
	@MappedColumn(SHORT_COLUMN_NAME)
	private LongDataType esteEsOtroCampoLargoQueNoSeDeberiaMapearTalcual;


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


	public LongDataType getEsteEsOtroCampoLargoQueNoSeDeberiaMapearTalcual() {
		return esteEsOtroCampoLargoQueNoSeDeberiaMapearTalcual;
	}


	public void setEsteEsOtroCampoLargoQueNoSeDeberiaMapearTalcual(
			LongDataType esteEsOtroCampoLargoQueNoSeDeberiaMapearTalcual) {
		this.esteEsOtroCampoLargoQueNoSeDeberiaMapearTalcual = esteEsOtroCampoLargoQueNoSeDeberiaMapearTalcual;
	}
	
}
