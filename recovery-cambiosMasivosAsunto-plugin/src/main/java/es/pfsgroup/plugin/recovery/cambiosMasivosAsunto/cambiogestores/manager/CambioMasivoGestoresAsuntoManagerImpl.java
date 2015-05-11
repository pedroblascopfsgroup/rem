package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.CambiosMasivosAsuntoPluginConfig;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.PeticionCambioMasivoGestoresDto;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.CambioMasivoGestoresAsuntoDao;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.CambioMasivoGestoresAsuntoGenericDaoFacade;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.CambioMasivoGestoresAsuntoGestorDespachoDao;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dto.PeticionCambioMasivoGestoresDtoImpl;

/**
 * Implementación de las operaciones de negocio para el cambio masivo de
 * gestores del asunto
 * 
 * @author bruno
 * 
 */
@Component
public class CambioMasivoGestoresAsuntoManagerImpl implements CambioMasivoGestoresAsuntoApi {

	@Autowired
	private CambioMasivoGestoresAsuntoDao dao;
	
	@Autowired
	private CambioMasivoGestoresAsuntoGenericDaoFacade genericFacade;
	
	@Autowired
	private CambiosMasivosAsuntoPluginConfig pluginConfig;

	@Autowired
	private CambioMasivoGestoresAsuntoGestorDespachoDao gestorDespachoDao;

	@Override
	@BusinessOperation(CAMBIO_MASIVO_GESTORES_ANOTAR_CAMBIOS)
	public void anotarCambiosPendientes(PeticionCambioMasivoGestoresDto dto) {
		if (dto == null) {
			throw new IllegalArgumentException("dto no puede ser null");
		}

		dao.insertDirectoPeticiones(dto.getSolicitante(), dto.getTipoGestor(), dto.getIdGestorOriginal(), dto.getIdNuevoGestor(), dto.getFechaInicio(), dto.getFechaFin());
	}

	@Override
	@BusinessOperation(CAMBIO_MASIVO_GESTORES_COMPROBAR_CAMBIOS)
	public int comprobarCambiosPendientes(PeticionCambioMasivoGestoresDtoImpl dto) {
		if (dto == null) {
			throw new IllegalArgumentException("dto no puede ser null");
		}

		int count = dao.contarPeticiones(dto.getSolicitante(), dto.getTipoGestor(), dto.getIdGestorOriginal(), dto.getIdNuevoGestor(), dto.getFechaInicio(), dto.getFechaFin());
		return count;
	}

	@Override
	@BusinessOperation(CAMBIO_MASIVO_GESTORES_GET_TIPOS_GESTOR)
	public List<EXTDDTipoGestor> getTiposGestor() {
		return genericFacade.getTiposGestor(pluginConfig);
	}

	@Override
	@BusinessOperation(CAMBIO_MASIVO_GESTORES_GET_GESTORES)
	public List<GestorDespacho> buscaGestoresByDespachoTipoGestor(Long despacho, Long tipoGestor) {
		return gestorDespachoDao.buscaGestoresByDespachoTipoGestor(despacho, tipoGestor, (tipoGestor != null));
	}

	@Override
	@BusinessOperation(CAMBIO_MASIVO_GESTORES_GET_TODOS_DESPACHOS)
	public List<DespachoExterno> getTodosLosDespachos() {
		return genericFacade.getTodosLosDespachos();
	}
}
