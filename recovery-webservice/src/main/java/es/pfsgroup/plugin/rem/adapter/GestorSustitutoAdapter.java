package es.pfsgroup.plugin.rem.adapter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.api.GestorSustitutoApi;
import es.pfsgroup.plugin.rem.model.DtoGestoresSustitutosFilter;
@Service
public class GestorSustitutoAdapter {

	@Autowired
	private GestorSustitutoApi gestorSustitutoApi;

	public Page getGestoresSustitutos(DtoGestoresSustitutosFilter dtoGestoresSustitutosFiltro) {
		
		return gestorSustitutoApi.getListGestoresSustitutos(dtoGestoresSustitutosFiltro);
	}
	
	@Transactional(readOnly = false)
	public DtoGestoresSustitutosFilter createGestorSustituto(DtoGestoresSustitutosFilter dtoGestoresSustitutosFiltro) {
		
		return gestorSustitutoApi.createGestorSustituto(dtoGestoresSustitutosFiltro);
	}
	
	@Transactional(readOnly = false)
	public boolean deleteGestorSustitutoById(DtoGestoresSustitutosFilter dtoGestoresSustitutosFiltro) {
		
		return gestorSustitutoApi.deleteGestorSustitutoById(dtoGestoresSustitutosFiltro);
	}
}
