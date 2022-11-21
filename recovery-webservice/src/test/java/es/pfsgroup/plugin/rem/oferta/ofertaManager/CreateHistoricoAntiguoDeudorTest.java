package es.pfsgroup.plugin.rem.oferta.ofertaManager;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.Date;

import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.DtoHistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;

public class CreateHistoricoAntiguoDeudorTest {
	
	@InjectMocks
    private OfertaManager ofertaManager;
	
	@Mock
	private OfertaDao ofertaDao;
	
	@Mock
	private GenericABMDao genericDao;
	
	@Mock
	private CaixaBcRestClient caixaBcRestClient;
	
	@Mock
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Mock
	private HibernateUtils hibernateUtils;
	
	@Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }
    
    @Test
    public void givenNullIdOferta_thenReturnFalse() {
    	
    	DDSinSiNo ddSinSiNo = new DDSinSiNo();
    	ddSinSiNo.setCodigo("02");
    	
    	DtoHistoricoAntiguoDeudor dtoHistoricoAntiguoDeudor = new DtoHistoricoAntiguoDeudor();
    	dtoHistoricoAntiguoDeudor.setIdHistorico(1L);
    	dtoHistoricoAntiguoDeudor.setCodigoLocalizable(ddSinSiNo.getCodigo());
    	dtoHistoricoAntiguoDeudor.setFechaIlocalizable(new Date());
    	dtoHistoricoAntiguoDeudor.setFechaCreacion(new Date());
    	
    	boolean result = ofertaManager.createHistoricoAntiguoDeudor(dtoHistoricoAntiguoDeudor, null);

		assertFalse(result);
    }
    
    @Test
    public void givenIncorrectIdOferta_thenReturnFalse() {
    	
    	DDSinSiNo ddSinSiNo = new DDSinSiNo();
    	ddSinSiNo.setCodigo("02");
    	
    	DtoHistoricoAntiguoDeudor dtoHistoricoAntiguoDeudor = new DtoHistoricoAntiguoDeudor();
    	dtoHistoricoAntiguoDeudor.setIdHistorico(1L);
    	dtoHistoricoAntiguoDeudor.setCodigoLocalizable(ddSinSiNo.getCodigo());
    	dtoHistoricoAntiguoDeudor.setFechaIlocalizable(new Date());
    	dtoHistoricoAntiguoDeudor.setFechaCreacion(new Date());
    	
    	Mockito.when(ofertaDao.get(0L)).thenReturn(null);
    	
    	boolean result = ofertaManager.createHistoricoAntiguoDeudor(dtoHistoricoAntiguoDeudor, 0L);

		assertFalse(result);
    }
    
    @Test
    public void givenCorrectIdOfertaAndtoHistoricoAntiguoDeudorWithData_thenSaveAndReturnTrue() {
    	
    	DDSinSiNo ddSinSiNo = new DDSinSiNo();
    	ddSinSiNo.setId(2L);
    	ddSinSiNo.setCodigo("02");
    	ddSinSiNo.setDescripcion("No");

    	DDEstadoExpedienteBc ddEstadoExpedienteBc = new DDEstadoExpedienteBc();
    	ddEstadoExpedienteBc.setId(1L);
    	ddEstadoExpedienteBc.setCodigo("01");
    	
    	ExpedienteComercial expedienteComercial = new ExpedienteComercial();
    	expedienteComercial.setId(1L);
    	expedienteComercial.setEstadoBc(ddEstadoExpedienteBc);
    	
    	Oferta oferta = new Oferta();
    	oferta.setId(1L);
    	oferta.setNumOferta(1L);
    	oferta.setExpedienteComercial(expedienteComercial);
    	
    	DtoHistoricoAntiguoDeudor dtoHistoricoAntiguoDeudor = new DtoHistoricoAntiguoDeudor();
    	dtoHistoricoAntiguoDeudor.setIdHistorico(1L);
    	dtoHistoricoAntiguoDeudor.setCodigoLocalizable(ddSinSiNo.getCodigo());
    	dtoHistoricoAntiguoDeudor.setFechaIlocalizable(new Date());
    	dtoHistoricoAntiguoDeudor.setFechaCreacion(new Date());
    	
    	Mockito.when(ofertaDao.get(1L)).thenReturn(oferta);
    	
    	DDEstadoExpedienteBc ddEstadoExpedienteBcJudicializarComitePosesiones = new DDEstadoExpedienteBc();
    	ddEstadoExpedienteBc.setId(62L);
    	ddEstadoExpedienteBc.setCodigo("062");
    	
    	Mockito.when(genericDao.get(Mockito.eq(DDEstadoExpedienteBc.class), Mockito.any(Filter.class))).thenReturn(ddEstadoExpedienteBcJudicializarComitePosesiones);
    	Mockito.when(genericDao.get(Mockito.eq(DDSinSiNo.class), Mockito.any(Filter.class))).thenReturn(ddSinSiNo);
    	
    	expedienteComercial.setBloqueado(1);
    	Mockito.doNothing().when(expedienteComercialApi).guardarBloqueoExpediente(expedienteComercial);
    	
    	HistoricoAntiguoDeudor historicoAntiguoDeudor = new HistoricoAntiguoDeudor();
    	historicoAntiguoDeudor.setId(1L);
    	historicoAntiguoDeudor.setOferta(oferta);
    	historicoAntiguoDeudor.setLocalizable(ddSinSiNo);
    	historicoAntiguoDeudor.setFechaIlocalizable(new Date());
    	historicoAntiguoDeudor.setVersion(0L);
    	historicoAntiguoDeudor.setAuditoria(Auditoria.getNewInstance());

    	Mockito.when(genericDao.save(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(HistoricoAntiguoDeudor.class))).thenReturn(historicoAntiguoDeudor);
    	Mockito.doNothing().when(hibernateUtils).flushSession();
    	Mockito.when(caixaBcRestClient.callReplicateOferta(1L)).thenReturn(true);
    	
    	boolean result = ofertaManager.createHistoricoAntiguoDeudor(dtoHistoricoAntiguoDeudor, 1L);

		assertTrue(result);
    }

}
