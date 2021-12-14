package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoDatosCatastro;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastroGrid;

public interface CatastroApi {

	DtoDatosCatastro getDatosCatastroRem(Long idActivo);
	
	List<DtoDatosCatastro> getDatosCatastroWs(Long idActivo);

	void eliminarCatastro(Long id);
	
	public List<DtoDatosCatastroGrid> validarCatastro(DtoDatosCatastro dtoCatastroRem,DtoDatosCatastro dtoCatastro);

	void saveCatastro(Long idActivo, List<String> arrayReferencias);
	
}

