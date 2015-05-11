package es.capgemini.pfs.test.cobropago;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.cobropago.CobroPagoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class CobroPagoManagerTest extends CommonTestAbstract{

	@Autowired
	CobroPagoManager cobroPagoManager;
	
	@Test
	public final void testGetList() {
		cobroPagoManager.getList();
	}

	@Test
	public final void testGetListbyAsuntoId() {
		cobroPagoManager.getListbyAsuntoId(1L);
	}

	@Test
	public final void testGetInstance() {
		cobroPagoManager.getInstance(1L);
	}

	@Test
	public final void testGet() {
		cobroPagoManager.get(1L);
	}

	@Test
	public final void testGetSubtiposCobroPagoByTipo() {
		cobroPagoManager.getSubtiposCobroPagoByTipo("codigo");
	}

	@Test
	public final void testGetProcedimientosPorAsunto() {
		cobroPagoManager.getProcedimientosPorAsunto(1L);
	}

}
