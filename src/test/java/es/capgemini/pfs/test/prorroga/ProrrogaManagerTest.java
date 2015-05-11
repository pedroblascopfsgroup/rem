package es.capgemini.pfs.test.prorroga;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.prorroga.ProrrogaManager;
import es.capgemini.pfs.prorroga.model.DDTipoProrroga;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ProrrogaManagerTest extends CommonTestAbstract{
	
	@Autowired
	ProrrogaManager prorrogaManager;

	@Test
	public final void testGet() {
		prorrogaManager.get(1L);
	}

	@Test
	public final void testObtenerCausas() {
		prorrogaManager.obtenerCausas(DDTipoProrroga.TIPO_PRORROGA_EXTERNA);
	}

	@Test
	public final void testObtenerRespuestas() {
		prorrogaManager.obtenerRespuestas(DDTipoProrroga.TIPO_PRORROGA_EXTERNA);
	}

	@Test
	public final void testObtenerDecisionProrroga() {
		prorrogaManager.obtenerDecisionProrroga(1L);
	}

	@Test
	public final void testObtenerPlazo() {
		prorrogaManager.obtenerPlazo(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, 1L);
	}

}
