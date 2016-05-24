package es.pfsgroup.plugin.recovery.agendaMultifuncion.test.impl.manager.RecoveryAnotacionManager;

import static org.mockito.Mockito.*;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import javax.mail.MessagingException;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.manager.RecoveryAnotacionManager;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.ClasspathResourceUtil;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.EmailContentUtil;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;

public abstract class AbstractRecoveryAnotacionManagerTests {

    @InjectMocks
    protected RecoveryAnotacionManagerParaTestear  manager;
    
    @Mock
    protected ApiProxyFactory mockProxyFactory;
    
    @Mock
    protected Properties mockAppProperties;
    
    @Mock
    protected ClasspathResourceUtil mockClasspathUtil;
    
    @Mock
    protected EmailContentUtil mockEmailContentUtil;
    
    protected Random random;

    private SimuladorInteraccionesRecoveryAnotacionManager simulador;
    private VerificadorInteraccionesRecoveryAnotacionManager verificador;
    
    @Before
    public void before() throws IOException{
        simulador = new SimuladorInteraccionesRecoveryAnotacionManager(mockProxyFactory,mockClasspathUtil);
        verificador = new VerificadorInteraccionesRecoveryAnotacionManager(mockEmailContentUtil);
        random = new Random();
        mockAppProperties = initRandomMockProperties("agendaMultifuncion.mail.from");
        
        simular().inicializaProxyFactory();
        simular().seObtieneUsuarioLogado();
        
        childBefore();
    }

    

    private Properties initRandomMockProperties(String... properties) {
        Properties mockProperties = mock(Properties.class);
        if (properties != null){
            for (String prop : properties){
                when(mockProperties.get(prop)).thenReturn(RandomStringUtils.randomAlphanumeric(100));
            }
        }
        return mockProperties;
    }


    public abstract void childBefore() throws IOException;
    
    @After
    public void after(){
        childAfter();
        reset(mockProxyFactory);
        reset(mockAppProperties);
        reset(mockClasspathUtil);
        reset(mockEmailContentUtil);
        
        simulador = null;
        verificador = null;
        random = null;
    }
    
    public abstract void childAfter();
    
    protected SimuladorInteraccionesRecoveryAnotacionManager simular() {
        return this.simulador;
    }
    
    protected VerificadorInteraccionesRecoveryAnotacionManager verificar() {
        return this.verificador;
    }
    
    protected RecoveryAnotacionManagerParaTestear creaYConfiguraSpyManger() {
        RecoveryAnotacionManagerParaTestear spyObject = spy(this.manager);
        try {
            doReturn(random.nextLong()).when(spyObject).crearTarea(any(Long.class), any(String.class), any(String.class), any(Long.class), any(Boolean.class), any(String.class), any(Date.class));
            doNothing().when(spyObject).enviarMailConAdjuntos(any(List.class), any(String.class),any(List.class), any(String.class), any(String.class), any(List.class));
        } catch (EXTCrearTareaException e) {
           // Esta excepción no se va a producir, la escondemos
        } catch (MessagingException e) {
            // Esta excepción no se va a producir, la escondemos
        }
        return spyObject;
    }
}
