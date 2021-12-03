package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.DtoDatosCatastro;

public interface CatastroApi {

	DtoDatosCatastro getDatosCatastroRem(Long idActivo);
	
}

