package es.pfsgroup.plugin.recovery.mejoras.test.procedimiento.MEJProcedimientoManager;

import static org.mockito.Mockito.*;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.pfsgroup.plugin.recovery.mejoras.asunto.dao.MEJProcedimientoContratoExpedienteDao;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.MEJProcedimientoManager;

public abstract class AbstractMEJProcedimientoManagerTests {
    
    @InjectMocks
    protected MEJProcedimientoManagerParaTestear manager;
    
    protected MEJProcedimientoManagerParaTestear managerSpy;
    
    @Mock
    protected ProcedimientoDao mockProcedimientoDao;   
    
    @Mock
    protected MEJProcedimientoContratoExpedienteDao mockProcedimientoContratoExpedienteDao;
    
    @Before
    public void before(){
        managerSpy = spy(manager);
        
        childBefore();
    }
    
    @After
    public void after(){
        childAfter();
        
        reset(mockProcedimientoDao);
    }
    
    public abstract void childBefore();
    
    public abstract void childAfter();
}
