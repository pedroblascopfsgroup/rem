package es.pfsgroup.plugin.rem.oferta.ofertaManager;

import static org.junit.Assert.assertEquals;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.model.DtoHistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.HistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;

public class GetDtoHistoricoAntiguoDeudorListTest {
	
	@InjectMocks
    private OfertaManager ofertaManager;
	
	@Mock
	private GenericABMDao genericDao;

	private final Log logger = LogFactory.getLog(GetDtoHistoricoAntiguoDeudorListTest.class);
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }
    
    @Test
    public void givenNullIdOferta_thenReturnEmptyDtoHistoricoAntiguoDeudorList() {
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
		try {
			returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorList(null);
		} catch (IllegalAccessException iae) {
			logger.error(iae.getMessage());
		} catch (InvocationTargetException ite) {
			logger.error(ite.getMessage());
		}

    	assertEquals(new ArrayList<DtoHistoricoAntiguoDeudor>(), returnDtoHistoricoAntiguoDeudorList);
    }
    
    @Test
    public void givenIncorrectIdOferta_thenReturnEmptyDtoHistoricoAntiguoDeudorList_1() {
    	
    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(null);
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
		try {
			returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorList(0L);
		} catch (IllegalAccessException iae) {
			logger.error(iae.getMessage());
		} catch (InvocationTargetException ite) {
			logger.error(ite.getMessage());
		}

    	assertEquals(new ArrayList<DtoHistoricoAntiguoDeudor>(), returnDtoHistoricoAntiguoDeudorList);
    }
    
    @Test
    public void givenIncorrectIdOferta_thenReturnEmptyDtoHistoricoAntiguoDeudorList_2() {
    	
    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(new ArrayList<HistoricoAntiguoDeudor>());
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
		try {
			returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorList(0L);
		} catch (IllegalAccessException iae) {
			logger.error(iae.getMessage());
		} catch (InvocationTargetException ite) {
			logger.error(ite.getMessage());
		}

    	assertEquals(new ArrayList<DtoHistoricoAntiguoDeudor>(), returnDtoHistoricoAntiguoDeudorList);
    }
    
    @Test
    public void givenCorrectIdOferta_whenHistoricoAntiguoDeudorHasRecords_thenReturnDtoHistoricoAntiguoDeudorList() throws IllegalAccessException, InvocationTargetException {
    	
    	Auditoria auditoria = new Auditoria();
    	auditoria.setFechaCrear(new Date());
    	
    	DDSinSiNo ddSinSiNo = new DDSinSiNo();
    	ddSinSiNo.setCodigo("02");
    	
    	Oferta oferta = new Oferta();
    	oferta.setId(1L);
    	
    	HistoricoAntiguoDeudor historicoAntiguoDeudor = new HistoricoAntiguoDeudor();
    	historicoAntiguoDeudor.setId(1L);
    	historicoAntiguoDeudor.setOferta(oferta);
    	historicoAntiguoDeudor.setLocalizable(ddSinSiNo);
    	historicoAntiguoDeudor.setFechaIlocalizable(new Date());
    	historicoAntiguoDeudor.setAuditoria(auditoria);
    	
    	List<HistoricoAntiguoDeudor> historicoAntiguoDeudorList = new ArrayList<HistoricoAntiguoDeudor>();
    	historicoAntiguoDeudorList.add(historicoAntiguoDeudor);
    	
    	DtoHistoricoAntiguoDeudor dtoHistoricoAntiguoDeudor = new DtoHistoricoAntiguoDeudor();
    	beanUtilNotNull.copyProperties(dtoHistoricoAntiguoDeudor, historicoAntiguoDeudor);
    	dtoHistoricoAntiguoDeudor.setIdHistorico(historicoAntiguoDeudor.getId());
    	dtoHistoricoAntiguoDeudor.setCodigoLocalizable(historicoAntiguoDeudor.getLocalizable().getCodigo());
    	dtoHistoricoAntiguoDeudor.setFechaCreacion(historicoAntiguoDeudor.getAuditoria().getFechaCrear());
    	
    	List<DtoHistoricoAntiguoDeudor> dtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
    	dtoHistoricoAntiguoDeudorList.add(dtoHistoricoAntiguoDeudor);

    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(historicoAntiguoDeudorList);
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorList(1L);

    	Assertions.assertNotEmptyList(returnDtoHistoricoAntiguoDeudorList, "Error en GetDtoHistoricoAntiguoDeudorListTest: La lista 'List<DtoHistoricoAntiguoDeudor>' esta vacía");
    	
    	for(@SuppressWarnings("unused") DtoHistoricoAntiguoDeudor returnDtoHistoricoAntiguoDeudor : returnDtoHistoricoAntiguoDeudorList) {
    		Assertions.assertNotNull(returnDtoHistoricoAntiguoDeudorList, "Error en GetDtoHistoricoAntiguoDeudorListTest: El objeto 'DtoHistoricoAntiguoDeudor' es nulo");
    	}
    }
    
    @Test
    public void givenCorrectIdOferta_whenHistoricoAntiguoDeudorHasNoRecords_thenReturnEmptyDtoHistoricoAntiguoDeudorList_1() {
    	
    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(null);
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
		try {
			returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorList(1L);
		} catch (IllegalAccessException iae) {
			logger.error(iae.getMessage());
		} catch (InvocationTargetException ite) {
			logger.error(ite.getMessage());
		}

    	assertEquals(new ArrayList<DtoHistoricoAntiguoDeudor>(), returnDtoHistoricoAntiguoDeudorList);
    }
    
    @Test
    public void givenCorrectIdOferta_whenHistoricoAntiguoDeudorHasNoRecords_thenReturnEmptyDtoHistoricoAntiguoDeudorList_2() {
    	
    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(new ArrayList<HistoricoAntiguoDeudor>());
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
		try {
			returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorList(1L);
		} catch (IllegalAccessException iae) {
			logger.error(iae.getMessage());
		} catch (InvocationTargetException ite) {
			logger.error(ite.getMessage());
		}

    	assertEquals(new ArrayList<DtoHistoricoAntiguoDeudor>(), returnDtoHistoricoAntiguoDeudorList);
    }
    
}