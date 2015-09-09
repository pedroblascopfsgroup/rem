package es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.AsuntosManager;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.zona.dao.NivelDao;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.assembler.ProcedimientoPCOAssembler;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.assembler.ProcedimientoPcoGridDTOAssembler;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ActualizarProcedimientoPcoDtoInfo;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.ProcedimientoPcoGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.HistoricoEstadoProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Service
public class ProcedimientoPcoManager implements ProcedimientoPcoApi {

	@Autowired
	private ProcedimientoPCODao procedimientoPcoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private NivelDao nivelDao;

	@Autowired
	UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private AsuntosManager asuntosManager;
	
	
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	/*
	 * 
	 * Producto-234 Control de botones y rellenado de grids dependiendo del usuario logado
	 
	@Override
	@BusinessOperation(BO_PCO_EXPEDIENTE_IS_SUPERVISOR)
	public boolean isSupervisor(Long prcId){
		Boolean result = false;
		String perfiles[] = {"Supervisores de letrado"};
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		for (int i = 0; i < perfiles.length; i++) {
			result = this.tienePerfil(perfiles[i],usu);
			if(result) return true;			
		}
		return result;
		
		
	}
	
	 private Boolean tienePerfil(String descripcionPerfil, Usuario u) {

	    	if (u == null || descripcionPerfil == null) {
	            return false;
	        }

	        for (Perfil p : u.getPerfiles()) {
	        	if(descripcionPerfil.equals(p.getDescripcion()))
	        		return true;
	        }

	        return false;
	    }
	
	@Override
	@BusinessOperation(BO_PCO_EXPEDIENTE_OBTENER_TIPO_GESTOR)
	public String getTipoGestor(Long prcId){
		Procedimiento prc=null;
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", prcId);
			prc=(Procedimiento) genericDao.get(Procedimiento.class,filtro1);
		}catch(Exception e){
			logger.error(e);
		}
		
		EXTGestorAdicionalAsunto gestorAdicionalAsunto=null;
		GestorDespacho gestorDespacho=liquidacionManager.getGestorDespachoByUsuId(usuarioManager.getUsuarioLogado().getId()).get(0);
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "asunto.id", prc.getAsunto().getId());
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "gestor.id", gestorDespacho.getId());
			gestorAdicionalAsunto=(EXTGestorAdicionalAsunto) genericDao.get(EXTGestorAdicionalAsunto.class,filtro1,filtro2);
		}catch(Exception e){
			logger.error(e);
		}
		
		if(!Checks.esNulo(gestorAdicionalAsunto) && !Checks.esNulo(gestorAdicionalAsunto.getTipoGestor())){
			return gestorAdicionalAsunto.getTipoGestor().getCodigo();
		}
		else{
			return null;
		}
	}
	
	@Override
	@BusinessOperation(BO_PCO_EXPEDIENTE_IS_TIPO_DESPACHO_PREDOC)
	public boolean isTipoDespachoPredoc(Long prcId){
		Procedimiento prc=null;
		boolean isPredoc=false;
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", prcId);
			prc=(Procedimiento) genericDao.get(Procedimiento.class,filtro1);
		}catch(Exception e){
			logger.error(e);
		}
		
		EXTGestorAdicionalAsunto gestorAdicionalAsunto=null;
		List<GestorDespacho> listaGestorDespacho=liquidacionManager.getGestorDespachoByUsuId(usuarioManager.getUsuarioLogado().getId());
		List<GestorDespacho> listaGestorDespachoPredoc=new ArrayList<GestorDespacho>();
		for(GestorDespacho gestorDespacho : listaGestorDespacho){
			if(gestorDespacho.getDespachoExterno().getTipoDespacho().getCodigo().equals("PREDOC")){
				listaGestorDespachoPredoc.add(gestorDespacho);
			}
		}
		for(GestorDespacho gestorDespacho : listaGestorDespachoPredoc){
			try{
				Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "asunto.id", prc.getAsunto().getId());
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "gestor.id", gestorDespacho.getId());
				gestorAdicionalAsunto=(EXTGestorAdicionalAsunto) genericDao.get(EXTGestorAdicionalAsunto.class,filtro1,filtro2);
				if(gestorAdicionalAsunto.getTipoGestor().getCodigo().equals("PREDOC")){
					isPredoc=true;
				}
			}catch(Exception e){
				logger.error(e);
			}
		}
		
		return isPredoc;
	}
	
	@Override
	@BusinessOperation(BO_PCO_EXPEDIENTE_IS_TIPO_DESPACHO_GESTORIA)
	public boolean isTipoDespachoGestoria(Long prcId){
		Procedimiento prc=null;
		boolean isGestoria=false;
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", prcId);
			prc=(Procedimiento) genericDao.get(Procedimiento.class,filtro1);
		}catch(Exception e){
			logger.error(e);
		}
		
		
		List<GestorDespacho> listaGestorDespacho=liquidacionManager.getGestorDespachoByUsuId(usuarioManager.getUsuarioLogado().getId());
	
		for(GestorDespacho gestorDespacho : listaGestorDespacho){
			if(gestorDespacho.getDespachoExterno().getTipoDespacho().getCodigo().equals("GESTORIA")){
				isGestoria=true;
			}
		}
		
		
		return isGestoria;
	}
	*/
	
	
	//PREDOC
	//Recorro liquidacionManager.getGestorDespachoByUsuId(usuarioManager.getUsuarioLogado().getId()) y almaceno en otra lista todos los que tienen un tipoDespacho
	//Predoc y luego obtengo el gestor adicional asunto y si alguno tiene un tipo de gestor predoc devuelvo true
	
