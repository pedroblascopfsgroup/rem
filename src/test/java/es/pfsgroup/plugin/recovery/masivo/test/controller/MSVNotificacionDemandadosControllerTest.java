package es.pfsgroup.plugin.recovery.masivo.test.controller;

import static org.junit.Assert.*;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import junit.framework.Assert;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVNotificacionDemandadosManager;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVNotificacionDemandadosApi;
import es.pfsgroup.plugin.recovery.masivo.controller.MSVNotificacionDemandadosController;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVFechasNotificacionDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoJuicio;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVDireccionFechaNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumen;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumenPersona;


/**
 * Tests unitarios de la clase MSVNotificacionDemandadosController
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class MSVNotificacionDemandadosControllerTest {
	
	@InjectMocks MSVNotificacionDemandadosController msvNotificacionDemandadosController;
	@Mock private ApiProxyFactory mockProxyFactory;
	@Mock private MSVNotificacionDemandadosManager mockMSVNotificacionDemandadosManager;
	Random r = new Random();
	
    /**
     * Comprobamos el m�todo String abreVentanaNotificacion(ModelMap map, Long idProcedimiento)
     */
    @Test    
    public void testAbreVentanaNotificacion(){

    	ModelMap map = new ModelMap();
    	Long idProcedimiento = r.nextLong();
    	String url = msvNotificacionDemandadosController.abreVentanaNotificacion(map, idProcedimiento);
    	
    	assertNotNull(url);
    	assertEquals("El jsp que se devuelve no es el correcto", MSVNotificacionDemandadosController.JSP_VENTANA_NOTIFICACION, url);
    	assertNotNull(map.get("idProcedimiento"));
    }
    
    /**
     * Comprobamos el m�todo String getResumenFechasNotificacionData(ModelMap map, Long idProcedimiento)
     * @throws Exception 
     */
    @Test    
    public void testGetResumenFechasNotificacionData() throws Exception{

    	ModelMap map = new ModelMap();
    	Long idProcedimiento = r.nextLong();
    	MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
    	dto.setIdProcedimiento(idProcedimiento);
    	List<MSVInfoResumen> msvInfoResumen = new ArrayList<MSVInfoResumen>();
    	
    	when(mockProxyFactory.proxy(MSVNotificacionDemandadosApi.class)).thenReturn(mockMSVNotificacionDemandadosManager);
		when(mockMSVNotificacionDemandadosManager.getResumenNotificaciones(idProcedimiento)).thenReturn(msvInfoResumen);
    	
    	String url = msvNotificacionDemandadosController.getResumenFechasNotificacionData(map, dto);
    	
    	assertNotNull(url);
    	assertEquals("El jsp que se devuelve no es el correcto", MSVNotificacionDemandadosController.JSON_RESUMEN_FECHAS_NOTIFICACION, url);
    	assertNotNull(map.get("data"));
    }
    
    /**
     * Comprobamos el m�todo String abreVentanaNotificacionDomicilios()
     */
    @Test    
    public void testAbreVentanaNotificacionDomicilios(){
    	
    	String url = msvNotificacionDemandadosController.abreVentanaNotificacionDomicilios();
    	assertEquals("El jsp que se devuelve no es el correcto", MSVNotificacionDemandadosController.JSP_VENTANA_NOTIFICACION_DOMICILIOS, url);
    }
    
    /**
     * Test del m�todo String getDetalleFechasNotificacionData(ModelMap map, MSVFechasNotificacionDto dto) throws Exception
     */
    @Test
    public void testGetDetalleFechasNotificacionData() throws Exception{
    	
    	ModelMap map = new ModelMap();
    	Random r = new Random();
    	Long idProcedimiento = r.nextLong();
    	Long idPersona = r.nextLong();
    	MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
    	dto.setIdProcedimiento(idProcedimiento);
    	dto.setIdPersona(idProcedimiento);
    	List<MSVInfoResumenPersona> msvInfoResumenPersona = new ArrayList<MSVInfoResumenPersona>();
    	
    	when(mockProxyFactory.proxy(MSVNotificacionDemandadosApi.class)).thenReturn(mockMSVNotificacionDemandadosManager);
		when(mockMSVNotificacionDemandadosManager.getDetalleNotificaciones(idProcedimiento, idPersona)).thenReturn(msvInfoResumenPersona);
    	
    	String url = msvNotificacionDemandadosController.getDetalleFechasNotificacionData(map, dto);
    	
    	assertNotNull(url);
    	assertEquals("El jsp que se devuelve no es el correcto", MSVNotificacionDemandadosController.JSON_DETALLE_FECHAS_NOTIFICACION, url);
    	assertNotNull(map.get("data"));
    	
    }
    
    /**
     * Test del m�todo String getHistoricoDetalleFechasNotificacionData(ModelMap map, MSVFechasNotificacionDto dto) throws Exception
     */
    @Test
    public void testGetHistoricoDetalleFechasNotificacionData() throws Exception{
    	
    	ModelMap map = new ModelMap();
    	MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
    	List<MSVDireccionFechaNotificacion> msvDireccionFechaNotificacion = new ArrayList<MSVDireccionFechaNotificacion>();
    	
    	when(mockProxyFactory.proxy(MSVNotificacionDemandadosApi.class)).thenReturn(mockMSVNotificacionDemandadosManager);
		when(mockMSVNotificacionDemandadosManager.getHistoricoDetalleNotificaciones(dto)).thenReturn(msvDireccionFechaNotificacion);
    	
    	String url = msvNotificacionDemandadosController.getHistoricoDetalleFechasNotificacionData(map, dto);
    	
    	assertNotNull(url);
    	assertEquals("El jsp que se devuelve no es el correcto", MSVNotificacionDemandadosController.JSON_HISTORICO_DETALLE_FECHAS_NOTIFICACION, url);
    	assertNotNull(map.get("data"));
    	assertEquals("El objeto data no es correcto", ArrayList.class, map.get("data").getClass());
    }
    
    /**
     * Test del m�todo String updateNotificacion(ModelMap map, MSVFechasNotificacionDto dto) throws Exception
     * @throws Exception
     */
    @Test
    public void tesUpdateNotificacion() throws Exception{
    	
    	ModelMap map = new ModelMap();
    	MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
    	MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = new MSVDireccionFechaNotificacion();
    	
    	when(mockProxyFactory.proxy(MSVNotificacionDemandadosApi.class)).thenReturn(mockMSVNotificacionDemandadosManager);
		when(mockMSVNotificacionDemandadosManager.updateNotificacion(dto)).thenReturn(msvDireccionFechaNotificacion);
		
		String url = msvNotificacionDemandadosController.updateNotificacion(map, dto);
    	
    	assertNotNull(url);
    	assertEquals("El jsp que se devuelve no es el correcto", MSVNotificacionDemandadosController.JSON_UPDATE_NOTIFICACION, url);
    	assertEquals("El objeto data no es correcto", MSVDireccionFechaNotificacion.class, map.get("data").getClass());
    	
    }
    
    /**
     * Test del m�todo String insertNotificacion(ModelMap map, MSVFechasNotificacionDto dto) throws Exception
     * @throws Exception
     */
    @Test
    public void testInsertNotificacion() throws Exception{
    	
    	ModelMap map = new ModelMap();
    	MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
    	MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = new MSVDireccionFechaNotificacion();
    	
    	when(mockProxyFactory.proxy(MSVNotificacionDemandadosApi.class)).thenReturn(mockMSVNotificacionDemandadosManager);
		when(mockMSVNotificacionDemandadosManager.insertNotificacion(dto)).thenReturn(msvDireccionFechaNotificacion);
		
		String url = msvNotificacionDemandadosController.insertNotificacion(map, dto);
    	
    	assertNotNull(url);
    	assertEquals("El jsp que se devuelve no es el correcto", MSVNotificacionDemandadosController.JSON_UPDATE_NOTIFICACION, url);
    	assertEquals("El objeto data no es correcto", MSVDireccionFechaNotificacion.class, map.get("data").getClass());
    	
    }
}
