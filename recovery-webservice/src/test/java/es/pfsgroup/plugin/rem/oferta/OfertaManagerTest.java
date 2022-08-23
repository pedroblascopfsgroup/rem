package es.pfsgroup.plugin.rem.oferta;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.MockitoAnnotations;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;

public class OfertaManagerTest {

	@InjectMocks
    private OfertaManager ofertaManager;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }
    
    @Test
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
    	
    }
}
