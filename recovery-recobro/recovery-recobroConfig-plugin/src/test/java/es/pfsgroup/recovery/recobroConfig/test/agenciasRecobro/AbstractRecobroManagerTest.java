package es.pfsgroup.recovery.recobroConfig.test.agenciasRecobro;

import static org.mockito.Mockito.reset;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.Mock;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dao.api.RecobroAgenciaDao;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroEsquemaDao;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dao.api.RecobroPoliticaDeAcuerdosDao;
import es.pfsgroup.recovery.recobroConfig.test.AbstractRecobroConfigTest;

public abstract class AbstractRecobroManagerTest extends AbstractRecobroConfigTest{
	
	@Mock
    protected ApiProxyFactory mockProxyFactory;
	
	
	@Mock
	protected RecobroAgenciaDao mockRecobroAgenciaDao;
	
	@Mock
	protected RecobroEsquemaDao mockRecobroEsquemaDao;
	
	@Mock 
	protected Page mockPagina;
	
	@Mock
	protected RecobroPoliticaDeAcuerdosDao mockRecobroPoliticaDeAcuerdosDao;
	
	@Mock
	protected GenericABMDao mockGenericDao;
	
	protected Long idAgencia;
	
	protected RecobroAgencia agencia;
	
	/*
     * Inicialización genérica de todos los tests
     */
    @Before
    public void before() {
        random = new Random();
        agencia = new RecobroAgencia();
        idAgencia = random.nextLong();
        childBefore();
    }

    @After
    public void after() {
        random = null;
        reset(mockProxyFactory);
        reset(mockRecobroAgenciaDao);
        reset(mockPagina);
        idAgencia=null;
        agencia=null;
        childAfter();
        reset(mockRecobroEsquemaDao);
        reset(mockGenericDao);
        reset(mockRecobroPoliticaDeAcuerdosDao);
       
    }


}
