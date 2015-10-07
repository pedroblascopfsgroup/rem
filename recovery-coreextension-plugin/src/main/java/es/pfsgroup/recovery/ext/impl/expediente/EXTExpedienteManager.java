package es.pfsgroup.recovery.ext.impl.expediente;

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
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoReglasElevacion;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.ReglasElevacion;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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

@Component
public class EXTExpedienteManager extends BaseExpedienteManager implements EXTExpedienteApi{
	
	
	@Autowired
	private EXTExpedienteDao extExpedienteDao;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

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
	

    private Boolean compruebaElevacion(Expediente expediente, String estadoParaElevar, Boolean isSupervisor) {
        //Comprobaciones para ver si estamos en el estado correcto
        Long bpmProcess = expediente.getProcessBpm();
        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
        if (estadoParaElevar == null || !estadoParaElevar.equals(node)) {
            logger.error("No se puede enviar a revision/decisión porque el expediente no esta en completar/revisión");
            throw new BusinessOperationException("expediente.elevarRevision.errorJBPM");
        }

        if (!isSupervisor) {
            //Comprobaci�n de las reglas de elevaci�n
            List<ReglasElevacion> listadoReglas = getReglasElevacionExpediente(expediente.getId());
            for (ReglasElevacion regla : listadoReglas) {
                if (!regla.getCumple()) { return false; }
            }
        }

        return true;
    }
    
    
    private Boolean compruebaDevolucion(Expediente expediente, String estadoParaDevolver, String estadoNuevo){
    	//Comprobaciones para ver si estamos en el estado correcto
        Long bpmProcess = expediente.getProcessBpm();
        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
        if(estadoParaDevolver == null || !estadoParaDevolver.equals(node)){
        	 logger.error("No se puede devolver a revision/decisión porque el expediente no esta en decisión a comité");
             throw new BusinessOperationException("expediente.elevarRevision.errorJBPM");
        }
        DDEstadoItinerario estadoItinerario = expediente.getEstadoItinerario();
        Estado estado = (Estado) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_GET, expediente.getArquetipo().getItinerario(),
                estadoItinerario);

        List<ReglasElevacion> listadoReglas = expedienteDao.getReglasElevacion(estado);

        //obtenemos los acuerdos del expediente para luego comprobar las reglas
        List<EXTAcuerdo> acuerdos =  proxyFactory.proxy(PropuestaApi.class).listadoPropuestasByExpedienteId(expediente.getId());
        
        //Comprobamos una a una si las reglas se cumplen
        for (ReglasElevacion regla : listadoReglas) {
        	
        	if(regla.getTipoReglaElevacion().getCodigo().equals(DDTipoReglasElevacion.MARCADO_GESTION_PROPUESTA)){
        		if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_DECISION_COMIT) && estadoNuevo!= null && estadoNuevo.equals(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE)){
        			regla.setCumple(cumplimientoReglaDCRE(expediente, acuerdos));
        			if(!regla.getCumple()){ return false;}
        		}else if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_FORMALIZAR_PROPUESTA) && estadoNuevo!= null && estadoNuevo.equals(DDEstadoItinerario.ESTADO_DECISION_COMIT)){
        			regla.setCumple(cumplimiendoReglaFPDC(expediente, acuerdos));
        			if(!regla.getCumple()){ return false;}
        		}
        	}
        }
    	
    	return true;
    }

}
