package es.pfsgroup.plugin.rem.oferta.ofertaManager;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
import es.pfsgroup.plugin.rem.model.HistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;

public class GetHistoricoAntiguoDeudorListTest {
	
	@InjectMocks
    private OfertaManager ofertaManager;
	
	@Mock
	private GenericABMDao genericDao;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }

	@Test
    public void givenNullIdOferta_thenReturnEmptyHistoricoAntiguoDeudorList() {
    	
		List<HistoricoAntiguoDeudor> returnHistoricoAntiguoDeudorList = ofertaManager.getHistoricoAntiguoDeudorList(null);

    	assertEquals(new ArrayList<HistoricoAntiguoDeudor>(), returnHistoricoAntiguoDeudorList);
    }
	
	@Test
    public void givenIncorrectIdOferta_thenReturnNull() {
    	
    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(null);
    	
    	List<HistoricoAntiguoDeudor> returnHistoricoAntiguoDeudorList = ofertaManager.getHistoricoAntiguoDeudorList(0L);

    	assertEquals(null, returnHistoricoAntiguoDeudorList);
    }
    
    @Test
    public void givenIncorrectIdOferta_thenReturnEmptyHistoricoAntiguoDeudorList() {
    	
    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(new ArrayList<HistoricoAntiguoDeudor>());
    	
    	List<HistoricoAntiguoDeudor> returnHistoricoAntiguoDeudorList = ofertaManager.getHistoricoAntiguoDeudorList(0L);

    	assertEquals(new ArrayList<HistoricoAntiguoDeudor>(), returnHistoricoAntiguoDeudorList);
    }
    
    @Test
    public void givenCorrectIdOferta_whenHistoricoAntiguoDeudorHasRecords_thenReturnHistoricoAntiguoDeudorList() {
    	
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

    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(historicoAntiguoDeudorList);
    	
    	List<HistoricoAntiguoDeudor> returnHistoricoAntiguoDeudorList = ofertaManager.getHistoricoAntiguoDeudorList(1L);

    	Assertions.assertNotEmptyList(returnHistoricoAntiguoDeudorList, "Error en GetHistoricoAntiguoDeudorListTest: La lista 'List<HistoricoAntiguoDeudor>' esta vacía");
    	
    	for(HistoricoAntiguoDeudor returnHistoricoAntiguoDeudor : returnHistoricoAntiguoDeudorList) {
    		Assertions.assertNotNull(returnHistoricoAntiguoDeudor, "Error en GetHistoricoAntiguoDeudorListTest: El objeto 'HistoricoAntiguoDeudor' es nulo");
    	}
    }
    
    @Test
    public void givenCorrectIdOferta_whenHistoricoAntiguoDeudorHasNoRecords_thenReturnNull() {
    	
    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(null);
    	
    	List<HistoricoAntiguoDeudor> returnHistoricoAntiguoDeudorList = ofertaManager.getHistoricoAntiguoDeudorList(1L);

    	assertEquals(null, returnHistoricoAntiguoDeudorList);
    }
    
    @Test
    public void givenCorrectIdOferta_whenHistoricoAntiguoDeudorHasNoRecords_thenReturnEmptyHistoricoAntiguoDeudorList() {
    	
    	Mockito.when(genericDao.getListOrdered(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Order.class), Mockito.any(Filter.class))).thenReturn(new ArrayList<HistoricoAntiguoDeudor>());
    	
    	List<HistoricoAntiguoDeudor> returnHistoricoAntiguoDeudorList = ofertaManager.getHistoricoAntiguoDeudorList(1L);

    	assertEquals(new ArrayList<HistoricoAntiguoDeudor>(), returnHistoricoAntiguoDeudorList);
    }
}
