package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoDatosCatastro;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastroGrid;

public interface CatastroApi {

	DtoDatosCatastro getDatosCatastroRem(Long idActivo);
	
	public List<DtoDatosCatastroGrid> validarCatastro(DtoDatosCatastro dtoCatastroRem,DtoDatosCatastro dtoCatastro);
	
}

