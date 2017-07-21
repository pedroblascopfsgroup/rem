package es.pfsgroup.plugin.rem.test.gasto.dao.impl.motivosavisohqlhelper;

import static org.junit.Assert.*;

import org.junit.Test;

import es.pfsgroup.plugin.rem.gasto.dao.impl.MotivosAvisoHqlHelper;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;

public class GetWhereTests {

	@Test
	public void sinFiltro () {
		assertNull(MotivosAvisoHqlHelper.getWhere(new DtoGastosFilter()));
	}
	
	@Test
	public void filtrarPorCorrespondeComprador () {
		DtoGastosFilter dto = new DtoGastosFilter();
		dto.setCodigoMotivoAviso("01"); 
		assertEquals(MotivosAvisoHqlHelper.fitroPor("correspondeComprador"), MotivosAvisoHqlHelper.getWhere(dto));
	}
	
	
	@Test
	public void filtrarPorPrimerPago () {
		DtoGastosFilter dto = new DtoGastosFilter();
		dto.setCodigoMotivoAviso("04"); 
		assertEquals(MotivosAvisoHqlHelper.fitroPor("primerPago"), MotivosAvisoHqlHelper.getWhere(dto));
	}
	
	
	public void filtrarPorTodosLosMotivos () {
		fail("TEST NO IMPLEMENTADO");
	}
}
