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
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.model.DtoHistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.HistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;

public class GetDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorListTest {

	@InjectMocks
    private OfertaManager ofertaManager;
	
	@Mock
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	private final Log logger = LogFactory.getLog(GetDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorListTest.class);

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }
    
    @Test
    public void givenNullHistoricoAntiguoDeudorList_thenReturnEmptyDtoHistoricoAntiguoDeudorList() {
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
		try {
			returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorList(null);
		} catch (IllegalAccessException iae) {
			logger.error(iae.getMessage());
		} catch (InvocationTargetException ite) {
			logger.error(ite.getMessage());
		}

    	assertEquals(new ArrayList<DtoHistoricoAntiguoDeudor>(), returnDtoHistoricoAntiguoDeudorList);
    	
    }
    
    @Test
    public void givenEmptyHistoricoAntiguoDeudorList_thenReturnEmptyDtoHistoricoAntiguoDeudorList() {
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
		try {
			returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorList(new ArrayList<HistoricoAntiguoDeudor>());
		} catch (IllegalAccessException iae) {
			logger.error(iae.getMessage());
		} catch (InvocationTargetException ite) {
			logger.error(ite.getMessage());
		}

    	assertEquals(new ArrayList<DtoHistoricoAntiguoDeudor>(), returnDtoHistoricoAntiguoDeudorList);
    	
    }
    
    @Test
    public void givenHistoricoAntiguoDeudorList_whenHistoricoAntiguoDeudorListHasRecords_thenReturnRecordsInDtoHistoricoAntiguoDeudorList() {
    	
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
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
		try {
			returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorList(historicoAntiguoDeudorList);
		} catch (IllegalAccessException iae) {
			logger.error(iae.getMessage());
		} catch (InvocationTargetException ite) {
			logger.error(ite.getMessage());
		}

    	Assertions.assertNotEmptyList(returnDtoHistoricoAntiguoDeudorList, "Error en GetDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorListTest: La lista 'List<DtoHistoricoAntiguoDeudor>' esta vacía");
    	
    	for(@SuppressWarnings("unused") DtoHistoricoAntiguoDeudor returnDtoHistoricoAntiguoDeudor : returnDtoHistoricoAntiguoDeudorList) {
    		Assertions.assertNotNull(returnDtoHistoricoAntiguoDeudorList, "Error en GetDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorListTest: El objeto 'DtoHistoricoAntiguoDeudor' es nulo");
    	}
    	
    }
    
    @Test(expected = IllegalAccessException.class)
    public void givenHistoricoAntiguoDeudorList_whenHistoricoAntiguoDeudorListHasRecords_butBeanUtilNotNullFails_thenReturnIllegalAccessException() throws IllegalAccessException {
    	
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

    	try {
			Mockito.doThrow(IllegalAccessException.class).when(beanUtilNotNull).copyProperties(Mockito.any(DtoHistoricoAntiguoDeudor.class), Mockito.any(HistoricoAntiguoDeudor.class));
		} catch (InvocationTargetException e) {}
    	
    	try {
			@SuppressWarnings("unused")
			List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorList(historicoAntiguoDeudorList);
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}
    	
    }
    
    @Test(expected = InvocationTargetException.class)
    public void givenHistoricoAntiguoDeudorList_whenHistoricoAntiguoDeudorListHasRecords_butBeanUtilNotNullFails_thenReturnInvocationTargetException() throws InvocationTargetException {
    	
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

    	try {
			Mockito.doThrow(InvocationTargetException.class).when(beanUtilNotNull).copyProperties(Mockito.any(DtoHistoricoAntiguoDeudor.class), Mockito.any(HistoricoAntiguoDeudor.class));
		} catch (IllegalAccessException e) {}
    	
    	try {
			@SuppressWarnings("unused")
			List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorList(historicoAntiguoDeudorList);
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		}
    	
    }
}
