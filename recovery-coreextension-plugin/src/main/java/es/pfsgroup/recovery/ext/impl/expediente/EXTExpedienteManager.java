package es.pfsgroup.recovery.ext.impl.expediente;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.api.ExpedienteManagerApi;
import es.capgemini.pfs.expediente.dao.ExpedienteContratoDao;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;
import es.pfsgroup.recovery.ext.api.expediente.BaseExpedienteManager;
import es.pfsgroup.recovery.ext.api.expediente.EXTExpedienteApi;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGestorInfo;
import es.pfsgroup.recovery.ext.api.multigestor.EXTMultigestorApi;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.expediente.dao.EXTExpedienteDao;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;
import es.pfsgroup.recovery.integration.Guid;

@Component
public class EXTExpedienteManager extends BaseExpedienteManager implements EXTExpedienteApi{
	
	
	@Autowired
	private EXTExpedienteDao extExpedienteDao;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteManagerApi expedienteManager;
	
	@Autowired
	private PropuestaApi propuestaManager;
	
	@Autowired
	private ExpedienteContratoDao expedienteContratoDao;

	/**
	 * Busca expedients que contengan un determinado contrato
	 * @param idContrato Contrato que buscamos
	 * @param estados Lista de estados posibles para los expedientes. Si se indica NULL se devuelven todos independientemente del estado
	 * @return
	 */
	@BusinessOperation(EXT_EXP_MGR_BUSCAR_EXP_CON_CONTRATO)
    @Transactional(readOnly = false)
	@Override
	public List<? extends Expediente> buscaExpedientesConContrato(
			Long idContrato, String[] estados) {
		if (idContrato == null){
			throw new IllegalArgumentException("'idcontrato' no puede ser NULL");
		}
		return extExpedienteDao.buscaExpedientesConContrato(
				idContrato, estados);
	}
	
	/**
     * Busca expedientes para un filtro.
     *
     * @param expedientes
     *            DtoBuscarExpedientes el filtro
     * @return List la lista
     */
    @BusinessOperation(overrides = InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_PAGINATED)
    public Page findExpedientesPaginated(DtoBuscarExpedientes expedientes) {
    	System.out.println("findExpedientePaginated overrides");
    	Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
    	EventFactory.onMethodStart(this.getClass());
        if (expedientes.getCodigoZona() != null && expedientes.getCodigoZona().trim().length() > 0) {
            StringTokenizer tokens = new StringTokenizer(expedientes.getCodigoZona(), ",");
            Set<String> zonas = new HashSet<String>();
            while (tokens.hasMoreTokens()) {
                String zona = tokens.nextToken();
                zonas.add(zona);
            }
            expedientes.setCodigoZonas(zonas);
        } else {
           
            expedientes.setCodigoZonas(usuario.getCodigoZonas());
        }
        EventFactory.onMethodStop(this.getClass());
        return extExpedienteDao.buscarExpedientesPaginado(expedientes,usuario);
    }

	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(EXT_EXP_MGR_ES_GESTOR_CARACTERIZADO)
	public boolean esGestorCaracterizado(Long idExpediente) {
		boolean tienePerfilCaracterizado = false;
		Expediente expediente = extExpedienteDao.get(idExpediente);
		List<EXTPerfil> listaPerfilesCaracterizados = genericDao.getList(EXTPerfil.class,genericDao.createFilter(FilterType.EQUALS, "esCarterizado", true),genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false));
		
		//COMPROBAMOS QUE EL EXPEDIENTE TENGA ASOCIADO EL PERFIL CARACTERIZADO
		//EN CASO DE QUE NO LO TENGA, DEVOLVEMOS TRUE
		String perfilExpediente = expediente.getGestorActual();
		if(perfilExpediente != null && listaPerfilesCaracterizados != null){
			
			for(EXTPerfil perfil:listaPerfilesCaracterizados){
				if(perfil.getDescripcion().equalsIgnoreCase(perfilExpediente))
					tienePerfilCaracterizado = true;
			}
			
		}
		
