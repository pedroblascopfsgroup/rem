package es.pfsgroup.plugin.rem.oferta.ofertaManager;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.DtoHistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.HistoricoAntiguoDeudor;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;

public class GetDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorListTest {

	@Mock
    private OfertaManager ofertaManager;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }
    
    @Test
    public void givenHistoricoAntiguoDeudorList_whenHistoricoAntiguoDeudorListHasRecords_thenReturnRecordsInDtoHistoricoAntiguoDeudorList() {
    	
    	Auditoria auditoria = new Auditoria();
    	auditoria.setFechaCrear(new Date());
    	auditoria.setUsuarioCrear("TDD");
    	auditoria.setBorrado(false);
    	
    	DDSinSiNo ddSinSiNo = new DDSinSiNo();
    	ddSinSiNo.setId(0L);
    	ddSinSiNo.setCodigo("02");
    	ddSinSiNo.setDescripcion("No");
    	ddSinSiNo.setDescripcionLarga("No");
    	
    	Oferta oferta = new Oferta();
    	oferta.setId(0L);
    	
    	HistoricoAntiguoDeudor historicoAntiguoDeudor = new HistoricoAntiguoDeudor();
    	historicoAntiguoDeudor.setId(0L);
    	historicoAntiguoDeudor.setOferta(oferta);
    	historicoAntiguoDeudor.setLocalizable(ddSinSiNo);
    	historicoAntiguoDeudor.setFechaIlocalizable(new Date());
    	historicoAntiguoDeudor.setAuditoria(auditoria);
    	
    	List<HistoricoAntiguoDeudor> historicoAntiguoDeudorList = new ArrayList<HistoricoAntiguoDeudor>();
    	historicoAntiguoDeudorList.add(historicoAntiguoDeudor);
    	
    	DtoHistoricoAntiguoDeudor dtoHistoricoAntiguoDeudor = new DtoHistoricoAntiguoDeudor();
    	dtoHistoricoAntiguoDeudor.setIdHistorico(historicoAntiguoDeudor.getId());
    	dtoHistoricoAntiguoDeudor.setCodigoLocalizable(historicoAntiguoDeudor.getLocalizable().getCodigo());
    	dtoHistoricoAntiguoDeudor.setFechaIlocalizable(historicoAntiguoDeudor.getFechaIlocalizable());
    	
    	List<DtoHistoricoAntiguoDeudor> dtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();
    	dtoHistoricoAntiguoDeudorList.add(dtoHistoricoAntiguoDeudor);
    	
    	Mockito.when(ofertaManager.getDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorList(historicoAntiguoDeudorList)).thenReturn(dtoHistoricoAntiguoDeudorList);
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorListFromHistoricoAntiguoDeudorList(historicoAntiguoDeudorList);

    	assertEquals(returnDtoHistoricoAntiguoDeudorList, dtoHistoricoAntiguoDeudorList);
    	
    }
}
