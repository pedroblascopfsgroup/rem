package es.pfsgroup.recovery.recobroConfig.test;

import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.Mock;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api.RecobroAgenciaApi;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.manager.api.RecobroPoliticaDeAcuerdosApi;

/**
 * Clase abstracta utilizada en todos los tests de controladores
 * 
 * @author Diana
 *
 */
public abstract class AbstractRecobroControllerTest extends AbstractRecobroConfigTest{
	
	@Mock
    protected ApiProxyFactory mockProxyFactory;
	
	@Mock
	protected RecobroAgenciaApi mockRecobroAgenciaManager;
	
	@Mock
	protected DiccionarioApi mockDiccionarioManager;
	
	@Mock 
	protected RecobroEsquemaApi mockRecobroEsquemaManager;
	
	@Mock
	protected RecobroPoliticaDeAcuerdosApi mockRecobroPoliticaDeAcuerdoManager;
	
	@Mock
	protected GenericABMDao genericDao;
	
	@Mock 
	protected UsuarioApi mockUsuarioApi;
	
	/*
     * Inicializacion generica de todos los tests
     */
    @Before
    public void before() {
        random = new Random();
        when(mockProxyFactory.proxy(RecobroAgenciaApi.class)).thenReturn(mockRecobroAgenciaManager);
        when(mockProxyFactory.proxy(DiccionarioApi.class)).thenReturn(mockDiccionarioManager);
        when(mockProxyFactory.proxy(RecobroEsquemaApi.class)).thenReturn(mockRecobroEsquemaManager);
        when(mockProxyFactory.proxy(RecobroPoliticaDeAcuerdosApi.class)).thenReturn(mockRecobroPoliticaDeAcuerdoManager);
        when(mockProxyFactory.proxy(UsuarioApi.class)).thenReturn(mockUsuarioApi);
        childBefore();
    }

    @After
    public void after() {
        childAfter();
        random = null;
        reset(mockProxyFactory);
        reset(mockRecobroAgenciaManager);
        reset(mockDiccionarioManager);
        reset(mockRecobroEsquemaManager);
        reset(mockRecobroPoliticaDeAcuerdoManager);
        reset(mockUsuarioApi);
        
    }

}
