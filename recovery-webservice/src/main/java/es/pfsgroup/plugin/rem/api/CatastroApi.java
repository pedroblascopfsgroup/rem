package es.pfsgroup.plugin.rem.api;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoActivoCatastro;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastro;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastroGrid;

public interface CatastroApi {

	DtoDatosCatastro getDatosCatastroRem(Long idActivo);
	
	List<DtoDatosCatastro> getDatosCatastroWs(Long idActivo);

	void eliminarCatastro(Long id);
	
	public List<DtoDatosCatastroGrid> validarCatastro(DtoDatosCatastro dtoCatastroRem,DtoDatosCatastro dtoCatastro);

	void saveCatastro(Long idActivo, List<String> arrayReferencias);

	void validaAsincrono(ArrayList<String> refCatastralList, Long idActivo);
	
	public List<DtoActivoCatastro> getComboReferenciaCatastralByidActivo(Long idActivo);

	public List<DtoActivoCatastro> getGridReferenciaCatastralByidActivo(Long idActivo);

	public List<DtoDatosCatastroGrid> getGridReferenciaCatastralByRefCatastral(String refCatastral, Long idActivo);

	List<DtoDatosCatastroGrid> validarCatastroDatosBásicos(DtoDatosCatastro dtoCatastroRem, DtoDatosCatastro dtoCatastro);

	List<DtoDatosCatastroGrid> validarCatastroDireccion(DtoDatosCatastro dtoCatastroRem, DtoDatosCatastro dtoCatastro);

	void updateCatastro(Long idActivo, String referenciaAnterior, String nuevaReferencia);
	
}

