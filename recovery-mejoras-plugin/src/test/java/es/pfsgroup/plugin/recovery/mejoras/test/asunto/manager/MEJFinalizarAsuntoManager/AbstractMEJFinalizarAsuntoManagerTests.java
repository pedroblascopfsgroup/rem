package es.pfsgroup.plugin.recovery.mejoras.test.asunto.manager.MEJFinalizarAsuntoManager;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.*;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.dao.EXTAsuntoDao;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procedimiento.dao.EXTProcedimientoDao;
import es.capgemini.pfs.registro.ModificacionAsuntoListener;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.asunto.manager.MEJFinalizarAsuntoManager;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;

/**
 * Clase abstracta utilizada para implementar los tests de {@link MEJFinalizarAsuntoManager}
 * @author manuel
 *
 */
public abstract class AbstractMEJFinalizarAsuntoManagerTests {

	@InjectMocks
	MEJFinalizarAsuntoManager mejFinalizarAsuntoManager;
	
	@Mock
	protected GenericABMDao mockGenericDao;

	@Mock
	private Executor executor;

	@Mock
	private ApiProxyFactory proxyFactory;
	
	@Mock
	protected EXTAsuntoDao mockAsuntoDao;
	
	@Mock
	protected EXTProcedimientoDao mockProcedimientoDao;
	
	@Mock
    protected JBPMProcessManager mockJBPMProcessManager;	
	
	@Mock
	protected ModificacionAsuntoListener mockMEJModAsuntoREG;
	
	@Mock
	protected Filter mockFilter;
	
	@Mock
	private DDEstadoAsunto mockEsAsuCancelado;
	
	@Mock
	private DDEstadoProcedimiento mockEsPrcCerrado;
	
	@Mock
	protected EXTAsuntoApi mockExtAsuntoApi;
	
	protected Long idProcedimiento;
	
    /**
     * Código de inicialización pre-test de cada hijo
     */
    public abstract void preChildTest();

    /**
     * Código de limpieza post-tet de cada hijo
     */
    public abstract void postChildTest();
    
    @Before
    public void before() {
    	
		idProcedimiento = RandomUtils.nextLong();
    	
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "codigo",
				DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO)).thenReturn(mockFilter);
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "codigo", 
    			DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)).thenReturn(mockFilter);
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento)).thenReturn(mockFilter);    	
    	when(mockGenericDao.get(DDEstadoAsunto.class, mockFilter)).thenReturn(mockEsAsuCancelado);
    	when(mockGenericDao.get(DDEstadoProcedimiento.class, mockFilter)).thenReturn(mockEsPrcCerrado);

        this.preChildTest();
    }

    @After
    public void after() {
        this.postChildTest();
        
		idProcedimiento = null;
		
        mockAsuntoDao = null;
        mockGenericDao = null;
        mockProcedimientoDao = null;
        mockMEJModAsuntoREG = null;
        mockFilter = null;
        mockEsAsuCancelado = null;
        mockEsPrcCerrado = null;
    }    
}
