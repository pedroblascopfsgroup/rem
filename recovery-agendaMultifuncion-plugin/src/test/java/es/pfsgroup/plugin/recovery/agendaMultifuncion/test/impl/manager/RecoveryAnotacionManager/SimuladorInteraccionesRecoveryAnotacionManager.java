package es.pfsgroup.plugin.recovery.agendaMultifuncion.test.impl.manager.RecoveryAnotacionManager;

import static org.mockito.Mockito.*;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.util.Assert;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionCustomTemplate;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionInfo;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.ClasspathResourceUtil;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.test.impl.manager.RecoveryAnotacionManager.bo.DtoCrearAnotacionBuilder;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.api.UsuarioApi;

public class SimuladorInteraccionesRecoveryAnotacionManager {

    private ApiProxyFactory mockProxyFactory;

    // Apis din�micas
    private UsuarioApi mockUsuariosManager;

    private MEJRegistroApi mockRegistroManager;
    
    private AsuntoApi mockAsuntoManager;
    
    private AgendaMultifuncionCustomTemplate mockAgendaMultifuncionTemplate;
    
    private ClasspathResourceUtil mockClasspathUtil;

    public SimuladorInteraccionesRecoveryAnotacionManager(ApiProxyFactory mockProxyFactory, ClasspathResourceUtil mockClasspathUtil) {
        this.mockProxyFactory = mockProxyFactory;
        this.mockClasspathUtil = mockClasspathUtil; 
    }

    public void seObtieneUsuarioLogado() {
        Assert.state(mockUsuariosManager != null);
        Usuario mockUsuarioLogado = mock(Usuario.class);
        when(mockUsuariosManager.getUsuarioLogado()).thenReturn(mockUsuarioLogado);

    }
    
    public void seObtieneRecursoDelClassPath(final String resource, final InputStream stream) {
        Assert.state(mockClasspathUtil != null);
        when(mockClasspathUtil.getResourceAsStream(resource)).thenReturn(stream);
        
    }
    
    public void seObtieneConfiguracionPersonalizada(final HashMap<String, String> parametros) {
        Assert.state(mockAgendaMultifuncionTemplate != null);
       when(mockAgendaMultifuncionTemplate.getCustomize(any(DtoCrearAnotacionInfo.class))).thenReturn(parametros);
    }
    
    public void seObtienenLosUsuarios(List<Long> usuarios) {
        Assert.state(mockUsuariosManager != null);
        if (!Checks.estaVacio(usuarios)){
            Usuario mockUsuario;
            for (Long id : usuarios){
                mockUsuario = mock(Usuario.class);
                when(mockUsuario.getId()).thenReturn(id);
                when(mockUsuario.getEmail()).thenReturn(RandomStringUtils.randomAlphanumeric(100));
                when(mockUsuariosManager.get(id)).thenReturn(mockUsuario);
            }
        }
        
    }

    public void inicializaProxyFactory() {
        mockUsuariosManager = seObtieneUsuariosManager(mockProxyFactory);
        mockRegistroManager = seObtieneRegistroManager(mockProxyFactory);
        mockAsuntoManager = seObtieneAsuntoManager(mockProxyFactory);
        mockAgendaMultifuncionTemplate = seObtieneLaTemplateDeAgenda(mockProxyFactory);
    }

    private AgendaMultifuncionCustomTemplate seObtieneLaTemplateDeAgenda(final ApiProxyFactory mockProxyFactory) {
        AgendaMultifuncionCustomTemplate myMock = mock(AgendaMultifuncionCustomTemplate.class);
        when(mockProxyFactory.proxy(AgendaMultifuncionCustomTemplate.class)).thenReturn(myMock);
        return myMock;
    }

    private AsuntoApi seObtieneAsuntoManager(final ApiProxyFactory mockProxyFactory) {
        AsuntoApi myMockAsuntoManager = mock(AsuntoApi.class);
        when(mockProxyFactory.proxy(AsuntoApi.class)).thenReturn(myMockAsuntoManager);
        return myMockAsuntoManager;
    }

    private MEJRegistroApi seObtieneRegistroManager(final ApiProxyFactory mockProxyFactory) {
        MEJRegistroApi myMockRegistroManager = mock(MEJRegistroApi.class);
        when(mockProxyFactory.proxy(MEJRegistroApi.class)).thenReturn(myMockRegistroManager);
        return myMockRegistroManager;
    }

    private UsuarioApi seObtieneUsuariosManager(final ApiProxyFactory mockProxyFactory) {
        UsuarioApi myMockUsuarioApi = mock(UsuarioApi.class);
        when(mockProxyFactory.proxy(UsuarioApi.class)).thenReturn(myMockUsuarioApi);
        return myMockUsuarioApi;
    }

   
}
