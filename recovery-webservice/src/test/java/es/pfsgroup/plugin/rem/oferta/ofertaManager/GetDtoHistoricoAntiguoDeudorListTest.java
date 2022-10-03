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

public class GetDtoHistoricoAntiguoDeudorListTest {
	
	@Mock
    private OfertaManager ofertaManager;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }
    
    @Test
    public void givenIncorrectIdOferta_whenHistoricoAntiguoDeudorHasRecords_thenReturnEmptyList() {
    	
    	List<DtoHistoricoAntiguoDeudor> dtoHistoricoAntiguoDeudorList = new ArrayList<DtoHistoricoAntiguoDeudor>();

    	Mockito.when(ofertaManager.getDtoHistoricoAntiguoDeudorList(0L)).thenReturn(dtoHistoricoAntiguoDeudorList);
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorList(0L);

    	assertEquals(returnDtoHistoricoAntiguoDeudorList, dtoHistoricoAntiguoDeudorList);
    	
    }
    //https://www.baeldung.com/java-test-driven-list
    
    @Test
    public void givenCorrectIdOferta_whenHistoricoAntiguoDeudorHasRecords_thenReturnRecords() {
    	
    	Auditoria auditoria = new Auditoria();
    	auditoria.setFechaCrear(new Date());
    	auditoria.setUsuarioCrear("TDD");
    	auditoria.setBorrado(false);
    	
    	DDSinSiNo ddSinSiNo = new DDSinSiNo();
    	ddSinSiNo.setId(1L);
    	ddSinSiNo.setCodigo("02");
    	ddSinSiNo.setDescripcion("No");
    	ddSinSiNo.setDescripcionLarga("No");
    	
    	Oferta oferta = new Oferta();
    	oferta.setId(0L);
    	
    	HistoricoAntiguoDeudor historicoAntiguoDeudor = new HistoricoAntiguoDeudor();
    	historicoAntiguoDeudor.setId(1L);
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

    	Mockito.when(ofertaManager.getDtoHistoricoAntiguoDeudorList(1L)).thenReturn(dtoHistoricoAntiguoDeudorList);
    	
    	List<DtoHistoricoAntiguoDeudor> returnDtoHistoricoAntiguoDeudorList = ofertaManager.getDtoHistoricoAntiguoDeudorList(1L);

    	assertEquals(returnDtoHistoricoAntiguoDeudorList, dtoHistoricoAntiguoDeudorList);
    	
    }
    //Ejemplos
    
    /*@Test
    public void givenOfertaWithWrongParameters_whenOfertaIsPrincipal_thenReturnFalse() {
    	
    	DDCartera cartera = new DDCartera();
    	cartera.setId(0L);
    	cartera.setCodigo(DDCartera.CODIGO_CARTERA_BANKIA);
    	
    	Activo activo = new Activo();
    	activo.setId(0L);
    	activo.setCartera(cartera);
    	
    	DDTipoOferta tipoOferta = new DDTipoOferta();
    	tipoOferta.setId(0L);
    	tipoOferta.setCodigo(DDTipoOferta.CODIGO_ALQUILER);
    	
    	DDClaseOferta claseOferta = new DDClaseOferta();
    	claseOferta.setId(0L);
    	claseOferta.setCodigo(DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
    	
    	Oferta oferta = new Oferta();
    	oferta.setId(0L);
    	oferta.setTipoOferta(tipoOferta);
    	oferta.setClaseOferta(claseOferta);
    	
    	ActivoOferta.ActivoOfertaPk activoOfertaPk = new ActivoOferta.ActivoOfertaPk();
    	activoOfertaPk.setActivo(activo);
    	activoOfertaPk.setOferta(oferta);
    	
    	ActivoOferta activoOferta = new ActivoOferta();
    	activoOferta.setPrimaryKey(activoOfertaPk);
    	
    	List<ActivoOferta> activoOfertaList = new ArrayList<ActivoOferta>();
    	activoOfertaList.add(activoOferta);
    	
    	oferta.setActivosOferta(activoOfertaList);
    	
    	Boolean result = ofertaManager.isOfertaPrincipal(oferta);
    	
    	assertEquals(result, Boolean.FALSE);
    	
    }
    
    @Test
    public void givenOfertaWithWrongParameters_whenOfertaIsNotPrincipal_thenReturnFalse() {
    	
    	DDCartera cartera = new DDCartera();
    	cartera.setId(0L);
    	cartera.setCodigo(DDCartera.CODIGO_CARTERA_BANKIA);
    	
    	Activo activo = new Activo();
    	activo.setId(0L);
    	activo.setCartera(cartera);
    	
    	DDTipoOferta tipoOferta = new DDTipoOferta();
    	tipoOferta.setId(0L);
    	tipoOferta.setCodigo(DDTipoOferta.CODIGO_ALQUILER_NO_COMERCIAL);
    	
    	DDClaseOferta claseOferta = new DDClaseOferta();
    	claseOferta.setId(0L);
    	claseOferta.setCodigo(DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE);
    	
    	Oferta oferta = new Oferta();
    	oferta.setId(0L);
    	oferta.setTipoOferta(tipoOferta);
    	oferta.setClaseOferta(claseOferta);
    	
    	ActivoOferta.ActivoOfertaPk activoOfertaPk = new ActivoOferta.ActivoOfertaPk();
    	activoOfertaPk.setActivo(activo);
    	activoOfertaPk.setOferta(oferta);
    	
    	ActivoOferta activoOferta = new ActivoOferta();
    	activoOferta.setPrimaryKey(activoOfertaPk);
    	
    	List<ActivoOferta> activoOfertaList = new ArrayList<ActivoOferta>();
    	activoOfertaList.add(activoOferta);
    	
    	oferta.setActivosOferta(activoOfertaList);
    	
    	Boolean result = ofertaManager.isOfertaPrincipal(oferta);
    	
    	assertEquals(result, Boolean.FALSE);
    	
    }
    
    @Test
    public void givenOfertaWithCorrectParameters_whenOfertaIsNotPrincipal_thenReturnFalse() {
    	
    	DDCartera cartera = new DDCartera();
    	cartera.setId(0L);
    	cartera.setCodigo(DDCartera.CODIGO_CARTERA_LIBERBANK);
    	
    	Activo activo = new Activo();
    	activo.setId(0L);
    	activo.setCartera(cartera);
    	
    	DDTipoOferta tipoOferta = new DDTipoOferta();
    	tipoOferta.setId(0L);
    	tipoOferta.setCodigo(DDTipoOferta.CODIGO_VENTA);
    	
    	DDClaseOferta claseOferta = new DDClaseOferta();
    	claseOferta.setId(0L);
    	claseOferta.setCodigo(DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL);
    	
    	Oferta oferta = new Oferta();
    	oferta.setId(0L);
    	oferta.setTipoOferta(tipoOferta);
    	oferta.setClaseOferta(claseOferta);
    	
    	ActivoOferta.ActivoOfertaPk activoOfertaPk = new ActivoOferta.ActivoOfertaPk();
    	activoOfertaPk.setActivo(activo);
    	activoOfertaPk.setOferta(oferta);
    	
    	ActivoOferta activoOferta = new ActivoOferta();
    	activoOferta.setPrimaryKey(activoOfertaPk);
    	
    	List<ActivoOferta> activoOfertaList = new ArrayList<ActivoOferta>();
    	activoOfertaList.add(activoOferta);
    	
    	oferta.setActivosOferta(activoOfertaList);
    	
    	Boolean result = ofertaManager.isOfertaPrincipal(oferta);
    	
    	assertEquals(result, Boolean.FALSE);
    	
    }
    
    @Test
    public void givenOfertaWithCorrectParameters_whenOfertaIsPrincipal_thenReturnTrue() {
    	
    	DDCartera cartera = new DDCartera();
    	cartera.setId(0L);
    	cartera.setCodigo(DDCartera.CODIGO_CARTERA_LIBERBANK);
    	
    	Activo activo = new Activo();
    	activo.setId(0L);
    	activo.setCartera(cartera);
    	
    	DDTipoOferta tipoOferta = new DDTipoOferta();
    	tipoOferta.setId(0L);
    	tipoOferta.setCodigo(DDTipoOferta.CODIGO_VENTA);
    	
    	DDClaseOferta claseOferta = new DDClaseOferta();
    	claseOferta.setId(0L);
    	claseOferta.setCodigo(DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
    	
    	Oferta oferta = new Oferta();
    	oferta.setId(0L);
    	oferta.setTipoOferta(tipoOferta);
    	oferta.setClaseOferta(claseOferta);
    	
    	ActivoOferta.ActivoOfertaPk activoOfertaPk = new ActivoOferta.ActivoOfertaPk();
    	activoOfertaPk.setActivo(activo);
    	activoOfertaPk.setOferta(oferta);
    	
    	ActivoOferta activoOferta = new ActivoOferta();
    	activoOferta.setPrimaryKey(activoOfertaPk);
    	
    	List<ActivoOferta> activoOfertaList = new ArrayList<ActivoOferta>();
    	activoOfertaList.add(activoOferta);
    	
    	oferta.setActivosOferta(activoOfertaList);
    	
    	Boolean result = ofertaManager.isOfertaPrincipal(oferta);
    	
    	assertEquals(result, Boolean.TRUE);
    	
    }*/
    
}