	//GESTORIA
	//Recorro liquidacionManager.getGestorDespachoByUsuId(usuarioManager.getUsuarioLogado().getId()) Y si alguno tiene un tipo de despacho GESTORIA devuelvo true
	
	@Override
	@Transactional(readOnly = false)
	public boolean finalizarPreparacionExpedienteJudicialPorProcedimientoId(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);
		boolean finalizar = true;

		for(DocumentoPCO doc : procedimientoPco.getDocumentos()){
			if(DDEstadoDocumentoPCO.DISPONIBLE.equals(doc.getEstadoDocumento().getCodigo())) {
				if(!doc.getAdjuntado()){
					finalizar = false;
				}
			}
		}
		if(finalizar) {
			HistoricoEstadoProcedimientoPCO historico = procedimientoPco.getEstadoActualByHistorico();
			historico.setFechaFin(new Date());
			genericDao.update(HistoricoEstadoProcedimientoPCO.class, historico);
			
			HistoricoEstadoProcedimientoPCO historicoNuevoRegistro = new HistoricoEstadoProcedimientoPCO();
			historicoNuevoRegistro.setProcedimientoPCO(procedimientoPco);
			DDEstadoPreparacionPCO estadoPreparado = (DDEstadoPreparacionPCO)diccionarioApi.dameValorDiccionarioByCod(DDEstadoPreparacionPCO.class, DDEstadoPreparacionPCO.PREPARADO);
			historicoNuevoRegistro.setEstadoPreparacion(estadoPreparado);
			historicoNuevoRegistro.setFechaInicio(new Date());
			genericDao.save(HistoricoEstadoProcedimientoPCO.class, historicoNuevoRegistro);
		}			

