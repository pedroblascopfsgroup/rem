package es.pfsgroup.plugin.recovery.masivo.test.model.notificacion;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVDireccionFechaNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoDemandado;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumen;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumenPersona;

/**
 * Tests de la clase MSVInfoNotificacion
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class MSVInfoNotificacionTest {
	
	@InjectMocks MSVInfoNotificacion msvInfoNotificacion;
	
	/**
	 * tests del m�todo List<MSVInfoResumen> getInfoResumen()
	 */
	@Test
	public void testGetInfoResumen(){
		
		Random r = new Random();
		
		Procedimiento procedimiento = new Procedimiento();
		procedimiento.setId(r.nextLong());
		msvInfoNotificacion.setProcedimiento(procedimiento);
		//Creamos dos personas con sus datos.
		Persona p1 = new Persona();
		p1.setId(r.nextLong());
		Direccion d1 = new Direccion();
		d1.setCodDireccion(String.valueOf(r.nextLong()));
		String tipoFecha1 = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_EDICTOS;
		
		Persona p2 = new Persona();
		p2.setId(r.nextLong());
		Direccion d2 = new Direccion();
		d2.setCodDireccion(String.valueOf(r.nextLong()));
		String tipoFecha2 = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_AVERIGUACION;
		
		String tipoFecha3 = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_REQUERIMIENTO;
		
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
		msvDireccionFechaNotificacion.setFechaSolicitud(new Date());
		msvDireccionFechaNotificacion.setFechaResultado(new Date());
		msvDireccionFechaNotificacion.setResultado("POSITIVO");
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion2 = new MSVDireccionFechaNotificacion();
		msvDireccionFechaNotificacion2.setPersona(p2);
		msvDireccionFechaNotificacion2.setDireccion(d2);
		msvDireccionFechaNotificacion2.setTipoFecha(tipoFecha2);
		msvDireccionFechaNotificacion2.setFechaSolicitud(new Date());
		msvDireccionFechaNotificacion2.setFechaResultado(new Date());
		msvDireccionFechaNotificacion2.setResultado("NEGATIVO");
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion3 = new MSVDireccionFechaNotificacion();
		msvDireccionFechaNotificacion3.setPersona(p2);
		msvDireccionFechaNotificacion3.setDireccion(d2);
		msvDireccionFechaNotificacion3.setTipoFecha(tipoFecha3);
		msvDireccionFechaNotificacion3.setFechaSolicitud(new Date());
		msvDireccionFechaNotificacion3.setFechaResultado(new Date());
		msvDireccionFechaNotificacion3.setResultado("NEGATIVO");
		
		List<MSVDireccionFechaNotificacion> listadoDirecionesFechas = new ArrayList<MSVDireccionFechaNotificacion>();
		listadoDirecionesFechas.add(msvDireccionFechaNotificacion);
		listadoDirecionesFechas.add(msvDireccionFechaNotificacion2);
		listadoDirecionesFechas.add(msvDireccionFechaNotificacion3);
		msvInfoNotificacion.setInfoFechasNotificacion(listadoDirecionesFechas);
		
		List<MSVInfoResumen> result = msvInfoNotificacion.getInfoResumen();
		
		//Comprobamos que devuelve dos personas, cada una con una fecha y un resultado.
		assertNotNull("El reusltado es nulo", result);
		assertEquals("El n�mero de presonas del resumen no es correcto", 2, result.size());
		
		MSVInfoResumen msvInfoResumen= result.get(0);
		assertNotNull("la fecha de requerimiento es nula",msvInfoResumen.getFechaSolicitudReqEdicto());
		assertNotNull("el resultado es nulo",msvInfoResumen.getResultadoReqEdicto());
		
		msvInfoResumen = result.get(1);
		assertNotNull("la fecha de Averiguaci�n domiciliaria es nula",msvInfoResumen.getFechaSolicitudAvDomiciliaria());
		assertNotNull("el resultado es nulo",msvInfoResumen.getResultadoAvDomiciliaria());
		
	}
	
	/**
	 * test del m�todo List<MSVInfoResumenPersona> getInfoResumenPersona()
	 */
	@Test
	public void testgetInfoResumenPersona(){
		
		Random r = new Random();
		
		Procedimiento procedimiento = new Procedimiento();
		procedimiento.setId(r.nextLong());
		msvInfoNotificacion.setProcedimiento(procedimiento);
		//Creamos dos personas con sus datos.
		Persona p1 = new Persona();
		p1.setId(r.nextLong());
		Direccion d1 = new Direccion();
		d1.setCodDireccion(String.valueOf(r.nextLong()));
		String tipoFecha1 = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_REQUERIMIENTO;
		
		Direccion d2 = new Direccion();
		d2.setCodDireccion(String.valueOf(r.nextLong()));
		String tipoFecha2 = MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_HORARIO_NOCTURNO;
		
		List<Direccion> direcciones = new ArrayList<Direccion>();
		direcciones.add(d1);
		direcciones.add(d2);
		
		p1.setDirecciones(direcciones);
		
		MSVInfoDemandado msvInfoDemandado = new MSVInfoDemandado();
		msvInfoDemandado.setPersona(p1);
		
		List<MSVInfoDemandado> listadoDemandados = new ArrayList<MSVInfoDemandado>();
		listadoDemandados.add(msvInfoDemandado);
		msvInfoNotificacion.setInfoDemandados(listadoDemandados);
		
		//creamos dos fechas, una para cada persona.
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = new MSVDireccionFechaNotificacion();
		msvDireccionFechaNotificacion.setPersona(p1);
		msvDireccionFechaNotificacion.setDireccion(d1);
		msvDireccionFechaNotificacion.setTipoFecha(tipoFecha1);
		msvDireccionFechaNotificacion.setFechaSolicitud(new Date());
		msvDireccionFechaNotificacion.setFechaResultado(new Date());
		msvDireccionFechaNotificacion.setResultado("POSITIVO");
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion2 = new MSVDireccionFechaNotificacion();
		msvDireccionFechaNotificacion2.setPersona(p1);
		msvDireccionFechaNotificacion2.setDireccion(d2);
		msvDireccionFechaNotificacion2.setTipoFecha(tipoFecha2);
		msvDireccionFechaNotificacion2.setFechaSolicitud(new Date());
		msvDireccionFechaNotificacion2.setFechaResultado(new Date());
		msvDireccionFechaNotificacion2.setResultado("NEGATIVO");
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion3 = new MSVDireccionFechaNotificacion();
		msvDireccionFechaNotificacion3.setPersona(p1);
		msvDireccionFechaNotificacion3.setDireccion(d1);
		msvDireccionFechaNotificacion3.setTipoFecha(tipoFecha1);
		msvDireccionFechaNotificacion3.setFechaSolicitud(new Date());
		msvDireccionFechaNotificacion3.setFechaResultado(new Date());
		msvDireccionFechaNotificacion3.setResultado("NEGATIVO");		
		
		List<MSVDireccionFechaNotificacion> listadoDirecionesFechas = new ArrayList<MSVDireccionFechaNotificacion>();
		listadoDirecionesFechas.add(msvDireccionFechaNotificacion);
		listadoDirecionesFechas.add(msvDireccionFechaNotificacion2);
		listadoDirecionesFechas.add(msvDireccionFechaNotificacion3);
		msvInfoNotificacion.setInfoFechasNotificacion(listadoDirecionesFechas);
		
		List<MSVInfoResumenPersona> result = msvInfoNotificacion.getInfoResumenPersona();
		
		//Comprobamos que devuelve dos personas, cada una con una fecha y un resultado.
		assertNotNull("El reusltado es nulo", result);
		assertEquals("El n�mero de presonas del resumen no es correcto", 2, result.size());
		
		MSVInfoResumenPersona msvInfoResumenPersona= result.get(0);
		assertNotNull("la fecha de requerimiento es nula",msvInfoResumenPersona.getFechaRequerimiento());
		assertNotNull("el resultado es nulo",msvInfoResumenPersona.getResultadoRequerimiento());
		
		msvInfoResumenPersona = result.get(1);
		assertNotNull("la fecha de Averiguaci�n domiciliaria es nula",msvInfoResumenPersona.getFechaHorarioNocturno());
		assertNotNull("el resultado es nulo",msvInfoResumenPersona.getResultadoHorarioNocturno());
		
	}
	
	/**
	 * test del m�todo public void clearAll()
	 */
	@Test
	public void testClearAll(){
		
		//Comprobamos que el m�todo borra correctamente todos los listados.
		msvInfoNotificacion.clearAll();
		
	}

}
