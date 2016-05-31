package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.ext.turnadodespachos.AplicarTurnadoException;
import es.pfsgroup.recovery.ext.turnadodespachos.DDEstadoEsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoDto;

@Service ("turnadoProcuradoresManager")
public class TurnadoProcuradoresManager implements TurnadoProcuradoresApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
    @Autowired
    private UsuarioManager usuarioManager;

	@Autowired
	private EsquemaTurnadoProcuradorDao esquemaTurnadoProcuradorDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private SubastaProcedimientoApi subastaProcedimientoApi;

	@Autowired
	private TareaExternaManager tareaExternaManager;
	
	@Autowired
	private CoreProjectContext coreProjectContext;

	@Override
	public Page listaEsquemasTurnado(EsquemaTurnadoBusquedaDto dto) {
		Usuario usuarioLogado = usuarioManager.getUsuarioLogado();
		Page page = esquemaTurnadoProcuradorDao.buscarEsquemasTurnado(dto, usuarioLogado);
		return page;
	}

	@Override
	public EsquemaTurnadoProcurador get(Long id) {
		return esquemaTurnadoProcuradorDao.get(id);
	}
	
	@Override
	@Transactional(readOnly = false)
	public EsquemaTurnadoProcurador save(EsquemaTurnadoDto dto) {
		/*
		EsquemaTurnadoProcurador esquema = null;	
		if (dto.getId()!=null) {
			esquema = get(dto.getId());
		} else {
			esquema = new EsquemaTurnadoProcurador();
			DDEstadoEsquemaTurnado estado = (DDEstadoEsquemaTurnado)diccionarioApi
					.dameValorDiccionarioByCod(DDEstadoEsquemaTurnado.class, DDEstadoEsquemaTurnado.ESTADO_DEFINICION);
			esquema.setEstado(estado);
		}

		esquema.setDescripcion(dto.getDescripcion());

		logger.debug("Guarda el esquema...");
		esquemaTurnadoProcuradorDao.saveOrUpdate(esquema);
		
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
			config.setEsquemaProcurador(esquema);
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
		
		esquema = esquemaTurnadoProcuradorDao.get(esquema.getId());
		
		return esquema;
		*/
		return null;
	}


	@Override
	@Transactional(readOnly = false)
	public void activarEsquema(Long idEsquema) {
		EsquemaTurnadoProcurador esquema = this.get(idEsquema);
		EsquemaTurnadoProcurador esquemaVigente = null;
		
		DDEstadoEsquemaTurnado estadoTerminado = (DDEstadoEsquemaTurnado)diccionarioApi
				.dameValorDiccionarioByCod(DDEstadoEsquemaTurnado.class, DDEstadoEsquemaTurnado.ESTADO_TERMINADO);
		DDEstadoEsquemaTurnado estadoVigente = (DDEstadoEsquemaTurnado)diccionarioApi
				.dameValorDiccionarioByCod(DDEstadoEsquemaTurnado.class, DDEstadoEsquemaTurnado.ESTADO_VIGENTE);
		
		Date fechaVigencia = new Date();
		try {
			esquemaVigente = this.getEsquemaVigente();
			esquemaVigente.setFechaFinVigencia(fechaVigencia);
			esquemaVigente.setEstado(estadoTerminado);
			esquemaTurnadoProcuradorDao.save(esquemaVigente);
		} catch (IllegalArgumentException iae) {
			logger.info(String.format("No existe esquema vigente previo, se va a activar el primer esquema!", esquema.getDescripcion()));
		} finally {
			esquema.setFechaInicioVigencia(fechaVigencia);
			esquema.setEstado(estadoVigente);
			esquemaTurnadoProcuradorDao.save(esquema);
		}
	}

	@Override
	@Transactional(readOnly = false)
	public void turnarProcurador(Long idAsunto, String username, String plaza, String tpo) throws IllegalArgumentException, AplicarTurnadoException {
		try {
			this.getEsquemaVigente();
			esquemaTurnadoProcuradorDao.turnarProcurador(idAsunto, username, plaza, tpo);
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
	public EsquemaTurnadoProcurador getEsquemaVigente() {
		EsquemaTurnadoProcurador esquemaTurnado = esquemaTurnadoProcuradorDao.getEsquemaVigente();
		return esquemaTurnado;
	}

	@Override
	@Transactional
	public void delete(Long id) {
		/*
		 * EsquemaTurnadoProcurador esquema = get(id);
		esquemaTurnadoProcuradorDao.delete(esquema);
		if (esquema.getConfiguracion()!=null) {
			for (EsquemaTurnadoConfig config : esquema.getConfiguracion()) {
				genericDao.deleteById(EsquemaTurnadoConfig.class, config.getId());
			}
		}
		*/
	}

	@Override
	@Transactional
	public void copy(Long id) {
		/*
		EsquemaTurnadoProcurador esquema = get(id);
		EsquemaTurnadoDto dto = new EsquemaTurnadoDto();
		dto.setDescripcion("Copia de " + esquema.getDescripcion());
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
		*/
	}

	@Override
	public boolean isModificable(EsquemaTurnadoProcurador esquema) {
		Usuario usuarioLogado = usuarioManager.getUsuarioLogado();
		boolean modoConsulta = esquema.getId()!=null && 
				(esquema.getEstado().getCodigo().equals(DDEstadoEsquemaTurnado.ESTADO_TERMINADO) ||
				esquema.getAuditoria().getUsuarioCrear()==usuarioLogado.getUsername());
		return modoConsulta;
	}

	@Override
	public boolean checkActivarEsquema(Long id) {
		/*
		EsquemaTurnadoProcurador esquema = this.get(id);
		EsquemaTurnadoProcurador esquemaVigente = null;
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
		
		int total = esquemaTurnadoProcuradorDao.cuentaLetradosAsignados(codigosCI, codigosCC, codigosLI, codigosLC);
		
		return (total==0);
		*/
		return false;
	}

	@Override
	@Transactional
	public void limpiarTurnadoTodosLosDespachos(Long id) {
		esquemaTurnadoProcuradorDao.limpiarTurnadoTodosLosDespachos();
	}

	@Override
	public Boolean comprobarSiProcuradorHaSidoCambiado(Long prcId) {
		
		//Procurador asignado al asunto
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
		EXTAsunto asu = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", prc.getAsunto().getId()));
		GestorDespacho procurador = asu.getProcurador();
		
		//Procurador asignado automáticamente por el turnado de procuradores. Tenemos que consultar en las tablas TUP
		GestorDespacho procuradorTurnado = new GestorDespacho();
		
		if(!Checks.esNulo(procurador) && !Checks.esNulo(procuradorTurnado)){
			return !procurador.getUsuario().equals(procuradorTurnado.getUsuario());
		}
				
		return true;
	}
	

	@Override
	public Boolean comprobarSiLosDatosHanSidoCambiados(Long prcId) {
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
		
		List<TareaExterna> tareas = tareaExternaManager.obtenerTareasPorProcedimiento(prc.getId());
		
		List<TareaExterna> tareasAnterior = tareaExternaManager.obtenerTareasPorProcedimiento(prc.getId());

		String importeDemanda = "";
		String procIniciar = "";
		String partidoJudicial = "";
		
		for (TareaExterna tarea : tareas) {
			if ("PCO_RegistrarTomaDec".equals(tarea.getTareaProcedimiento().getCodigo())) {
				List<EXTTareaExternaValor> valores = subastaProcedimientoApi.obtenerValoresTareaByTexId(tarea.getId());
				for (EXTTareaExternaValor valor : valores) {
					if ("principal".equals(valor.getNombre())) {
						importeDemanda = valor.getValor();
					}
					else if ("proc_a_iniciar".equals(valor.getNombre())) {
						procIniciar = valor.getValor();
					}
					else if ("partidoJudicial".equals(valor.getNombre())) {
						partidoJudicial = valor.getValor();
					}
				}
			}
		}
		
		for (TareaExterna tarea : tareasAnterior) {
			if ("PCO_ValidarAsignacion".equals(tarea.getTareaProcedimiento().getCodigo())) {
				List<EXTTareaExternaValor> valores = subastaProcedimientoApi.obtenerValoresTareaByTexId(tarea.getId());
				for (EXTTareaExternaValor valor : valores) {
					if ("importeDemanda".equals(valor.getNombre())) {
						if(!importeDemanda.equals(valor.getValor())){
							return true;
						}
					}
					else if ("proc_a_iniciar".equals(valor.getNombre())) {
						if(!procIniciar.equals(valor.getValor())){
							return true;
						}
					}
					else if ("partidoJudicial".equals(valor.getNombre())) {
						if(!partidoJudicial.equals(valor.getValor())){
							return true;
						}
					}
				}
			}
		}
		return false;
	}
	
	public String dameValoresBPMPadrePCO(Long idProcedimiento, String codigo) {
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao
				.createFilter(FilterType.EQUALS, "id", idProcedimiento));

		List<TareaExterna> tareas = tareaExternaManager.obtenerTareasPorProcedimiento(prc.getProcedimientoPadre().getId());

		for (TareaExterna tarea : tareas) {
			if ("PCO_ValidarAsignacion".equals(tarea.getTareaProcedimiento().getCodigo())) {
				List<EXTTareaExternaValor> valores = subastaProcedimientoApi.obtenerValoresTareaByTexId(tarea.getId());
				for (EXTTareaExternaValor valor : valores) {
					if (codigo.equals(valor.getNombre())) {
						return valor.getValor();
					}
				}
			}
		}

		return null;
	}
	
	@Override
	public List<TipoPlaza> getPlazasEsquemaTurnadoProcu(){
		List<TipoPlaza> listaPlazas = genericDao.getList(TipoPlaza.class, genericDao
				.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		if(!Checks.estaVacio(listaPlazas)){
			return listaPlazas;
		}
		return null;
	}
	
	@Override
	public List<TipoProcedimiento> getTPOsEsquemaTurnadoProcu(){
		List<TipoProcedimiento> listaTpo = genericDao.getList(TipoProcedimiento.class, genericDao
				.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		if(!Checks.estaVacio(listaTpo)){
			return listaTpo;
		}
		return null;
	}
	
	@Override
	public Collection<? extends TipoPlaza> getPlazas(String query) {
		return esquemaTurnadoProcuradorDao.getPlazas(query);
	}

	@Override
	public Collection<? extends TipoProcedimiento> getTPOs(String query) {
		return esquemaTurnadoProcuradorDao.getTPOs(query);
	}

	@Override
	public List<TipoPlaza> getPlazasGrid(Long idEsquema) {
		List<TipoPlaza> list = esquemaTurnadoProcuradorDao.getPlazasEquema(idEsquema);
		return (list.size()>0 ? list : null);
	}

	@Override
	public List<TipoProcedimiento> getTPOsGrid(Long idEsquema, Long idPlaza) {
		List<TipoProcedimiento> list = esquemaTurnadoProcuradorDao.getTiposProcedimientoPorPlazaEsquema(idEsquema,idPlaza);
		return (list.size()>0 ? list : null);
	}

	@Override
	public List<EsquemaPlazasTpo> getRangosGrid(Long idEsquema, Long idPlaza, Long idTPO) {
		
		//Get esquema
		EsquemaTurnadoProcurador esquemaTurnado = genericDao.get(EsquemaTurnadoProcurador.class, genericDao
				.createFilter(FilterType.EQUALS, "id", idEsquema));
		//Sobre el esquema, filtrar por plaza o tpo si se requiere
		List<EsquemaPlazasTpo> listaConfiguracion = esquemaTurnado.getConfiguracion();
		if(!Checks.esNulo(idPlaza)){
			Iterator<EsquemaPlazasTpo> iter = listaConfiguracion.iterator();
			while(iter.hasNext()){
				if(!iter.next().getTipoPlaza().getId().equals(idPlaza)) iter.remove();
			}
		}
		if(!Checks.esNulo(idTPO)){
			Iterator<EsquemaPlazasTpo> iter = listaConfiguracion.iterator();
			while(iter.hasNext()){
				if(!iter.next().getTipoProcedimiento().getId().equals(idTPO)) iter.remove();
			}
		}
		
		//List<TurnadoProcuradorConfig> list = esquemaTurnadoProcuradorDao.getRangosPorPlazaTPOEsquema(idEsquema,idPlaza,idTPO);
		return (!Checks.estaVacio(listaConfiguracion) ? listaConfiguracion : null);
	}

	@Override
	public List<Usuario> getDespachosProcuradores() {
		String codEntidad= usuarioManager.getUsuarioLogado().getEntidad().getCodigo();
		Map<String, List<String>> despachosProcuradores = coreProjectContext.getDespachosProcuradores();
		List<String> despachosValidos = null;
		if(despachosProcuradores.containsKey(codEntidad)){
			despachosValidos = despachosProcuradores.get(codEntidad);
		}
		
		List<Usuario> list = esquemaTurnadoProcuradorDao.getDespachosProcuradores(despachosValidos);
		return (list.size()>0 ? list : null);
	}

	@Override
	public EsquemaTurnadoProcurador getEsquemaById(Long id) {
		return genericDao.get(EsquemaTurnadoProcurador.class, genericDao
				.createFilter(FilterType.EQUALS, "id", id));
	}

	@Override
	@Transactional
	public List<Long> a�adirNuevoTpoAPlazas(Long idEsquema, String codTPO, String[] arrayPlazas) {
		//Lista de ids pares plaza-tpo insertados
		List<Long> idsPlazasTpo = new ArrayList<Long>();
		
		//Recuperar procedimiento
		TipoProcedimiento tpo = genericDao.get(TipoProcedimiento.class, genericDao
				.createFilter(FilterType.EQUALS, "codigo", codTPO));
		//Recuperar esquema
		EsquemaTurnadoProcurador esquema = genericDao.get(EsquemaTurnadoProcurador.class, genericDao
				.createFilter(FilterType.EQUALS, "id", idEsquema));
		
		TipoPlaza plaza;
		EsquemaPlazasTpo plazaTpo;
		//Crear pares plaza-tpo
		for(int i = 0; i < arrayPlazas.length; i++){
			plaza = genericDao.get(TipoPlaza.class, genericDao
					.createFilter(FilterType.EQUALS, "codigo", arrayPlazas[i]));
			//Crear plaza-tpo
		    plazaTpo = new EsquemaPlazasTpo();
		    plazaTpo.setEsquemaTurnadoProcurador(esquema);
		    plazaTpo.setTipoPlaza(plaza);
		    plazaTpo.setTipoProcedimiento(tpo);
		    genericDao.save(EsquemaPlazasTpo.class, plazaTpo);
		    idsPlazasTpo.add(plazaTpo.getId());
		}
		
		return idsPlazasTpo;
	}

	@Override
	@Transactional
	public List<Long> borrarConfigParaPlazaOTpo(Long idEsquema, String plazaCod, String tpoCod, String[] arrayPlazas) {
		//Lista de ids pares plaza-tpo insertados
		List<Long> idsPlazasTpo = null;
		
		if(!Checks.esNulo(plazaCod)){
			//Get ids de las tuplas que van a ser borradas
			idsPlazasTpo = esquemaTurnadoProcuradorDao.getIdsEPTPorCodigoPlaza(plazaCod);
		}
		if(!Checks.esNulo(tpoCod)){
			//Get ids de las tuplas que van a ser borradas
			idsPlazasTpo = esquemaTurnadoProcuradorDao.getIdsEPTPorCodigoTPO(tpoCod,arrayPlazas);
		}
		//Borrado fisico de toda la configuracion relacionada con los pares plazas-tpo dados
		if(!Checks.estaVacio(idsPlazasTpo)) esquemaTurnadoProcuradorDao.borradoFisicoConfigPlazaTPO(idsPlazasTpo);
		
		return idsPlazasTpo;
	}

	@Override
	public Boolean checkSiPlazaYaTieneConfiguracion(Long idEsquema, String plazaCod) {
		List<EsquemaPlazasTpo> listaConfig = genericDao.getList(EsquemaPlazasTpo.class, 
									genericDao.createFilter(FilterType.EQUALS, "esquemaTurnadoProcurador.id", idEsquema),
									genericDao.createFilter(FilterType.EQUALS, "tipoPlaza.codigo", plazaCod));
		
		if(!Checks.estaVacio(listaConfig)) return true;
		else return false;
	}
}
