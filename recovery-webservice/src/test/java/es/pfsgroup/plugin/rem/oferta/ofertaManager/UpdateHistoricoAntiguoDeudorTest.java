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
import es.pfsgroup.plugin.rem.constants.TareaProcedimientoConstants;
import es.pfsgroup.plugin.rem.model.DtoHistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;

public class UpdateHistoricoAntiguoDeudorTest {

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
    public void givenNullDtoHistoricoAntiguoDeudorIdHistorico_thenReturnFalse() {
    	
    	DtoHistoricoAntiguoDeudor dtoHistoricoAntiguoDeudor = new DtoHistoricoAntiguoDeudor();
    	dtoHistoricoAntiguoDeudor.setIdHistorico(null);
    	
    	boolean result = ofertaManager.updateHistoricoAntiguoDeudor(dtoHistoricoAntiguoDeudor);

		assertFalse(result);
    }
    
    @Test
    public void givenCorrectDtoHistoricoAntiguoDeudor_whenHistoricoAntiguoDeudorIsNull_thenReturnFalse() {
    	
    	DDSinSiNo ddSinSiNo = new DDSinSiNo();
    	ddSinSiNo.setCodigo("01");
    	
    	DtoHistoricoAntiguoDeudor dtoHistoricoAntiguoDeudor = new DtoHistoricoAntiguoDeudor();
    	dtoHistoricoAntiguoDeudor.setIdHistorico(1L);
    	dtoHistoricoAntiguoDeudor.setCodigoLocalizable(ddSinSiNo.getCodigo());
    	dtoHistoricoAntiguoDeudor.setFechaIlocalizable(new Date());
    	dtoHistoricoAntiguoDeudor.setFechaCreacion(new Date());
    	
    	Mockito.when(genericDao.get(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Filter.class))).thenReturn(null);
    	
    	boolean result = ofertaManager.updateHistoricoAntiguoDeudor(dtoHistoricoAntiguoDeudor);

		assertFalse(result);
    }
    
    @Test
    public void givenCorrectDtoHistoricoAntiguoDeudor_whenHistoricoAntiguoDeudorOfertaIsNull_thenReturnFalse() {
    	
    	DDSinSiNo ddSinNo = new DDSinSiNo();
    	ddSinNo.setCodigo("02");
    	
    	DtoHistoricoAntiguoDeudor dtoHistoricoAntiguoDeudor = new DtoHistoricoAntiguoDeudor();
    	dtoHistoricoAntiguoDeudor.setIdHistorico(1L);
    	dtoHistoricoAntiguoDeudor.setCodigoLocalizable(ddSinNo.getCodigo());
    	dtoHistoricoAntiguoDeudor.setFechaIlocalizable(new Date());
    	dtoHistoricoAntiguoDeudor.setFechaCreacion(new Date());
    	
    	DDSinSiNo ddSinSi = new DDSinSiNo();
    	ddSinSi.setCodigo("01");
    	
    	HistoricoAntiguoDeudor historicoAntiguoDeudor = new HistoricoAntiguoDeudor();
    	historicoAntiguoDeudor.setId(1L);
    	historicoAntiguoDeudor.setOferta(null);
    	historicoAntiguoDeudor.setLocalizable(ddSinSi);
    	historicoAntiguoDeudor.setFechaIlocalizable(new Date());
    	historicoAntiguoDeudor.setVersion(0L);
    	historicoAntiguoDeudor.setAuditoria(Auditoria.getNewInstance());
    	
    	Mockito.when(genericDao.get(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Filter.class))).thenReturn(null);
    	
    	boolean result = ofertaManager.updateHistoricoAntiguoDeudor(dtoHistoricoAntiguoDeudor);

		assertFalse(result);
    }
    
    @Test
    public void givenCorrectDtoHistoricoAntiguoDeudor_whenHistoricoAntiguoDeudorIsCorrect_thenReturnTrue() {
    	
    	DDSinSiNo ddSinNo = new DDSinSiNo();
    	ddSinNo.setCodigo("02");
    	
    	DtoHistoricoAntiguoDeudor dtoHistoricoAntiguoDeudor = new DtoHistoricoAntiguoDeudor();
    	dtoHistoricoAntiguoDeudor.setIdHistorico(1L);
    	dtoHistoricoAntiguoDeudor.setCodigoLocalizable(ddSinNo.getCodigo());
    	dtoHistoricoAntiguoDeudor.setFechaIlocalizable(new Date());
    	dtoHistoricoAntiguoDeudor.setFechaCreacion(new Date());
    	
    	DDSinSiNo ddSinSi = new DDSinSiNo();
    	ddSinSi.setCodigo("01");

    	DDEstadoExpedienteBc ddEstadoExpedienteBcJudicializarComitePosesiones = new DDEstadoExpedienteBc();
    	ddEstadoExpedienteBcJudicializarComitePosesiones.setId(62L);
    	ddEstadoExpedienteBcJudicializarComitePosesiones.setCodigo("062");
    	
    	ExpedienteComercial expedienteComercial = new ExpedienteComercial();
    	expedienteComercial.setId(1L);
    	expedienteComercial.setEstadoBc(ddEstadoExpedienteBcJudicializarComitePosesiones);
    	
    	Oferta oferta = new Oferta();
    	oferta.setId(1L);
    	oferta.setNumOferta(1L);
    	oferta.setExpedienteComercial(expedienteComercial);
    	
    	HistoricoAntiguoDeudor historicoAntiguoDeudor = new HistoricoAntiguoDeudor();
    	historicoAntiguoDeudor.setId(1L);
    	historicoAntiguoDeudor.setOferta(oferta);
    	historicoAntiguoDeudor.setLocalizable(ddSinSi);
    	historicoAntiguoDeudor.setFechaIlocalizable(new Date());
    	historicoAntiguoDeudor.setVersion(0L);
    	historicoAntiguoDeudor.setAuditoria(Auditoria.getNewInstance());
    	
    	Mockito.when(genericDao.get(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(Filter.class))).thenReturn(historicoAntiguoDeudor);
    	Mockito.when(ofertaDao.tieneTareaActiva(Mockito.eq(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_BLOQUEO_SCREENING), Mockito.any(String.class))).thenReturn(false);
    	Mockito.when(ofertaDao.tieneTareaActiva(Mockito.eq(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_BLOQUEO_SCORING), Mockito.any(String.class))).thenReturn(false);
    	
    	expedienteComercial.setBloqueado(0);
    	Mockito.doNothing().when(expedienteComercialApi).guardarDesbloqueoExpediente(expedienteComercial);
    	
    	Mockito.when(genericDao.save(Mockito.eq(HistoricoAntiguoDeudor.class), Mockito.any(HistoricoAntiguoDeudor.class))).thenReturn(historicoAntiguoDeudor);
    	Mockito.doNothing().when(hibernateUtils).flushSession();
    	Mockito.when(caixaBcRestClient.callReplicateOferta(1L)).thenReturn(true);
    	
    	boolean result = ofertaManager.updateHistoricoAntiguoDeudor(dtoHistoricoAntiguoDeudor);

		assertTrue(result);
    }

}
