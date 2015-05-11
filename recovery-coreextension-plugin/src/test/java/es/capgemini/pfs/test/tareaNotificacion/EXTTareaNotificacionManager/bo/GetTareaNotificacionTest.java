package es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager.bo;


import java.util.Random;

import org.junit.Test;
import org.junit.runner.RunWith;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager.AbstractExtTareaNotificacionManagerTests;

/**
 * Aquí se prueba la funcionalidad de obtener una TareaNotificacion
 * @author bruno
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetTareaNotificacionTest extends AbstractExtTareaNotificacionManagerTests {
	
	@Mock
	private EXTTareaNotificacion mockTareaNotificacionObject;
	
	private Long idTareaNotificacion;

	@Override
	public void setUpChildTest() {
		Random r = new Random();
		idTareaNotificacion = r.nextLong();
		when(mockParentManager.get(idTareaNotificacion)).thenReturn(mockTareaNotificacionObject);
		when(mockTareaNotificacionObject.getId()).thenReturn(idTareaNotificacion);
	}



	@Override
	public void tearDownChildTest() {
		idTareaNotificacion = null;
		mockTareaNotificacionObject = null;
	}

	
	/**
	 * Prueba del caso general de obtener una TareaNotificacion
	 */
	@Test
	public void testGetTareaNotificacion(){
		TareaNotificacion tarea = manager.get(idTareaNotificacion);
		assertTrue("El objeto devuelto no es instancia de EXTTareaNotificacion", tarea instanceof EXTTareaNotificacion);
		assertEquals("El id de la tareaNotificacion no es el esperado", idTareaNotificacion, tarea.getId());
	}
	
}
