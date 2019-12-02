package es.pfsgroup.plugin.rem.gestorSustituto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.GestorSustitutoApi;
import es.pfsgroup.plugin.rem.gestorSustituto.dao.GestorSustitutoDao;
import es.pfsgroup.plugin.rem.model.DtoGestoresSustitutosFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaGestoresSustitutos;

@Service("gestorSustitutoManager")
public class GestorSustitutoManager extends BusinessOperationOverrider<GestorSustitutoApi> implements GestorSustitutoApi {
	
	@Autowired
	private GestorSustitutoDao gestorSustitutoDao;

	@Override
	public Page getPageGestoresSustitutos(DtoGestoresSustitutosFilter dto) {
		return gestorSustitutoDao.getPageGestoresSustitutos(dto);
	}

	@Override
	public String managerName() {
		return "gestorSustitutoManager";
	}

	@Override
	public String createGestorSustituto(DtoGestoresSustitutosFilter dto) {
		dto.setAccion("ALTA");
		return gestorSustitutoDao.accionGestoresSustitutos(dto);		
	}

	@Override
	public void deleteGestorSustitutoById(DtoGestoresSustitutosFilter dto) {
		gestorSustitutoDao.deleteById(Long.valueOf(dto.getId()));		
	}
	
}
