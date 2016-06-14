package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
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
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.DDTipoPrcIniciador;
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
	public List<TipoProcedimiento> getTPOsEsquemaTurnadoProcu(){
		List<TipoProcedimiento> listaTpo = genericDao.getList(TipoProcedimiento.class, genericDao
				.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		
		List<DDTipoPrcIniciador> listaTposIniciadores = genericDao.getList(DDTipoPrcIniciador.class, genericDao
				.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		
		HashSet<String> hs = new HashSet<String>(listaTposIniciadores.size());
		for(DDTipoPrcIniciador o : listaTposIniciadores) {
		    hs.add(o.getCodigo());
		}
		
		if(!Checks.estaVacio(listaTpo) && !Checks.estaVacio(listaTposIniciadores)){
			Iterator<TipoProcedimiento> iter = listaTpo.iterator();
			while(iter.hasNext()){
				if(!hs.contains(iter.next().getCodigo())) iter.remove();
			}
		}
		
		if(!Checks.estaVacio(listaTpo)){
			return listaTpo;
		}
		return null;
	}
	
	@Override
	public List<TipoPlaza> getPlazas(String query, Boolean otrasPlazasPresentes, Boolean plazaDefectoPresente) {
		List<TipoPlaza> listaPlazas= new ArrayList<TipoPlaza>();
		
		if(!plazaDefectoPresente){
			listaPlazas = esquemaTurnadoProcuradorDao.getPlazas(query);
		}
		if(!otrasPlazasPresentes || plazaDefectoPresente){
			TipoPlaza plaza = new TipoPlaza();
        	plaza.setDescripcion("PLAZA POR DEFECTO");
        	plaza.setDescripcionLarga("PLAZA POR DEFECTO");
        	plaza.setCodigo("default");
        	plaza.setId(Long.parseLong("-1"));
        	listaPlazas.add(plaza);
		}
		return listaPlazas;
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
	public List<EsquemaPlazasTpo> getRangosGrid(Long idEsquema, List<Long> idsPlazas, List<Long> idsTPOs) {
		
		//Get esquema
		EsquemaTurnadoProcurador esquemaTurnado = genericDao.get(EsquemaTurnadoProcurador.class, genericDao
				.createFilter(FilterType.EQUALS, "id", idEsquema));
		//Sobre el esquema, filtrar por plaza o tpo si se requiere
		List<EsquemaPlazasTpo> listaConfiguracion = esquemaTurnado.configuracionOrdenada();
		if(!Checks.estaVacio(idsPlazas)){
			Iterator<EsquemaPlazasTpo> iter = listaConfiguracion.iterator();
			while(iter.hasNext()){
				EsquemaPlazasTpo ept = iter.next();
				boolean stop = false;
				for(int i =0; i<idsPlazas.size() && !stop; i++){
					if(idsPlazas.get(i)==-1){
						if(ept.getTipoPlaza()==null) stop=true;
					}
					else if(ept.getTipoPlaza()==null){
						if(idsPlazas.get(i)==-1) stop=true;
					}
					else if(ept.getTipoPlaza().getId().equals(idsPlazas.get(i))) {
						stop=true;
					}
				}
				if(!stop){
					iter.remove();
				}
			}
		}
		if(!Checks.estaVacio(idsTPOs)){
			Iterator<EsquemaPlazasTpo> iter = listaConfiguracion.iterator();
			for(int x = 0; x<listaConfiguracion.size();x++){
				EsquemaPlazasTpo ept = iter.next();
				boolean stop = false;
				for(int i =0; i<idsTPOs.size() && !stop; i++){
					if(idsTPOs.get(i)==-1){
						if(ept.getTipoProcedimiento()==null) stop=true;
					}
					else if(ept.getTipoProcedimiento()==null){
						if(idsTPOs.get(i)==-1) stop=true;
					}
					else if(ept.getTipoProcedimiento().getId().equals(idsTPOs.get(i))) {
						stop=true;
					}
				}
				if(!stop){
					iter.remove();
				}
			}
		}
		
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
	public List<Long> anyadirNuevoTpoAPlazas(Long idEsquema, Long idTpo, Long[] arrayPlazas) {
		//Lista de ids pares plaza-tpo insertados
		List<Long> idsPlazasTpo = new ArrayList<Long>();
		
		//Recuperar procedimiento
		TipoProcedimiento tpo = null;
		if(idTpo==-1) {
			tpo = null;
		}
		else{
			tpo = genericDao.get(TipoProcedimiento.class, genericDao
					.createFilter(FilterType.EQUALS, "id", idTpo));
		}
		
		//Recuperar esquema
		EsquemaTurnadoProcurador esquema = genericDao.get(EsquemaTurnadoProcurador.class, genericDao
				.createFilter(FilterType.EQUALS, "id", idEsquema));
		
		TipoPlaza plaza;
		EsquemaPlazasTpo plazaTpo;
		//Crear pares plaza-tp
		for(int i = 0; i < arrayPlazas.length; i++){
			if(arrayPlazas[i]==-1) {
				plaza = null;
			}
			else{
				plaza = genericDao.get(TipoPlaza.class, genericDao
						.createFilter(FilterType.EQUALS, "id", arrayPlazas[i]));
			}
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
	public List<Long> borrarConfigParaPlazaOTpo(Long idEsquema, Long idPlaza, Long idTpo, Long[] arrayPlazas) {
		//Lista de ids pares plaza-tpo borrados
		List<Long> idsPlazasTpo = null;
		
		if(!Checks.esNulo(idPlaza)){
			//Get ids de las tuplas que van a ser borradas
			idsPlazasTpo = esquemaTurnadoProcuradorDao.getIdsEPTPorIdPlaza(idPlaza,idEsquema);
		}
		if(!Checks.esNulo(idTpo)){
			//Get ids de las tuplas que van a ser borradas
			idsPlazasTpo = esquemaTurnadoProcuradorDao.getIdsEPTPorIdTPO(idTpo,arrayPlazas,idEsquema);
		}
		//Borrado fisico de toda la configuracion relacionada con los pares plazas-tpo dados
		if(!Checks.estaVacio(idsPlazasTpo)) esquemaTurnadoProcuradorDao.borradoFisicoConfigPlazaTPO(idsPlazasTpo);
		
		return idsPlazasTpo;
	}
	
	@Override
	public void borrarConfigParaPlazaOTpo(List<Long> idsPlazaTpo){
		 esquemaTurnadoProcuradorDao.borradoFisicoConfigPlazaTPO(idsPlazaTpo);
	}

	@Override
	@Transactional
	public HashMap<String,List<Long>> borrarConfigParaPlazaOTpoLogico(Long idEsquema, Long idPlaza, Long idTpo) {
		List<Long> idsPlazasTpo = null;
		List<Long> idsRangos = new ArrayList<Long>();
		
		if(!Checks.esNulo(idPlaza)){
			//Get ids de las tuplas que van a ser borradas
			idsPlazasTpo = esquemaTurnadoProcuradorDao.getIdsEPTPorIdPlaza(idPlaza,idEsquema);
		}
		if(!Checks.esNulo(idTpo)){
			//Get ids de las tuplas que van a ser borradas
			Long[] arrayPlazas = new Long[]{idPlaza};
			idsPlazasTpo = esquemaTurnadoProcuradorDao.getIdsEPTPorIdTPO(idTpo,arrayPlazas,idEsquema);
		}
		//Borrado logico de toda la informacion relacionada con los pares plazas-tpo dados
		if(!Checks.estaVacio(idsPlazasTpo)){
			List<TurnadoProcuradorConfig> listaConfig;
			for(Long id : idsPlazasTpo){
				listaConfig = genericDao.getList(TurnadoProcuradorConfig.class, genericDao
						.createFilter(FilterType.EQUALS, "esquemaPlazasTpo.id", id));
				for(TurnadoProcuradorConfig conf : listaConfig)	{
					genericDao.deleteById(TurnadoProcuradorConfig.class,conf.getId());
					//Guardar ids de los rangos borrados logicamente
					idsRangos.add(conf.getId());
				}
				genericDao.deleteById(EsquemaPlazasTpo.class, id);
			}
		}
		HashMap<String,List<Long>> map = new HashMap<String,List<Long>>();
		map.put("plazasTposBorrados", idsPlazasTpo);
		map.put("rangosBorrados", idsRangos);
		
		return map;
	}

	@Override
	public Boolean checkSiPlazaYaTieneConfiguracion(Long idEsquema, Long idPlaza) {
		List<Long> list = esquemaTurnadoProcuradorDao.getIdsEPTPorIdPlaza(idPlaza, idEsquema);
		if(!Checks.estaVacio(list)) return true;
		else return false;
	}

	@Override
	@Transactional
	public List<Long> addRangoConfigEsquema(List<Long> idsPlazasTpo, Long idConf, Double impMin, Double impMax,String[] arrayDespachos) {
		List<Long> idsRangos = new ArrayList<Long>();
		if(Checks.estaVacio(idsPlazasTpo)){
			idsPlazasTpo = new ArrayList<Long>();
			idsPlazasTpo.add(idConf);
		}
		
		for(Long id : idsPlazasTpo){
			EsquemaPlazasTpo plazasTpo = genericDao.get(EsquemaPlazasTpo.class,
					genericDao.createFilter(FilterType.EQUALS, "id", id));
			boolean existe = false;
			
			//Comprueba si ya existe regla que entre en conflicto con esta
			logger.debug(String.format("Comprobando si rango de importes se solapa con regla existente..."));
			existe = plazasTpo.importesSolapados(impMin,impMax,null);
			
			if(!existe){
				//NO EXISTE: Se crea la nueva regla
				logger.debug(String.format("Creando nueva regla..."));
				TurnadoProcuradorConfig config = null;
				Usuario usu = null;
				Double porc = null;
				
				for(String tuplaDespachoPorcentaje : arrayDespachos){
					String[] aux = tuplaDespachoPorcentaje.split("_");
					usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(aux[0])));
					porc = Double.parseDouble(aux[1]);
					config = new TurnadoProcuradorConfig();
					config.setEsquemaPlazasTpo(plazasTpo);
					config.setImporteDesde(impMin);
					config.setImporteHasta(impMax);
					config.setPorcentaje(porc);
					config.setUsuario(usu);
					genericDao.save(TurnadoProcuradorConfig.class, config);
					idsRangos.add(config.getId());
				}
			}
			else{
				//ENTRA EN CONFLICTO: Se lanza excepcion y se informa al usuario
				logger.warn(String.format("El rango de importes especificado [%.2f - %.2f] se solapa con una regla ya existente", impMin ,impMax));
				throw new BusinessOperationException(String.format("El rango de importes especificado [%.2f - %.2f] se solapa con una regla ya existente", impMin ,impMax));
			}
		}
		return idsRangos;
	}
	
	@Override
	@Transactional
	public HashMap<String, List<String>> updateRangoConfigEsquema(Long idConf, Double impMin, Double impMax,String[] arrayDespachos){
		//Varaibles para almacenar los cambios
		List<String> modificaciones = new ArrayList<String>();
		List<String> borrados = new ArrayList<String>();
		List<String> creados = new ArrayList<String>();
		//Recuperar todas las reglas asociadas a la recibida
		List<TurnadoProcuradorConfig> listaRangos = getIdsRangosRelacionados(idConf, null);
		
		//Comprueba si ya existe regla que entre en conflicto con esta y que no sean las reglas dadas
		logger.debug(String.format("Comprobando si rango de importes se solapa con regla existente..."));
		if(listaRangos.get(0).getEsquemaPlazasTpo().importesSolapados(impMin,impMax,listaRangos)) throw new BusinessOperationException(String.format("El rango de importes especificado [%.2f - %.2f] se solapa con una regla ya existente", impMin ,impMax));
		
		//Lista de ids despachos - porcentajes que nos servira para las validaciones
		List<String[]> listaDespachos = new ArrayList<String[]>();
		for(String tuplaDespachoPorcentaje : arrayDespachos){
			listaDespachos.add(tuplaDespachoPorcentaje.split("_"));
		}
		for(TurnadoProcuradorConfig rango: listaRangos){
			boolean parar = false;
			int aux = -1;
			//Comprobar si el despacho del rango aun seguira existiendo ( su existencia en la lista de despachos)
			for(int i = 0; i<listaDespachos.size() && !parar; i++){
				if(listaDespachos.get(i)[0].equals(rango.getUsuario().getId())){
					aux=i;
					parar=true;
				}
			}
			//Si va a seguir existiendo: se modifica con los nuevos campos
			if(aux!=-1){
				//Guardar el id, y los valores anteriores, para posibles cancelaciones
				modificaciones.add(rango.getId().toString()
						+"_"+rango.getImporteDesde().toString()
						+"_"+rango.getImporteHasta().toString()
						+"_"+rango.getPorcentaje());
				rango.setImporteDesde(impMin);
				rango.setImporteHasta(impMax);
				rango.setPorcentaje(Double.parseDouble(listaDespachos.get(aux)[1]));
				genericDao.update(TurnadoProcuradorConfig.class, rango);
				listaDespachos.remove(aux);
			}
			//Si no, se borra logicamente
			else {
				//Guardar el id, para posibles cancelaciones
				borrados.add(rango.getId().toString());
				genericDao.deleteById(TurnadoProcuradorConfig.class, rango.getId());
			}
		}
		//Creacion de nuevas reglas
		Usuario usu = null;
		TurnadoProcuradorConfig newConfig = null;
		for(String[] despacho : listaDespachos){
			usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(despacho[0])));
			newConfig= new TurnadoProcuradorConfig();
			newConfig.setEsquemaPlazasTpo(listaRangos.get(0).getEsquemaPlazasTpo());
			newConfig.setImporteDesde(impMin);
			newConfig.setImporteHasta(impMax);
			newConfig.setPorcentaje(Double.parseDouble(despacho[1]));
			newConfig.setUsuario(usu);
			genericDao.save(TurnadoProcuradorConfig.class, newConfig);
			//Guardar el id, para posibles cancelaciones
			creados.add(newConfig.getId().toString());
		}
		
		//Return
		HashMap<String,List<String>> mapaFinal = new HashMap<String, List<String>>();
		mapaFinal.put("modificaciones",modificaciones);
		mapaFinal.put("borrados", borrados);
		mapaFinal.put("creados", creados);
		return mapaFinal;
	}

	@Override
	@Transactional
	public List<Long> borrarRangoConfigEsquema(Long idConfig, List<Long> listIdsPlazaTpo) {
		List<Long> idsBorrados = new ArrayList<Long>();
		//Recuperar todas las reglas asociadas a la recibida
		List<TurnadoProcuradorConfig> listaRangos = getIdsRangosRelacionados(idConfig,listIdsPlazaTpo);
		
		for(TurnadoProcuradorConfig rango: listaRangos){
			//Guardar el id, para posibles cancelaciones
			idsBorrados.add(rango.getId());
			genericDao.deleteById(TurnadoProcuradorConfig.class, rango.getId());
		}
		
		return idsBorrados;
	}

	@Override
	public List<TurnadoProcuradorConfig> getIdsRangosRelacionados(Long idConfig, List<Long> listIdsPlazaTpo) {
		TurnadoProcuradorConfig config = genericDao.get(TurnadoProcuradorConfig.class, genericDao
				.createFilter(FilterType.EQUALS, "id", idConfig));
		List<TurnadoProcuradorConfig> listaRangos = esquemaTurnadoProcuradorDao.dameListaRangosRelacionados(config,listIdsPlazaTpo);
		return listaRangos;
	}

	@Override
	@Transactional
	public void reactivarPlazasTPO(List<Long> listIdsTBC) {
		EsquemaPlazasTpo ept = null;
		for(Long id : listIdsTBC){
			if(!Checks.esNulo(id)){
				ept = genericDao.get(EsquemaPlazasTpo.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
				ept.getAuditoria().setBorrado(false);
				ept.getAuditoria().setFechaBorrar(null);
				ept.getAuditoria().setUsuarioBorrar(null);
				genericDao.update(EsquemaPlazasTpo.class, ept);
			}
		}
	}
	
	@Override
	@Transactional
	public void reactivarRangos(List<Long> listIdsRBC) {
		TurnadoProcuradorConfig tpc = null;
		for(Long id : listIdsRBC){
			if(!Checks.esNulo(id)){
				tpc = genericDao.get(TurnadoProcuradorConfig.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
				tpc.getAuditoria().setBorrado(false);
				tpc.getAuditoria().setFechaBorrar(null);
				tpc.getAuditoria().setUsuarioBorrar(null);
				genericDao.update(TurnadoProcuradorConfig.class, tpc);
			}
		}
	}

	@Override
	public void borrarRangosFisico(List<Long> listIdsRC) {
		esquemaTurnadoProcuradorDao.borrarRangosFisico(listIdsRC);
	}
	
	@Override
	public void modificarRangosCancelacion(List<String> listModRangos) {
		TurnadoProcuradorConfig tpc = null;
		String[] aux = null;
		for(int i = listModRangos.size()-1;i>=0;i--){
			if(!Checks.esNulo(listModRangos.get(i))){
				aux=listModRangos.get(i).split("_");
				tpc = genericDao.get(TurnadoProcuradorConfig.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(aux[0])));
				if(!Checks.esNulo(tpc)){
					tpc.setImporteDesde(Double.parseDouble(aux[1]));
					tpc.setImporteHasta(Double.parseDouble(aux[2]));
					tpc.setPorcentaje(Double.parseDouble(aux[3]));
					genericDao.save(TurnadoProcuradorConfig.class, tpc);
				}
			}
		}
	}

	@Override
	public List<TipoProcedimiento> getTPODisponiblesByPlaza(Long idEsquema, Long idPlaza) {
		List<TipoProcedimiento> listaTposDisponibles;
		List<TipoProcedimiento> listaTposYaExistentes = getTPOsGrid(idEsquema,idPlaza);
		
		//Si idPlaza=-1 ("PLAZA POR DEFECTO") solo se esta disponible el tpo "PROCEDIMIENTO POR DEFECTO"
		//FIXME Cambiar si se desea poder asignar el tpo por defecto a cualquier plaza (a�adir el tpo por defecto a ambos casos)
		if(idPlaza!=-1){
			listaTposDisponibles = getTPOsEsquemaTurnadoProcu();
		}
		else {
			listaTposDisponibles = new ArrayList<TipoProcedimiento>();
			TipoProcedimiento tpo = new TipoProcedimiento();
        	tpo.setDescripcion("PROCEDIMIENTO POR DEFECTO");
        	tpo.setDescripcionLarga("PROCEDIMIENTO POR DEFECTO");
        	tpo.setCodigo("default");
        	tpo.setId(Long.parseLong("-1"));
        	listaTposDisponibles.add(tpo);
		}
		
		HashSet<Long> hs = new HashSet<Long>(listaTposYaExistentes.size());
		for(TipoProcedimiento o : listaTposYaExistentes) {
		    hs.add(o.getId());
		}
		
		if(!Checks.estaVacio(listaTposDisponibles) && !Checks.estaVacio(listaTposYaExistentes)){
			Iterator<TipoProcedimiento> iter = listaTposDisponibles.iterator();
			while(iter.hasNext()){
				if(hs.contains(iter.next().getId())) iter.remove();
			}
		}
		
		return listaTposDisponibles;
	}	
	
}
