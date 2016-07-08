package es.pfsgroup.plugin.rem.tareasactivo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.VTareaActivoCount;
import es.pfsgroup.plugin.rem.tareasactivo.dao.ActivoTareaExternaDao;
import es.pfsgroup.plugin.rem.tareasactivo.dao.TareaActivoDao;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGrupoUsuariosApi;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;


/**
 * Manager que gestiona las TareaExterna de un trámite. Extiende TareaExternaManager
 * @author mpardo
 *
 */
@Service
public class ActivoTareaExternaManager /*extends TareaExternaManager*/ implements ActivoTareaExternaApi{
	
	@Autowired
	ActivoTareaExternaDao activoTareaExternaDao;
	
	@Autowired
	TareaActivoDao tareaActivoDao;
	
    @Autowired
    private TareaExternaValorDao tareaExternaValorDao;
    
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ActivoTramiteApi activoTramiteApi;

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.tareas.ActivoTareaExternaManagerApi#getTareasByIdTramite(java.lang.Long)
	 */
	@Override
	public List<TareaExterna> getTareasByIdTramite(Long idTramite) {
		return activoTareaExternaDao.getTareasTramiteHistorico(idTramite);
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.tareas.ActivoTareaExternaManagerApi#getActivasByIdTramite(java.lang.Long)
	 */
	@Override
	public List<TareaExterna> getActivasByIdTramite(Long idTramite, Usuario usuarioLogado) {
		
		EXTGrupoUsuarios grupoUsuarioLogado  = genericDao.get(EXTGrupoUsuarios.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));		
		
		return activoTareaExternaDao.getTareasTramite(idTramite, usuarioLogado, grupoUsuarioLogado);
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.tareas.ActivoTareaExternaManagerApi#getActivasByIdTramiteTodas(java.lang.Long)
	 */
	@Override
	public List<TareaExterna> getActivasByIdTramiteTodas(Long idTramite) {
				
		return activoTareaExternaDao.getTareasTramiteTodas(idTramite);
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.tareas.ActivoTareaExternaManagerApi#getByIdTareaProcedimientoIdTramite(java.lang.Long, java.lang.Long)
	 */
	@Override
	public List<TareaExterna> getByIdTareaProcedimientoIdTramite(Long idTramite, Long idTareaProcedimiento) {
		return activoTareaExternaDao.getTareasTramiteTipo(idTramite, idTareaProcedimiento);
	}

	@Override
	public TareaExterna get(Long idTareaExterna) {
		return activoTareaExternaDao.get(idTareaExterna);
	}

    @Transactional(readOnly = false)
    public void borrar(TareaExterna tareaExterna) {

        tareaActivoDao.delete((TareaActivo) tareaExterna.getTareaPadre());
        activoTareaExternaDao.delete(tareaExterna);
    }
	
    /**
     * Lista de tareas externas valor de la tarea externa.
     * @param idTareaExterna long
     * @return Lista de tareas externa valor
     */
    public List<TareaExternaValor> obtenerValoresTarea(Long idTareaExterna) {
        return tareaExternaValorDao.getByTareaExterna(idTareaExterna);
    }
    
    @Transactional(readOnly = false)
    public void activarAlerta(TareaExterna tareaExterna) {
        tareaExterna.getTareaPadre().setAlerta(true);
        activoTareaExternaDao.saveOrUpdate(tareaExterna);
    }
    
    /**
     * Activa una tarea detenida por una paralización de BPM. La desmarca de borrada y detenida
     * @param tareaExterna TareaExterna
     */
    @Transactional(readOnly = false)
    public void activar(TareaExterna tareaExterna) {
        if (tareaExterna.getDetenida()) {
            tareaExterna.setDetenida(false);
            tareaExterna.getTareaPadre().setBorrado(false);
            activoTareaExternaDao.saveOrUpdate(tareaExterna);
        }
    }
    
    @Transactional(readOnly = false)
    public void saveOrUpdate(TareaExterna tareaExterna){
    	activoTareaExternaDao.saveOrUpdate(tareaExterna);
    }
    
    /**
     * Obtener valores de la primera tarea de un trámite de admisión
     */
    @Override
    public TareaExterna obtenerTareasAdmisionByCodigo(Activo activo, String codigoTarea){
		
		ActivoTramite tramiteAdmision = activoTramiteApi.getTramiteAdmisionActivo(activo.getId());
		List<TareaExterna> listaTareas = new ArrayList<TareaExterna>();
		
		if(!Checks.esNulo(tramiteAdmision.getId()))
			listaTareas = activoTareaExternaDao.getTareasTramiteCodigoTipo(tramiteAdmision.getId(), codigoTarea);
		
		return (!Checks.estaVacio(listaTareas)? listaTareas.get(0) : null);
    }
    
}