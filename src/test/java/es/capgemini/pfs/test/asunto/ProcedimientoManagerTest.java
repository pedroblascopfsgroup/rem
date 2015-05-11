package es.capgemini.pfs.test.asunto;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ProcedimientoManagerTest extends CommonTestAbstract {
	
	@Autowired
	ProcedimientoManager procedimientoManager;

	@Test
	public final void testGetProcedimientosDeExpediente() {
		procedimientoManager.getProcedimientosDeExpediente(1L);
	}

	@Test
	public final void testGetPersonasAsociadasAContratoProcedimiento() {
		procedimientoManager.getPersonasAsociadasAContratoProcedimiento(1L, 1L);
	}

	@Test
	public final void testGetProcedimiento() {
		procedimientoManager.getProcedimiento(1L);
	}

	@Test
	public final void testGetTiposActuacion() {
		procedimientoManager.getTiposActuacion();
	}

	@Test
	public final void testGetTiposProcedimiento() {
		procedimientoManager.getTiposProcedimiento();
	}

	@Test
	public final void testGetTiposReclamacion() {
		procedimientoManager.getTiposReclamacion();
	}

	@Test
	public final void testGetPersonasDeLosContratosProcedimiento() {
		procedimientoManager.getPersonasDeLosContratosProcedimiento("", 1L);
	}

	@Test
	public final void testGetBienesDeUnProcedimiento() {
		procedimientoManager.getBienesDeUnProcedimiento(1L);
	}

	@Test
	public final void testGetPersonasAfectadas() {
		procedimientoManager.getPersonasAfectadas(1L);
	}

	@Test
	public final void testBuscarTareaPendiente() {
		procedimientoManager.buscarTareaPendiente(1L);
	}

}
