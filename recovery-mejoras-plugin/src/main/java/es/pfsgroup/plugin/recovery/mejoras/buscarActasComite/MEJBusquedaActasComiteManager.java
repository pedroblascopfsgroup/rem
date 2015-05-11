package es.pfsgroup.plugin.recovery.mejoras.buscarActasComite;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.pfs.comite.model.SesionComite;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dao.MEJSesionComiteDao;
import es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dto.MEJDtoBusquedaActas;
import es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dto.MEJDtoResultadoBusquedaActas;
import es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dto.MEJDtoResultadoBusquedaActasContenedor;

/**
 * Manager para la busqueda de actas de comités cerrados.
 * @author pamuller
 *
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = false)
public class MEJBusquedaActasComiteManager {

    @Autowired
    private Executor executor;

    @Autowired
    private MEJSesionComiteDao mejSesionComiteDao;
    
    /**
     * Buscar las tareas según criterios recividos.
     * una vez recivida la página resultado la seteamos en el deteo correspondiente
     * @param dto dto
     * @return Dto contenedor de la lista de actas recividas
     */
	@SuppressWarnings("unchecked")
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_BUSCAR_ACTAS_COMITE)
    @Transactional
    public MEJDtoResultadoBusquedaActasContenedor buscarActasComites(MEJDtoBusquedaActas dto) {
		MEJDtoResultadoBusquedaActasContenedor contenedorResultadoBusqueda = new MEJDtoResultadoBusquedaActasContenedor();
		List<MEJDtoResultadoBusquedaActas> listaRetorno = new ArrayList<MEJDtoResultadoBusquedaActas>();
    	List<SesionComite> listaResultado = new ArrayList<SesionComite>();
    	
    	Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
    	dto.setUsuarioLogado(usuarioLogado);
    	PageHibernate page = (PageHibernate) mejSesionComiteDao.buscarActasComites(dto);
    	if (page != null ) { // seteo el dto a partir de los resultados
    		listaResultado.addAll((List<SesionComite>) page.getResults());
    		for (SesionComite s : listaResultado){
    			MEJDtoResultadoBusquedaActas elementoNuevo = new MEJDtoResultadoBusquedaActas();
    			SesionComite sesion = new SesionComite();
    			sesion.setAsistentes(s.getAsistentes());
    			sesion.setComite(s.getComite());
    			sesion.setDecisiones(s.getDecisiones());
    			sesion.setFechaFin(s.getFechaFin());
    			sesion.setFechaInicio(s.getFechaInicio());
    			sesion.setId(s.getId());
    			elementoNuevo.setSesion(sesion);
    			listaRetorno.add(elementoNuevo);
    		}
    	}
    	contenedorResultadoBusqueda.setListaSesiones(listaRetorno);
    	contenedorResultadoBusqueda.setTotalCount(page.getTotalCount());
    	
    	return contenedorResultadoBusqueda;
    } 
}
