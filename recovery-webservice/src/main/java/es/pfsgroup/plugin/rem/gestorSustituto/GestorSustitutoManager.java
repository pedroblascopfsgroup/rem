package es.pfsgroup.plugin.rem.gestorSustituto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.GestorSustitutoApi;
import es.pfsgroup.plugin.rem.gestorSustituto.dao.GestorSustitutoDao;
import es.pfsgroup.plugin.rem.model.DtoGestoresSustitutosFilter;
import es.pfsgroup.plugin.rem.model.GestorSustituto;

@Service("gestorSustitutoManager")
public class GestorSustitutoManager extends BusinessOperationOverrider<GestorSustitutoApi> implements GestorSustitutoApi {
	
	@Autowired
	private GestorSustitutoDao gestorSustitutoDao;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Override
	public Page getListGestoresSustitutos(DtoGestoresSustitutosFilter dto) {
		return gestorSustitutoDao.getListGestoresSustitutos(dto);
	}

	@Override
	public String managerName() {
		return "gestorSustitutoManager";
	}

	@Override
	public DtoGestoresSustitutosFilter createGestorSustituto(DtoGestoresSustitutosFilter dto) {
		
		GestorSustituto gs = new GestorSustituto();
		if(!Checks.esNulo(dto.getUsernameOrigen())) {
			gs.setUsuarioGestorOriginal(usuarioManager.getByUsername(dto.getUsernameOrigen()));
		}
		if(!Checks.esNulo(dto.getUsernameSustituto())) {
			gs.setUsuarioGestorSustituto(usuarioManager.getByUsername(dto.getUsernameSustituto()));
		}
		if(!Checks.esNulo(dto.getFechaInicio())) {
			gs.setFechaInicio(dto.getFechaInicio());
		}
		if(!Checks.esNulo(dto.getFechaFin())) {
			gs.setFechaFin(dto.getFechaFin());
		}
		gestorSustitutoDao.save(gs);
		return dto;
	}

	@Override
	public boolean deleteGestorSustitutoById(DtoGestoresSustitutosFilter dto) {
		boolean result = false;
		gestorSustitutoDao.deleteById(Long.valueOf(dto.getId()));
		result = true;
		return result;
	}
	
}
