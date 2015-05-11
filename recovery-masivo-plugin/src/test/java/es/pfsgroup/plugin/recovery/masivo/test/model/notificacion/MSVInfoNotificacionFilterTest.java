package es.pfsgroup.plugin.recovery.masivo.test.model.notificacion;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVDireccionFechaNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoDemandado;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoNotificacionFilter;

/**
 * Tests de la clase MSVInfoNotificacionFilter
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class MSVInfoNotificacionFilterTest {
	
	@InjectMocks MSVInfoNotificacionFilter msvInfoNotificacionFilter;
	
	/**
	 * Test del m�todo void filtra(MSVInfoNotificacion msvInfoNotificacion)
	 */
	@Test
	public void testFiltra(){
		
		Random r = new Random();
		
		//esta es la clase de pruebas
		MSVInfoNotificacion msvInfoNotificacion = null;
		List<MSVDireccionFechaNotificacion> result = null;
		
		//Probamos que salte la excepci�n si msvInfoNotificacion es nulo.
		try{
			msvInfoNotificacionFilter.filtra(msvInfoNotificacion);
			fail("No se ha lanzado la excepci�n.");
		}			
		catch (NullPointerException ex) {}
		
		msvInfoNotificacion = new MSVInfoNotificacion();
		
		//Creamos dos personas con sus datos.
		Persona p1 = new Persona();
		p1.setId(r.nextLong());
		Direccion d1 = new Direccion();
		d1.setCodDireccion(String.valueOf(r.nextLong()));
		String tipoFecha1 = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_REQUERIMIENTO;
		
		Persona p2 = new Persona();
		p2.setId(p1.getId());
		Direccion d2 = new Direccion();
		d2.setCodDireccion(String.valueOf(r.nextLong()));
		String tipoFecha2 = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_AVERIGUACION;
		
		MSVInfoDemandado msvInfoDemandado = new MSVInfoDemandado();
		msvInfoDemandado.setPersona(p1);
		MSVInfoDemandado msvInfoDemandado2 = new MSVInfoDemandado();
		msvInfoDemandado2.setPersona(p2);
		
		List<MSVInfoDemandado> listadoDemandados = new ArrayList<MSVInfoDemandado>();
		listadoDemandados.add(msvInfoDemandado);
		listadoDemandados.add(msvInfoDemandado2);
		msvInfoNotificacion.setInfoDemandados(listadoDemandados);
		
		//creamos dos fechas, una para cada persona.
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = new MSVDireccionFechaNotificacion();
		msvDireccionFechaNotificacion.setPersona(p1);
		msvDireccionFechaNotificacion.setDireccion(d1);
		msvDireccionFechaNotificacion.setTipoFecha(tipoFecha1);
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion2 = new MSVDireccionFechaNotificacion();
		msvDireccionFechaNotificacion2.setPersona(p1);
		msvDireccionFechaNotificacion2.setDireccion(d2);
		msvDireccionFechaNotificacion2.setTipoFecha(tipoFecha2);
		
		List<MSVDireccionFechaNotificacion> listadoDirecionesFechas = new ArrayList<MSVDireccionFechaNotificacion>();
		listadoDirecionesFechas.add(msvDireccionFechaNotificacion);
		listadoDirecionesFechas.add(msvDireccionFechaNotificacion2);
		msvInfoNotificacion.setInfoFechasNotificacion(listadoDirecionesFechas);
		
		//par�metros de filtrado.
		msvInfoNotificacionFilter.setIdPersona(p1.getId());
		msvInfoNotificacionFilter.setIdDireccion(d1.getCodDireccion());
		msvInfoNotificacionFilter.setTipoFecha(tipoFecha1);

		//test sin tipo de filtro.
		msvInfoNotificacionFilter.setTipoFiltro(null);
		msvInfoNotificacionFilter.filtra(msvInfoNotificacion);
		
		result = msvInfoNotificacion.getInfoFechasNotificacion();
		
		assertEquals("No se han recuperado las filas de direcciones correctamente", 2, result.size());
		
		//test filtro de persona
		msvInfoNotificacionFilter.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_PESONA);
		msvInfoNotificacionFilter.filtra(msvInfoNotificacion);
		
		result = msvInfoNotificacion.getInfoFechasNotificacion();
		
		assertEquals("No se han recuperado las filas de direcciones correctamente", 2, result.size());
		
		//test filtro de direcci�n
		msvInfoNotificacionFilter.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_DIRECCION);
		msvInfoNotificacionFilter.filtra(msvInfoNotificacion);
		
		result = msvInfoNotificacion.getInfoFechasNotificacion();
		
		assertEquals("No se han recuperado las filas de direcciones correctamente", 1, result.size());
		
		//test filtro de tipo de fecha
		msvInfoNotificacionFilter.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_TIPO_FECHA);
		msvInfoNotificacionFilter.filtra(msvInfoNotificacion);

		result = msvInfoNotificacion.getInfoFechasNotificacion();
		
		assertEquals("No se han recuperado las filas de direcciones correctamente", 1, result.size());
		
		//test filtro de tipo de fecha para que no cumpla ninguna fila.
		msvInfoNotificacionFilter.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_TIPO_FECHA);
		msvInfoNotificacionFilter.setTipoFecha(MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_HORARIO_NOCTURNO);
		msvInfoNotificacionFilter.filtra(msvInfoNotificacion);

		result = msvInfoNotificacion.getInfoFechasNotificacion();
		
		assertEquals("No se han recuperado las filas de direcciones correctamente", 0, result.size());
	}

}