		if(tienePerfilCaracterizado){
			List<EXTGestorInfo> listaGestores = (List<EXTGestorInfo>) executor.execute(EXTMultigestorApi.EXT_BO_MULTIGESTOR_DAME_GESTORES,DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,idExpediente);
			Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			
			if(listaGestores != null){
				for(EXTGestorInfo gestorInfo:listaGestores){
					if(gestorInfo.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EMPRESAS_CARACTERIZADAS)
							&& gestorInfo.getUsuario().getId().equals(usuarioLogado.getId())){
						return true;
					}
					if(gestorInfo.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROMOTORES_CARACTERIZADAS)
							&& gestorInfo.getUsuario().getId().equals(usuarioLogado.getId())){
						return true;
					}
				}
			}
			return false;
		}else
			return true;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(EXT_EXP_MGR_ES_SUPERVISOR_CARACTERIZADO)
	public boolean esSupervisorCaracterizado(Long idExpediente) {
		boolean tienePerfilCaracterizado = false;
		Expediente expediente = extExpedienteDao.get(idExpediente);
		List<EXTPerfil> listaPerfilesCaracterizados = genericDao.getList(EXTPerfil.class,genericDao.createFilter(FilterType.EQUALS, "esCarterizado", true),genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false));
		
		//COMPROBAMOS QUE EL EXPEDIENTE TENGA ASOCIADO EL PERFIL CARACTERIZADO
		//EN CASO DE QUE NO LO TENGA, DEVOLVEMOS TRUE
		String perfilExpediente = expediente.getGestorActual();
		if(perfilExpediente != null && listaPerfilesCaracterizados != null){
			
			for(EXTPerfil perfil:listaPerfilesCaracterizados){
				if(perfil.getDescripcion().equalsIgnoreCase(perfilExpediente))
					tienePerfilCaracterizado = true;
			}
			
		}
		
		if(tienePerfilCaracterizado){
			List<EXTGestorInfo> listaGestores = (List<EXTGestorInfo>) executor.execute(EXTMultigestorApi.EXT_BO_MULTIGESTOR_DAME_GESTORES,DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,idExpediente);
			Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			if(listaGestores != null){
				for(EXTGestorInfo gestorInfo:listaGestores){
					if(gestorInfo.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_SUPERVISOR_EMPRESAS_CARACTERIZADAS)
							&& gestorInfo.getUsuario().getId().equals(usuarioLogado.getId())){
						return true;
					}
					if(gestorInfo.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_SUPERVISOR_PROMOTORES_CARACTERIZADAS)
							&& gestorInfo.getUsuario().getId().equals(usuarioLogado.getId())){
						return true;
					}
				}
			}
			return false;
		}else
			return true;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(overrides = InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_REVISION)
    @Transactional(readOnly = false)
	@Override
    public void elevarExpedienteARevision(Long idExpediente, Boolean isSupervisor) {
        //Validamos el estado de todas las propuestas (sea propuesto o rechazado o incumplido o cumplido o cancelado )
        List<String> codigosEstadosValidos = new ArrayList<String>();
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_PROPUESTO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_RECHAZADO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CUMPLIDO);
        
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CANCELADO);
        
        Boolean propuestasEstadoConforme = propuestaManager.estadoTodasPropuestas(propuestaManager.listadoPropuestasByExpedienteId(idExpediente),
        																			codigosEstadosValidos);
        if (propuestasEstadoConforme) {
        	expedienteManager.elevarExpedienteARevision(idExpediente, isSupervisor);
        } else {
        	throw new BusinessOperationException("expediente.elevar.falloEstadoPropuestas");
        }
    }
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(overrides = InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_DECISION_COMITE)
    @Transactional(readOnly = false)
	@Override
    public void elevarExpedienteADecisionComite(Long idExpediente, Boolean isSupervisor) {
        //Validamos el estado de todas las propuestas (sea propuesto o rechazado o incumplido o cumplido o cancelado )
        List<String> codigosEstadosValidos = new ArrayList<String>();
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_PROPUESTO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_RECHAZADO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CUMPLIDO);
        
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CANCELADO);
        
        List<EXTAcuerdo> propuestasExp = propuestaManager.listadoPropuestasByExpedienteId(idExpediente);
        Boolean propuestasEstadoConforme = propuestaManager.estadoTodasPropuestas(propuestasExp, codigosEstadosValidos);
        
        if (propuestasEstadoConforme) {
        	expedienteManager.elevarExpedienteADecisionComite(idExpediente, isSupervisor);        	
        	//Las propuestas en estado "Propuesto" se elevan/aceptan
        	for (EXTAcuerdo propuesta : propuestasExp) {
        		if (propuesta.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_PROPUESTO)) {
        			propuestaManager.cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_ACEPTADO, true);
        		}
			}        	
        } else {
        	throw new BusinessOperationException("expediente.elevar.falloEstadoPropuestas");
        }        
	}
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(overrides = InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_REVISION)
    @Transactional(readOnly = false)
	@Override
    public void devolverExpedienteARevision(Long idExpediente, String respuesta) {
		expedienteManager.devolverExpedienteARevision(idExpediente, respuesta);
		
        //Validamos el estado de todas las propuestas (sea Elevadas o rechazado o incumplido o cumplido o cancelado )
        List<String> codigosEstadosValidos = new ArrayList<String>();
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_ACEPTADO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_RECHAZADO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CUMPLIDO);
        
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CANCELADO);
		
        List<EXTAcuerdo> propuestasExp = propuestaManager.listadoPropuestasByExpedienteId(idExpediente);
        Boolean propuestasEstadoConforme = propuestaManager.estadoTodasPropuestas(propuestasExp, codigosEstadosValidos);
        
        if (propuestasEstadoConforme) {
        	//Las propuestas en estado "Elevadas"/Aceptadas se vuelven a "Propuestas"
        	for (EXTAcuerdo propuesta : propuestasExp) {
        		if (propuesta.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_ACEPTADO)) {
        			propuestaManager.cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_PROPUESTO, true);
        		}
        	}
        } else {
        	throw new BusinessOperationException("expediente.devolver.falloEstadoPropuestas");
        }

	}
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(overrides = InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_FORMALIZAR_PROPUESTA)
	@Transactional(readOnly = false)
	@Override
	public void elevarExpedienteAFormalizarPropuesta(Long idExpediente, Boolean isSupervisor) {
        //Validamos el estado de todas las propuestas (sea Elevadas o rechazado o incumplido o cumplido o cancelado )
        List<String> codigosEstadosValidos = new ArrayList<String>();
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_ACEPTADO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_RECHAZADO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CUMPLIDO);
        
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CANCELADO);
        
        List<EXTAcuerdo> propuestasExp = propuestaManager.listadoPropuestasByExpedienteId(idExpediente);
        Boolean propuestasEstadoConforme = propuestaManager.estadoTodasPropuestas(propuestasExp, codigosEstadosValidos);
        
    	//Comprobamos que al menos una propuesta está en estado Elevada
        List<String> codigoEstadoElevado = new ArrayList<String>();
        codigoEstadoElevado.add(DDEstadoAcuerdo.ACUERDO_ACEPTADO);
        Boolean algunaPropuestaElevada = propuestaManager.estadoAlgunaPropuesta(propuestasExp, codigoEstadoElevado);
        
        if (propuestasEstadoConforme && algunaPropuestaElevada) {
        	expedienteManager.elevarExpedienteAFormalizarPropuesta(idExpediente, isSupervisor);
        	//Las propuestas en estado "Elevada"/Aceptada se pasan a Vigente
        	for (EXTAcuerdo propuesta: propuestasExp) {
        		if (propuesta.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_ACEPTADO)) {
        			propuestaManager.cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_VIGENTE, true);
        		}
        	}
        } else {
        	throw new BusinessOperationException("expediente.elevar.falloEstadoPropuestas");
        }
	}
	
    /**
     * {@inheritDoc}
     */
	@BusinessOperation(overrides = InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_DECISION_COMITE)
	@Transactional(readOnly = false)
	@Override
	public void devolverExpedienteADecisionComite(Long idExpediente, String respuesta) {
		expedienteManager.devolverExpedienteADecisionComite(idExpediente, respuesta);
		
        //Validamos el estado de todas las propuestas (sea Elevadas o rechazado o incumplido o cumplido o cancelado )
        List<String> codigosEstadosValidos = new ArrayList<String>();
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CUMPLIDO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO);        
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_RECHAZADO);
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_VIGENTE);
        
        codigosEstadosValidos.add(DDEstadoAcuerdo.ACUERDO_CANCELADO);
        
        List<EXTAcuerdo> propuestasExp = propuestaManager.listadoPropuestasByExpedienteId(idExpediente);
        Boolean propuestasEstadoConforme = propuestaManager.estadoTodasPropuestas(propuestasExp, codigosEstadosValidos);

        if (propuestasEstadoConforme) {
        	//Las propuestas en estado "Vigente" se pasan a "Elevada"/Aceptada
        	for (EXTAcuerdo propuesta : propuestasExp) {
        		if (propuesta.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_VIGENTE)) {
        			propuestaManager.cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_ACEPTADO, true);
        		}
        	}
        } else {
        	throw new BusinessOperationException("expediente.devolver.falloEstadoPropuestas");
        }
	}
	
	public Expediente prepareGuid(Expediente expediente) {
		boolean modificados = false;
		if (Checks.esNulo(expediente.getGuid())) {

			String guid = Guid.getNewInstance().toString();
			while(extExpedienteDao.getByGuid(guid) != null) {
				guid = Guid.getNewInstance().toString();
			}
			
			expediente.setGuid(guid);
			modificados = true;
		}
		// En caso de haber cambiado algo se guarda el estado
		if (modificados) {
			extExpedienteDao.saveOrUpdate(expediente);
		}
		return expediente;
	}
}
