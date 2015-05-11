package es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager.bo;

import static org.mockito.Mockito.*;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager.AbstractExtTareaNotificacionManagerTests;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.ResultadoBusquedaTareasBuzonesDto;

/**
 * Comprobamos la operaci�n de negocio para exportar la excel de tareas
 * @author bruno
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class ExportarExcelTareasTest extends AbstractExtTareaNotificacionManagerTests{

	private String descripcionTarea;
	private String nombreTarea;
	
	@Mock
	private PageHibernate mockTareasPendientesPage;
	private int totalTareas;

	@Override
	public void setUpChildTest() {
		Random r = new Random();
		descripcionTarea = "Tarea " + r.nextLong();
		nombreTarea = "Tarea " + r.nextLong();
		totalTareas = 10000 + Math.abs(r.nextInt(10000));
	}

	@Override
	public void tearDownChildTest() {
		descripcionTarea = null;
		nombreTarea = null;
		reset(mockTareasPendientesPage);
	}
	
	/**
	 * Test del caso general de exportar un excel de tareas
	 */
	@Test
	public void testExportarExcelTareas(){
		DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
		dto.setDescripcionTarea(descripcionTarea);
		dto.setNombreTarea(nombreTarea);
		
		simularInteracciones().simulaDevolverTareasPendientes(creaPaginaTareasPendientes(totalTareas));
		
		FileItem fi = manager.exportaTareasExcel(dto);
		
		assertNotNull("Se ha devuelto un objeto null", fi);
		assertNotNull("No se ha devuelto ning�n fichero", fi.getFile());
		assertEquals("El nombre del fichero no es el esperado", "ListaTarea.xls", fi.getFileName());
		
		fi.getFile().delete();
	}

	/**
	 * Crea un conjunto de tareas pendientes para simular que se devuelve durante el test
	 * 
	 * @param totalTareas Total de tareas que se quiere devolver
	 * 
	 * @return
	 */
	private Page creaPaginaTareasPendientes(int totalTareas) {
		ResultadoBusquedaTareasBuzonesDto dto;
		
		ArrayList list = new ArrayList();
		Random rnd = new Random();
		for (int i = 1; i<= totalTareas ; i++){
			ResultadoBusquedaTareasBuzonesDto r = new ResultadoBusquedaTareasBuzonesDto();
			r.setId(rnd.nextLong());
			list.add(r);
		}
		when(mockTareasPendientesPage.getResults()).thenReturn(list);
		when(mockTareasPendientesPage.getTotalCount()).thenReturn(totalTareas);
		return mockTareasPendientesPage;
	}

}
