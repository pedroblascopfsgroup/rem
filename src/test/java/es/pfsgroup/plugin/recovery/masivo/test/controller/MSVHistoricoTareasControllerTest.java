/**
 * 
 */
package es.pfsgroup.plugin.recovery.masivo.test.controller;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.MSVHistoricoTareasManager;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVHistoricoTareasApi;
import es.pfsgroup.plugin.recovery.masivo.controller.MSVHistoricoTareasController;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoTareaDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;

/**
 * @author Carlos
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class MSVHistoricoTareasControllerTest {
	
	@InjectMocks MSVHistoricoTareasController msvHistoricoTareasController;
	
	@Mock private ApiProxyFactory mockProxyFactory;
	@Mock private MSVHistoricoTareasManager mockMsvHistoricoTareas;
	
//	@Test
//	public void testGetHistoricoPorTareas() {
//		Long idProcedimiento=1L;
//		ModelMap map=new ModelMap();
//		
//		List<MSVHistoricoTareaDto> historicoTareasDto = new ArrayList<MSVHistoricoTareaDto>();
//		historicoTareasDto.add(getTareaPrueba(1L, "Tarea Uno"));
//		historicoTareasDto.add(getTareaPrueba(2L, "Tarea Dos"));
//		
//		when(mockProxyFactory.proxy(MSVHistoricoTareasApi.class)).thenReturn(mockMsvHistoricoTareas);
//		when(mockMsvHistoricoTareas.getHistoricoPorTareas(idProcedimiento)).thenReturn(historicoTareasDto);
//				
//		
//		String ruta=msvHistoricoTareasController.getHistoricoPorTareas(idProcedimiento, map);
//		
//		assertNotNull(ruta);
//    	assertEquals(ruta, MSVHistoricoTareasController.JSON_HISCO_TAREAS);
//    	
//	}

	@Test
	public void testGetHistoricoPorResoluciones() throws IllegalAccessException, InvocationTargetException {
		Long idProcedimiento=1L;
		ModelMap map=new ModelMap();
		
		List<MSVHistoricoResolucionDto> historicoResolucionesDto = new ArrayList<MSVHistoricoResolucionDto>();
		historicoResolucionesDto.add(getResolucion(1L, "Resolucion Uno"));
		historicoResolucionesDto.add(getResolucion(2L, "Resolucion Dos"));
		
		when(mockProxyFactory.proxy(MSVHistoricoTareasApi.class)).thenReturn(mockMsvHistoricoTareas);
		when(mockMsvHistoricoTareas.getHistoricoPorResolucion(idProcedimiento)).thenReturn(historicoResolucionesDto);
		
		String ruta=msvHistoricoTareasController.getHistoricoPorResoluciones(idProcedimiento, 20, 0, map);
		
		assertNotNull(ruta);
    	assertEquals(ruta, MSVHistoricoTareasController.JSON_HIST_RESOLUCIONES);
    	
	}
	
	@After
	public void after() {
		reset(mockMsvHistoricoTareas);
		reset(mockProxyFactory);
	}
	
	private MSVHistoricoTareaDto getTareaPrueba(Long idTarea, String descripcion) {
		MSVHistoricoTareaDto historicoTareaDto = new MSVHistoricoTareaDto();
		historicoTareaDto.setIdEntidad(idTarea);
		historicoTareaDto.setNombreTarea(descripcion);
		historicoTareaDto.setDescripcionTarea(descripcion);		
		for(long l=1L;l<=3L;l++) {
			historicoTareaDto.setResoluciones(getResoluciones(l,"Resolucion "+String.valueOf(l)));
		}
		
		return historicoTareaDto;
	}
	
	
	private List<MSVHistoricoResolucionDto> getResoluciones(Long idResolucion, String descripcion) {
		List<MSVHistoricoResolucionDto> historicoResoluciones = new ArrayList<MSVHistoricoResolucionDto>();
		
		historicoResoluciones.add(getResolucion(idResolucion, descripcion));
		
		return historicoResoluciones;
	}
	
	private MSVHistoricoResolucionDto getResolucion(Long idResolucion, String descripcion) {
		MSVHistoricoResolucionDto historicoResolucion = new MSVHistoricoResolucionDto();
		historicoResolucion.setId(idResolucion);
		historicoResolucion.setFechaCarga(new Date());
		
		MSVDDTipoResolucion tipoResolucion = new MSVDDTipoResolucion();
			tipoResolucion.setCodigo("1");
			tipoResolucion.setId(1L);
		historicoResolucion.setTipo(tipoResolucion);
		
		return historicoResolucion;
	}
	

}
