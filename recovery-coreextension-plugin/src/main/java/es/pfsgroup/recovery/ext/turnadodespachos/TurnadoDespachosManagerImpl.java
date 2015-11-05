package es.pfsgroup.recovery.ext.turnadodespachos;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
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
	private DespachoExternoDao despachoExternoDao;
	
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

		logger.debug("Guarda el esquema...");
		esquemaTurnadoDao.saveOrUpdate(esquema);
		
		if (esquema.getConfiguracion()!=null && esquema.getConfiguracion().size()>0) {
			logger.debug("Elimina las configuraciones no existenes en el nuevo esquema...");
			Set<Long> idsExistentes = new HashSet<Long>();
			for (EsquemaTurnadoConfigDto dtoConfig : dto.getLineasConfiguracion()) {
				if (dtoConfig.getId()==null) {
					continue;
				}
				idsExistentes.add(dtoConfig.getId());
			}
			for (EsquemaTurnadoConfig config : esquema.getConfiguracion()) {
				if (idsExistentes.contains(config.getId())) {
					continue;
				}
				genericDao.deleteById(EsquemaTurnadoConfig.class, config.getId());
			}
			HibernateUtils.flush();
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
	public void activarEsquema(Long idEsquema) {
		EsquemaTurnado esquema = this.get(idEsquema);
		EsquemaTurnado esquemaVigente = null;
		
		DDEstadoEsquemaTurnado estadoTerminado = (DDEstadoEsquemaTurnado)dictApi
				.dameValorDiccionarioByCod(DDEstadoEsquemaTurnado.class, DDEstadoEsquemaTurnado.ESTADO_TERMINADO);
		DDEstadoEsquemaTurnado estadoVigente = (DDEstadoEsquemaTurnado)dictApi
				.dameValorDiccionarioByCod(DDEstadoEsquemaTurnado.class, DDEstadoEsquemaTurnado.ESTADO_VIGENTE);
		
		Date fechaVigencia = new Date();
		try {
			esquemaVigente = this.getEsquemaVigente();
			esquemaVigente.setFechaFinVigencia(fechaVigencia);
			esquemaVigente.setEstado(estadoTerminado);
			esquemaTurnadoDao.save(esquemaVigente);
		} catch (IllegalArgumentException iae) {
			logger.info(String.format("No existe esquema vigente previo, se va a activar el primer esquema!", esquema.getDescripcion()));
		} finally {
			esquema.setFechaInicioVigencia(fechaVigencia);
			esquema.setEstado(estadoVigente);
			esquemaTurnadoDao.save(esquema);
		}
	}

	@Override
	@Transactional
	public void turnar(Long idAsunto, String username, String codigoGestor) throws IllegalArgumentException, AplicarTurnadoException {
		try {
			this.getEsquemaVigente();
			esquemaTurnadoDao.turnar(idAsunto, username, codigoGestor);
		} catch(IllegalArgumentException iae) {
			logger.error(iae);
			throw iae;
		} catch(Exception e) {
			String msg = "No se ha podido realizar el turnado.";
			logger.error(msg);
			throw new AplicarTurnadoException(msg, e);
		}
	}

	@Override
	public EsquemaTurnado getEsquemaVigente() {
		EsquemaTurnado esquemaTurnado = esquemaTurnadoDao.getEsquemaVigente();
		return esquemaTurnado;
	}

	@Override
	@Transactional
	public void delete(Long id) {
		EsquemaTurnado esquema = get(id);
		esquemaTurnadoDao.delete(esquema);
		if (esquema.getConfiguracion()!=null) {
			for (EsquemaTurnadoConfig config : esquema.getConfiguracion()) {
				genericDao.deleteById(EsquemaTurnadoConfig.class, config.getId());
			}
		}
	}

	@Override
	@Transactional
	public void copy(Long id) {
		EsquemaTurnado esquema = get(id);
		EsquemaTurnadoDto dto = new EsquemaTurnadoDto();
		dto.setDescripcion("Copia de " + esquema.getDescripcion());
		dto.setLimiteStockConcursos(esquema.getLimiteStockAnualConcursos());
		dto.setLimiteStockLitigios(esquema.getLimiteStockAnualLitigios());
		if (esquema.getConfiguracion()!=null) {
			for (EsquemaTurnadoConfig config : esquema.getConfiguracion()) {
				EsquemaTurnadoConfigDto configDto = new EsquemaTurnadoConfigDto();
				configDto.setTipo(config.getTipo());
				configDto.setCodigo(config.getCodigo());
				configDto.setImporteDesde(config.getImporteDesde());
				configDto.setImporteHasta(config.getImporteHasta());
				configDto.setPorcentaje(config.getPorcentaje());
				dto.getLineasConfiguracion().add(configDto);
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

	@Override
	public boolean checkActivarEsquema(Long id) {
		EsquemaTurnado esquema = this.get(id);
		EsquemaTurnado esquemaVigente = null;
		try {
			esquemaVigente = this.getEsquemaVigente();
		} catch (IllegalArgumentException iae) {
			logger.info(String.format("No existe esquema previo, activando esquema [%s]", esquema.getDescripcion()));
			return true;
		}
		
		// No se puede activar un esquema sin configuración
		if (esquema.getConfiguracion()==null) {
			logger.warn(String.format("No se puede activar el esquema [%d][%s] porque no tiene configuración", id, esquema.getDescripcion()));
			return false;
		}

		List<String> codigosCI = new ArrayList<String>();
		List<String> codigosCC = new ArrayList<String>();
		List<String> codigosLI = new ArrayList<String>();
		List<String> codigosLC = new ArrayList<String>();

		// Recupera las configuraciones que desaparecen en el nuevo esquema.
		for (EsquemaTurnadoConfig config : esquemaVigente.getConfiguracion()) {
			if (esquema.contains(config)) {
				continue;
			}
			if (config.getTipo().equals(EsquemaTurnadoConfig.TIPO_CONCURSAL_IMPORTE)) {
				codigosCI.add(config.getCodigo());
			} else if (config.getTipo().equals(EsquemaTurnadoConfig.TIPO_CONCURSAL_CALIDAD)) {
				codigosCC.add(config.getCodigo());
			} else if (config.getTipo().equals(EsquemaTurnadoConfig.TIPO_LITIGIOS_IMPORTE)) {
				codigosLI.add(config.getCodigo());
			} else if (config.getTipo().equals(EsquemaTurnadoConfig.TIPO_LITIGIOS_CALIDAD)) {
				codigosLC.add(config.getCodigo());
			}
		}
		
		int total = esquemaTurnadoDao.cuentaLetradosAsignados(codigosCI, codigosCC, codigosLI, codigosLC);
		
		return (total==0);
	}

	@Override
	@Transactional
	public void limpiarTurnadoTodosLosDespachos(Long id) {
		esquemaTurnadoDao.limpiarTurnadoTodosLosDespachos();
	}
}
