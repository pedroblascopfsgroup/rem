package es.pfsgroup.recovery.ext.turnadodespachos;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Service
public class TurnadoDespachosManagerImpl implements TurnadoDespachosManager {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private UtilDiccionarioApi dictApi;
	
    @Autowired
    private UsuarioManager usuarioManager;

	@Autowired
	private EsquemaTurnadoDao esquemaTurnadoDao;

    @Autowired
    private GenericABMDao genericDao;
	
	@Override
	public Page listaEsquemasTurnado(EsquemaTurnadoBusquedaDto dto) {
		Usuario usuarioLogado = usuarioManager.getUsuarioLogado();
		Page page = esquemaTurnadoDao.buscarEsquemasTurnado(dto, usuarioLogado);
		return page;
	}

	@Override
	public EsquemaTurnado get(Long id) {
		return esquemaTurnadoDao.get(id);
	}

	@Override
	@Transactional
	public EsquemaTurnado save(EsquemaTurnadoDto dto) {

		EsquemaTurnado esquema = null;	
		if (dto.getId()!=null) {
			esquema = get(dto.getId());
		} else {
			esquema = new EsquemaTurnado();
			DDEstadoEsquemaTurnado estado = (DDEstadoEsquemaTurnado)dictApi
					.dameValorDiccionarioByCod(DDEstadoEsquemaTurnado.class, DDEstadoEsquemaTurnado.ESTADO_DEFINICION);
			esquema.setEstado(estado);
		}

		esquema.setDescripcion(dto.getDescripcion());
		esquema.setLimiteStockAnualConcursos(dto.getLimiteStockConcursos());
		esquema.setLimiteStockAnualLitigios(dto.getLimiteStockLitigios());

		esquemaTurnadoDao.saveOrUpdate(esquema);
		
		logger.debug("Elimina configuración actual enviada para edición...");
		Set<Long> idsActualesConfig = new HashSet<Long>();
		for (EsquemaTurnadoConfigDto dtoConfig : dto.getLineasConfiguracion()) {
			if (dtoConfig.getId()!=null) {
				idsActualesConfig.add(dtoConfig.getId());
			}
		}
		
		logger.debug("Se detectan la configuraciones de esquema que se han de eliminar...");
		List<EsquemaTurnadoConfig> configList = esquema.getConfiguracion();
		if (configList!=null) {
			for (int i=configList.size()-1;i>=0;i--) {
				EsquemaTurnadoConfig config = configList.get(i);
				if (idsActualesConfig.contains(config.getId())) {
					continue;
				}
				esquema.getConfiguracion().remove(config);
				genericDao.deleteById(EsquemaTurnadoConfig.class, config.getId());
			}
		}
		
		logger.debug("Se insertan las configuraciones de esquema actuales...");
		for (EsquemaTurnadoConfigDto dtoConfig : dto.getLineasConfiguracion()) {
			if (dtoConfig.getId()!=null) {
				continue;
			}
			// insert
			EsquemaTurnadoConfig config = new EsquemaTurnadoConfig();
			config.setTipo(dtoConfig.getTipo());
			config.setEsquema(esquema);
			config.setCodigo(dtoConfig.getCodigo());
			config.setImporteDesde(dtoConfig.getImporteDesde());
			config.setImporteHasta(dtoConfig.getImporteHasta());
			config.setPorcentaje(dtoConfig.getPorcentaje());
			genericDao.save(EsquemaTurnadoConfig.class, config);
		}
		
		logger.debug("Se actualizan la configuraciones de esquema actuales...");
		for (EsquemaTurnadoConfigDto dtoConfig : dto.getLineasConfiguracion()) {
			if (dtoConfig.getId()==null) {
				continue;
			}
			EsquemaTurnadoConfig config = esquema.getConfigById(dtoConfig.getId());
			config.setCodigo(dtoConfig.getCodigo());
			config.setImporteDesde(dtoConfig.getImporteDesde());
			config.setImporteHasta(dtoConfig.getImporteHasta());
			config.setPorcentaje(dtoConfig.getPorcentaje());
			genericDao.save(EsquemaTurnadoConfig.class, config);
		}
		
		esquema = esquemaTurnadoDao.get(esquema.getId());
		return esquema;
	}


	@Override
	@Transactional
	public void activarEsquema(Long idEsquema) throws ActivarEsquemaDeTurnadoException {
		// TODO Auto-generated method stub

	}

	@Override
	@Transactional
	public void turnar(Long idAsunto) throws AplicarTurnadoException {
		// TODO Auto-generated method stub

	}

	@Override
	public EsquemaTurnado getEsquemaVigente() {
		EsquemaTurnado esquemaTurnado = esquemaTurnadoDao.getEsquemaVigente();
		return esquemaTurnado;
	}

	@Override
	public void delete(Long id) {
		EsquemaTurnado esquema = get(id);
		esquemaTurnadoDao.delete(esquema);
	}

	@Override
	public void copy(Long id) {
		EsquemaTurnado esquema = get(id);
		EsquemaTurnadoDto dto = new EsquemaTurnadoDto();
		dto.setDescripcion(esquema.getDescripcion());
		dto.setLimiteStockConcursos(esquema.getLimiteStockAnualConcursos());
		dto.setLimiteStockLitigios(esquema.getLimiteStockAnualLitigios());
		if (esquema.getConfiguracion()!=null) {
			for (EsquemaTurnadoConfig config : esquema.getConfiguracion()) {
				EsquemaTurnadoConfigDto configDto = new EsquemaTurnadoConfigDto();
				configDto.setTipo(config.getTipo());
				configDto.setCodigo(config.getCodigo());
				configDto.setImporteDesde(config.getImporteDesde());
				configDto.setImporteHasta(config.getImporteHasta());
			}
		}
		this.save(dto);
	}

	@Override
	public boolean isModificable(EsquemaTurnado esquema) {
		Usuario usuarioLogado = usuarioManager.getUsuarioLogado();
		boolean modoConsulta = esquema.getId()!=null && 
				(esquema.getEstado().getCodigo().equals(DDEstadoEsquemaTurnado.ESTADO_TERMINADO) ||
				esquema.getAuditoria().getUsuarioCrear()==usuarioLogado.getUsername());
		return modoConsulta;
	}

}
