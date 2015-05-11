package es.capgemini.pfs.test.procesosJudiciales;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class TareaExternaManagerTest extends CommonTestAbstract{
	
	@Autowired
	TareaExternaManager tareaExternaManager;

	@Test
	public final void testObtenerTareaPorToken() {
		tareaExternaManager.obtenerTareaPorToken(1L);
	}

	@Test
	public final void testGetByIdTareaNotificacion() {
		tareaExternaManager.getByIdTareaNotificacion(1L);
	}

	@Test
	public final void testObtenerTareasPorProcedimiento() {
		tareaExternaManager.obtenerTareasPorProcedimiento(1L);
	}

	@Test
	public final void testObtenerTareasDeUsuarioPorProcedimiento() {
		tareaExternaManager.obtenerTareasDeUsuarioPorProcedimiento(1L);
	}

	@Test
	public final void testGet() {
		tareaExternaManager.get(1L);
	}

	@Test
	public final void testObtenerValoresTarea() {
		tareaExternaManager.obtenerValoresTarea(1L);
	}

	@Test
	public final void testGetByIdTareaProcedimientoIdProcedimiento() {
		tareaExternaManager.getByIdTareaProcedimientoIdProcedimiento(1L, 1L);
	}

	@Test
	public final void testGetActivasByIdProcedimiento() {
		tareaExternaManager.getActivasByIdProcedimiento(1L);
	}

}
