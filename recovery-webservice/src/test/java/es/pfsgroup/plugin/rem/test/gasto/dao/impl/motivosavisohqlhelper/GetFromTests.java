package es.pfsgroup.plugin.rem.test.gasto.dao.impl.motivosavisohqlhelper;

import static org.junit.Assert.*;

import org.junit.Test;

import es.pfsgroup.plugin.rem.gasto.dao.impl.MotivosAvisoHqlHelper;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;

public class GetFromTests {

	@Test
	public void sinFiltro() {
		assertNull(MotivosAvisoHqlHelper.getFrom(new DtoGastosFilter()));
	}

	@Test
	public void filtrarPorMotivoAviso() {
		DtoGastosFilter dto = new DtoGastosFilter();
		dto.setCodigoMotivoAviso("01"); // Debería servir cualquier valor
		assertEquals(MotivosAvisoHqlHelper.FROM,
				MotivosAvisoHqlHelper.getFrom(dto));
	}

}
