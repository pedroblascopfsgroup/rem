package es.pfsgroup.plugin.rem.gastoProveedor.gastoProveedorManager;

import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.plugin.rem.gastoProveedor.GastoProveedorManager;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;

/*
 * Requisitos de cambio de estado descritos en el ítem HREOS-2377 
 */
public class CheckReglaCambioEstado {

	private GastoProveedorManager manager;

	@Before
	public void before() {
		manager = new GastoProveedorManager();
	}

	
	@Test
	public void testDebeCambiarEstado() {
		verificaCambio(DDEstadoGasto.INCOMPLETO, true, "AI-15-FACT-24", DDEstadoGasto.PENDIENTE);
		verificaCambio(DDEstadoGasto.INCOMPLETO, false, "AI-15-FACT-24", DDEstadoGasto.PENDIENTE);
		verificaCambio(DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC, false, "AI-15-CERA-81", DDEstadoGasto.PAGADO);

	}
	
	@Test
	public void testDebeNoCambiarEstado() {
		/*
		 * El cambio sólo debe ocurrir en un casto SIN IVA
		 */
		verificaSinCambio(DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC, true, "AI-15-CERA-81", "Si el gasto tiene IVA no debería cambiar de estado");
		
		/*
		 * Combinaciones de estado / matrícula que no provocan cambio
		 */
		verificaSinCambio(DDEstadoGasto.INCOMPLETO, true ,"AI-15-CERA-81", "esta combinación estado / matrícula no debería provocar cambio de estado");
		verificaSinCambio(DDEstadoGasto.INCOMPLETO, false,"AI-15-CERA-81" , "esta combinación estado / matrícula no debería provocar cambio de estado");
		verificaSinCambio(DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC, true, "AI-15-FACT-24", "esta combinación estado / matrícula no debería provocar cambio de estado");
		verificaSinCambio(DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC, false, "AI-15-FACT-24", "esta combinación estado / matrícula no debería provocar cambio de estado");
		
		/*
		 * Estados que no deberían provocar nunca 
		 */
		verificaSinCambio(DDEstadoGasto.ANULADO, true, "AI-15-CERA-81", "no se debría cambiar este estado");
		verificaSinCambio(DDEstadoGasto.ANULADO, false, "AI-15-CERA-81", "no se debría cambiar este estado");
		verificaSinCambio(DDEstadoGasto.ANULADO, true, "AI-15-FACT-24", "no se debría cambiar este estado");
		verificaSinCambio(DDEstadoGasto.ANULADO, false, "AI-15-FACT-24", "no se debría cambiar este estado");
		
		verificaSinCambio(DDEstadoGasto.AUTORIZADO_ADMINISTRACION, true, "AI-15-CERA-81", "no se debría cambiar este estado");
		verificaSinCambio(DDEstadoGasto.AUTORIZADO_ADMINISTRACION, false, "AI-15-CERA-81", "no se debría cambiar este estado");
		verificaSinCambio(DDEstadoGasto.AUTORIZADO_ADMINISTRACION, true, "AI-15-FACT-24", "no se debría cambiar este estado");
		verificaSinCambio(DDEstadoGasto.AUTORIZADO_ADMINISTRACION, false, "AI-15-FACT-24", "no se debría cambiar este estado");
		// ... aquí podría ir el resto de estados pero no se considera necesario ponerlos todos

	}

	private void verificaCambio(String estadoInicial, boolean coniva, String matricula, String estadoFinal) {
		assertEquals("El cambio de estado no es el esperado, para estado=\"" + estadoInicial + "\", matricula=\""
				+ matricula + "\"", estadoFinal, manager.checkReglaCambioEstado(estadoInicial, coniva, matricula, null));
	}
	
	private void verificaSinCambio(String estadoInicial, boolean coniva, String matricula, String motivo) {
		assertNull("Estado=\"" + estadoInicial + "\", matricula=\""
				+ matricula + "\": " + motivo, manager.checkReglaCambioEstado(estadoInicial, coniva, matricula, null));
	}

}
