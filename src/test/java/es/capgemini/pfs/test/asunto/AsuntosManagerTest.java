package es.capgemini.pfs.test.asunto;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.AsuntosManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class AsuntosManagerTest extends CommonTestAbstract{
	
	@Autowired
	private AsuntosManager asuntosManager;

	@Test
	public final void testObtenerAsuntosDeUnaPersona() {
		asuntosManager.obtenerAsuntosDeUnaPersona(1L);
	}

	@Test
	public final void testGet() {
		asuntosManager.get(1L);
	}

	@Test
	public final void testObtenerAsuntosDeUnAsunto() {
		asuntosManager.obtenerAsuntosDeUnAsunto(1L);
	}

	@Test
	public final void testObtenerAsuntosDeUnExpediente() {
		asuntosManager.obtenerAsuntosDeUnExpediente(1L);
	}

	@Test
	public final void testFindContratosTitulos() {
		asuntosManager.findContratosTitulos(1L);
	}

	@Test
	public final void testFindExpedienteContratosPorId() {
		asuntosManager.findExpedienteContratosPorId(1L);
	}

	@Test
	public final void testObtenerContratosDeUnAsuntoYSusHijos() {
		asuntosManager.obtenerContratosDeUnAsuntoYSusHijos(1L);
	}

	@Test
	public final void testBuscarTareaPendiente() {
		asuntosManager.buscarTareaPendiente(1L);
	}

	@Test
	public final void testGetExpedienteSiTieneAdjuntos() {
		asuntosManager.getExpedienteSiTieneAdjuntos(1L);
	}

	@Test
	public final void testGetExpedienteAsList() {
		asuntosManager.getExpedienteAsList(1L);
	}

	@Test
	public final void testObtenerActuacionesAsuntoJerarquico() {
		asuntosManager.obtenerActuacionesAsuntoJerarquico(1L);
	}

	@Test
	public final void testObtenerActuacionesAsunto() {
		asuntosManager.obtenerActuacionesAsunto(1L);
	}

}
