package es.pfsgroup.recovery.ext.impl.expediente;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.api.expediente.BaseExpedienteManager;
import es.pfsgroup.recovery.ext.api.expediente.EXTExpedienteApi;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGestorInfo;
import es.pfsgroup.recovery.ext.api.multigestor.EXTMultigestorApi;
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
}
