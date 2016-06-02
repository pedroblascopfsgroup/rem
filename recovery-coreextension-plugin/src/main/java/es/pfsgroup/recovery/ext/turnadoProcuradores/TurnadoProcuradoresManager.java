package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.util.Date;
import java.util.List;

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
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.ext.turnadodespachos.AplicarTurnadoException;
import es.pfsgroup.recovery.ext.turnadodespachos.DDEstadoEsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;

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
	public boolean isModificable(EsquemaTurnadoProcurador esquema) {
		Usuario usuarioLogado = usuarioManager.getUsuarioLogado();
		boolean modoConsulta = esquema.getId()!=null && 
				(esquema.getEstado().getCodigo().equals(DDEstadoEsquemaTurnado.ESTADO_TERMINADO) ||
				esquema.getAuditoria().getUsuarioCrear()==usuarioLogado.getUsername());
		return modoConsulta;
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
}
