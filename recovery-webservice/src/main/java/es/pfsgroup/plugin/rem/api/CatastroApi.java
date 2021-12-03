package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoDatosCatastro;

public interface CatastroApi {

	DtoDatosCatastro getDatosCatastroRem(Long idActivo);
	
	List<DtoDatosCatastro> getDatosCatastroWs(Long idActivo);
	
}

