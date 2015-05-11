package es.capgemini.pfs.procesosJudiciales.test.EXTTareaExternaManager;

import static org.mockito.Mockito.*;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.dao.EXTTareaExternaDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareasApi;

/**
 * Simula la interacción del manager con otros ojetos.
 * 
 * @author bruno
 * 
 */
public class SimuadorInteraccionesEXTTareaExternaManager {

    private final ApiProxyFactory mockProxyFactory;
    
    private UsuarioApi mockUsuarioManager;

    private EXTOpcionesBusquedaTareasApi mockOpcionesBusquedaTareas;

    private EXTTareaExternaDao mockTareaExternaDao;



    public SimuadorInteraccionesEXTTareaExternaManager(final ApiProxyFactory mockProxyFactory, EXTTareaExternaDao mockTareaExternaDao) {
        this.mockProxyFactory = mockProxyFactory;
        this.mockTareaExternaDao = mockTareaExternaDao;
        
        mockUsuarioManager = mock(UsuarioApi.class);
        mockOpcionesBusquedaTareas = mock(EXTOpcionesBusquedaTareasApi.class);
        
        when(this.mockProxyFactory.proxy(UsuarioApi.class)).thenReturn(mockUsuarioManager);
        when(this.mockProxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class)).thenReturn(mockOpcionesBusquedaTareas);
    }
    


    /**
     * Simula que la optimización de los buzones de tareas está activa
     * @param idUsuario 
     */
    public void optimizacionBuzonesActivada() {
        when(mockOpcionesBusquedaTareas.tieneOpcionBuzonOptimizado()).thenReturn(Boolean.TRUE);
    }

    
    /**
     * Simula que la optimización de los buzones de tareas está desactivada
     */
    public void optimizacionBuzonesDesactivada() {
        when(mockOpcionesBusquedaTareas.tieneOpcionBuzonOptimizado()).thenReturn(Boolean.FALSE);
        
    }


    /**
     * Simula que se obtiene el usuario logado con el id especificado
     * @param idUsuario
     */
    public void seObtieneUsuarioLogado(final Long idUsuario) {
        final Usuario mockUsuario = mock(Usuario.class);
       
        when(mockUsuarioManager.getUsuarioLogado()).thenReturn(mockUsuario );
        when(mockUsuario.getId()).thenReturn(idUsuario);
        
    }



    public void seObtienenTareasExternasMedianteOptimizacion(Long idProcedimiento, Long idUsuario, List tareas) {
        when(mockTareaExternaDao.obtenerTareasPorUsuarioYProcedimientoConOptimizacion(idUsuario, idProcedimiento)).thenReturn(tareas);
        
    }

}