		return finalizar;
	}

	@Override
	@Transactional(readOnly = false)
	public void devolverPreparacionPorProcedimientoId(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);

		// Comprobacion que el estado actual del procedimiento sea preparado
		if (procedimientoPco.getEstadoActual() != null && !DDEstadoPreparacionPCO.PREPARADO.equals(procedimientoPco.getEstadoActual().getCodigo())) {
			throw new BusinessOperationException("Estado incorrecto");
		}

		// Actualizar fecha fin estado actual
		HistoricoEstadoProcedimientoPCO historico = procedimientoPco.getEstadoActualByHistorico();
		historico.setFechaFin(new Date());
		genericDao.update(HistoricoEstadoProcedimientoPCO.class, historico);

		// Nuevo registro en historico con el nuevo estado
		DDEstadoPreparacionPCO estadoPreparacion = (DDEstadoPreparacionPCO) diccionarioApi.dameValorDiccionarioByCod(DDEstadoPreparacionPCO.class, DDEstadoPreparacionPCO.PREPARACION);

		HistoricoEstadoProcedimientoPCO historicoNuevoRegistro = new HistoricoEstadoProcedimientoPCO();
		historicoNuevoRegistro.setProcedimientoPCO(procedimientoPco);
		historicoNuevoRegistro.setEstadoPreparacion(estadoPreparacion);
		historicoNuevoRegistro.setFechaInicio(new Date());
		genericDao.save(HistoricoEstadoProcedimientoPCO.class, historicoNuevoRegistro);	
	}

	@Override
	public List<HistoricoEstadoProcedimientoDTO> getEstadosPorIdProcedimiento(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);

		List<HistoricoEstadoProcedimientoDTO> historicoEstadosOut = null;

		if (procedimientoPco != null) {
			historicoEstadosOut = ProcedimientoPCOAssembler.historicoEstadosEntityToHistoricoEstadosDto(procedimientoPco.getEstadosPreparacionProc());
		}

		return historicoEstadosOut;
	}

	@BusinessOperation(ProcedimientoPcoApi.BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID)
	@Override
	public ProcedimientoPCODTO getPrecontenciosoPorProcedimientoId(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);

		ProcedimientoPCODTO procedimientoDto = ProcedimientoPCOAssembler.entityToDto(procedimientoPco);

		return procedimientoDto;
	}

	@Override
	public Integer countBusquedaPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Integer count = procedimientoPcoDao.countBusquedaPorFiltro(filtro);
		return count;
	}

	@Override
	public List<ProcedimientoPcoGridDTO> busquedaProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<HashMap<String, Object>> procedimientos = procedimientoPcoDao.busquedaProcedimientosPcoPorFiltro(filtro);
		List<ProcedimientoPcoGridDTO> procedimientosGridDto = ProcedimientoPcoGridDTOAssembler.fromProcedimientosListHashMap(procedimientos);

		return procedimientosGridDto;
	}

	@Override
	public List<ProcedimientoPcoGridDTO> busquedaSolicitudesDocumentoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<HashMap<String, Object>> documentos = procedimientoPcoDao.busquedaDocumentosPorFiltro(filtro);
		List<ProcedimientoPcoGridDTO> documentosGridDto = ProcedimientoPcoGridDTOAssembler.fromDocumentosListHashMap(documentos);

		return documentosGridDto;
	}

	@Override
	public List<ProcedimientoPcoGridDTO> busquedaLiquidacionesPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<HashMap<String, Object>> liquidaciones = procedimientoPcoDao.busquedaLiquidacionesPorFiltro(filtro);
		List<ProcedimientoPcoGridDTO> liquidacionGridDto = ProcedimientoPcoGridDTOAssembler.fromLiquidacionesListHashMap(liquidaciones);

		return liquidacionGridDto;
	}

	@Override
	public List<ProcedimientoPcoGridDTO> busquedaBurofaxPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<HashMap<String, Object>> burofaxes = procedimientoPcoDao.busquedaBurofaxPorFiltro(filtro);
		List<ProcedimientoPcoGridDTO> burofaxesGridDto = ProcedimientoPcoGridDTOAssembler.fromBurofaxesListHashMap(burofaxes);

		return burofaxesGridDto;
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_PCO_ACTUALIZAR_PROCEDIMIENTO_Y_PCO)
	public void actualizaProcedimiento(ActualizarProcedimientoPcoDtoInfo dto) {
		Procedimiento p = null;
		ProcedimientoPCO pco = null;
		if (!Checks.esNulo(dto.getId())) {
			p = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
			pco = genericDao.get(ProcedimientoPCO.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", dto.getId()));
		} else {
			throw new BusinessOperationException(
					"plugin.santander.actualizaProcedimiento.idNulo");
		}
		if (!Checks.esNulo(dto.getTipoReclamacion())) {
			Filter filtroTipoReclamacion = genericDao.createFilter(FilterType.EQUALS, "id", dto.getTipoReclamacion());
			DDTipoReclamacion reclamacion = genericDao.get(DDTipoReclamacion.class, filtroTipoReclamacion);
			p.setTipoReclamacion(reclamacion);
		}
		if (!Checks.esNulo(dto.getTipoJuzgado())) {
			Filter filtroJuzgado = genericDao.createFilter(FilterType.EQUALS, "id", dto.getTipoJuzgado());
			TipoJuzgado juzgado = genericDao.get(TipoJuzgado.class, filtroJuzgado);
			p.setJuzgado(juzgado);
		}
		if (!Checks.esNulo(dto.getPrincipal())) {
			p.setSaldoRecuperacion(dto.getPrincipal());
		}
		if (!Checks.esNulo(dto.getEstimacion())) {
			p.setPorcentajeRecuperacion(dto.getEstimacion());
		}
		if (!Checks.esNulo(dto.getPlazoRecuperacion())) {
			p.setPlazoRecuperacion(dto.getPlazoRecuperacion());
		}
		if (!Checks.esNulo(dto.getNumeroAutos())){
			p.setCodigoProcedimientoEnJuzgado(dto.getNumeroAutos());
		}
		if(!Checks.esNulo(dto.getNumExpExterno())){
			pco.setNumExpExterno(dto.getNumExpExterno());
		}

		genericDao.update(Procedimiento.class, p);
		genericDao.update(ProcedimientoPCO.class, pco);
	}
	
	@Override
	public List<Nivel> getNiveles(){
		return nivelDao.getList();
	}
}
