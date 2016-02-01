package es.pfsgroup.plugin.recovery.liquidaciones.test.manager.liqLiquidacionesManager;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.junit.Test;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoLiquidacionCabecera;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoReportRequest;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoReportResponse;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;

public class GenerateReportTest extends AbstractLIQLiquidacionesManagerTest {

	private static final String FECHA_CIERRE = "05/12/1990";
	private static final String FECHA_LIQUIDACION = "01/01/2010";

	private static final String DATE_FORMAT = "dd/MM/yyyy";
	private static final Float INTERESES = 18.00F;
	private static final Float PRINCIPAL = 4548.10F;

	private static final Long ACTUACION = 100L;
	private static final Long CONTRATO = 366L;
	private static final String CODIGO_CONTRATO = "1237-2500014879";
	private static final String NUM_AUTOS = "15878/2000";
	private static final String NOMBRE = "XXXXXXXXXXXXXXXXXXX";
	private static final String DNI = "01334361Q";

	private static Object[][] entregas;
	static {
		entregas = new Object[15][2];
		entregas[0] = new Object[] { "05/12/2003", 113.23F };
		entregas[1] = new Object[] { "12/01/2004", 585.68F };
		entregas[2] = new Object[] { "02/04/2004", 366.96F };
		entregas[3] = new Object[] { "14/10/2004", 583.31F };
		entregas[4] = new Object[] { "04/03/2005", 1034.04F };
		entregas[5] = new Object[] { "28/04/2005", 118.97F };
		entregas[6] = new Object[] { "05/05/2005", 128.17F };
		entregas[7] = new Object[] { "16/06/2006", 251.12F };
		entregas[8] = new Object[] { "15/01/2007", 913.21F };
		entregas[9] = new Object[] { "30/04/2007", 523.28F };
		entregas[10] = new Object[] { "15/06/2007", 58.30F };
		entregas[11] = new Object[] { "31/08/2007", 1020.86F };
		entregas[12] = new Object[] { "09/11/2007", 161.17F };
		entregas[13] = new Object[] { "06/05/2008", 3.84F };
		entregas[14] = new Object[] { "30/06/2008", 1.28F };
	}

	private static List<LIQDtoTramoLiquidacion> tramos = new ArrayList<LIQDtoTramoLiquidacion>();
	static {
		try {
			tramos.add(nuevoTramo("05/12/1990", "05/12/2003", 113.23F,
					4548.10F, 4748L, 2.27F, 10797.19F));
			tramos.add(nuevoTramo("05/12/2003", "12/01/2004", 585.68F,
					4434.87F, 38L, 2.22F, 84.26F));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Test
	public void testGenerateReport() throws Exception {
		LIQDtoReportRequest request = new LIQDtoReportRequest();
		request.setActuacion(ACTUACION);
		request.setContrato(CONTRATO);
		request.setIntereses(INTERESES);
		request.setPrincipal(PRINCIPAL);
		request.setFechaCierre(FECHA_CIERRE);
		request.setNombre(NOMBRE);
		request.setDni(DNI);
		request.setFechaLiquidacion(FECHA_LIQUIDACION);

		Contrato mockContrato = mock(Contrato.class);
		when(mockContrato.getCodigoContrato()).thenReturn(CODIGO_CONTRATO);

		Procedimiento mockProcedimiento = mock(Procedimiento.class);
		when(mockProcedimiento.getCodigoProcedimientoEnJuzgado()).thenReturn(
				NUM_AUTOS);

		// LLAMADA A DAO Y OTROS MANAGERS
		Date fechaCierrre = new SimpleDateFormat(DATE_FORMAT)
				.parse(FECHA_CIERRE);
		Date fechaLiquidacion = new SimpleDateFormat(DATE_FORMAT)
				.parse(FECHA_LIQUIDACION);
		when(
				dao.findEntregasACuenta(CONTRATO, fechaCierrre, fechaLiquidacion)).thenReturn(
				sampleEntregasACuenta(entregas));
		when(
				executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET,
						CONTRATO)).thenReturn(mockContrato);
		when(
				executor.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
						ACTUACION)).thenReturn(mockProcedimiento);
		// BUSINESS OPERATION
		LIQDtoReportResponse response = manager.createReport(request);
		// VERIFICAR LLAMDAS A DAO
		verify(dao).findEntregasACuenta(CONTRATO,fechaCierrre,fechaLiquidacion);
		// VERIFICAR RESULTADO
		LIQDtoLiquidacionCabecera cabecera = response.getCabecera();
		assertEquals(CODIGO_CONTRATO, cabecera.getAcuerdo());
		assertEquals(NUM_AUTOS, cabecera.getAutos());
		assertEquals(NOMBRE, cabecera.getNombre());
		assertEquals(DNI, cabecera.getDni());
		assertTramosLiquidaciones(tramos, response.getCuerpo());
		// assertEquals(FECHA_CIERRE, cabecera.getFechaLiquidacion());
	}

	private static LIQDtoTramoLiquidacion nuevoTramo(String fmov, String fli,
			Float ent, Float deu, Long dias, Float coef, Float intereses)
			throws ParseException {

		LIQDtoTramoLiquidacion tramo = new LIQDtoTramoLiquidacion();
		tramo.setFechaMovimiento(new SimpleDateFormat(DATE_FORMAT).parse(fmov));
		tramo.setfLiquidacion(new SimpleDateFormat(DATE_FORMAT).parse(fli));
		tramo.setEntregado(ent);
		tramo.setDeuda(deu);
		tramo.setCoefic(coef);
		tramo.setInteres(INTERESES);
		tramo.setIntereses(intereses);
		tramo.setDias(dias);
		return tramo;
	}

	private void assertTramosLiquidaciones(List<LIQDtoTramoLiquidacion> tramos,
			List<LIQDtoTramoLiquidacion> cuerpo) throws ParseException {
		for (int i = 0; i < tramos.size(); i++) {
			LIQDtoTramoLiquidacion expected = tramos.get(i);
			LIQDtoTramoLiquidacion actual = cuerpo.get(i);
			assertEquals(expected.getDeuda(), actual.getDeuda());
			assertEquals(expected.getDias(), actual.getDias());
			assertEquals(expected.getEntregado(), actual.getEntregado());
			assertEquals(expected.getFechaMovimiento(), actual
					.getFechaMovimiento());
			assertEquals(expected.getfLiquidacion(), actual.getfLiquidacion());
			assertEquals(expected.getInteres(), actual.getInteres());
			Float diffIntereses = actual.getInteres() - expected.getInteres();
			assertTrue((diffIntereses >= 0) && (diffIntereses < 0.009F));
		}
	}

	private List<LIQCobroPago> sampleEntregasACuenta(Object[][] es)
			throws ParseException {
		ArrayList<LIQCobroPago> sample = new ArrayList<LIQCobroPago>();
		for (int i = 0; i < es.length; i++) {
			LIQCobroPago c = new LIQCobroPago();
			c.setFecha(new SimpleDateFormat(DATE_FORMAT)
					.parse((String) es[i][0]));
			c.setImporte((Float) es[i][1]);
			sample.add(c);
		}
		return sample;
	}

}
