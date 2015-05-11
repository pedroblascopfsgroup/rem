package es.pfsgroup.recovery.ext.test.impl.procedimiento.EXTProcedimientoManager.bo;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.HashSet;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.api.asunto.EXTUsuarioRelacionadoInfo;
import es.pfsgroup.recovery.ext.test.impl.procedimiento.EXTProcedimientoManager.AbstractEXTProcedimientoManagerTests;

/**
 * Esta es la suite de tests par probar el método getGestor()
 * 
 * @author bruno
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetGestorTest extends AbstractEXTProcedimientoManagerTests{
	
	
	private Long idProcedimiento;
	
	private Long idAsunto;
	
	private String nombreApellidoGestor;


	private HashSet<EXTUsuarioRelacionadoInfo> usuariosRelacionadosAsunto;

	@Override
	protected void beforeChild() {
		idProcedimiento = random.nextLong();
		idAsunto = random.nextLong();
		nombreApellidoGestor = "Pepito los palotes " + random.nextLong();
		usuariosRelacionadosAsunto = new HashSet<EXTUsuarioRelacionadoInfo>();
		usuariosRelacionadosAsunto.add(creaUsuarioGestor(nombreApellidoGestor));
		
		simularInteracciones().simulaDevolverProcedimiento(idProcedimiento, idAsunto);
		simularInteracciones().simulaObtenerUsuariosRelacionadosAsunto(idAsunto, usuariosRelacionadosAsunto);
	}


	@Override
	protected void afterChild() {
		idProcedimiento = null ;
		idAsunto = null;
		nombreApellidoGestor = null;
		usuariosRelacionadosAsunto = null;
	}
	
	/**
	 * Prueba el caso general de obtener si es gestor
	 */
	@Test
	public void testGetGestor_casoGeneral(){
		String gestor = manager.getGestor(idProcedimiento);
		assertEquals("El gestor no coincide", nombreApellidoGestor, gestor);
	}

	
	/**
	 * Este método crea un usuario relacionado al asunto de tipo gestor
	 * @param nombreApellidoGestor Nombre + apellidos del gestor
	 * @return
	 */
	private EXTUsuarioRelacionadoInfo creaUsuarioGestor(String nombreApellidoGestor) {
		final Usuario gestor = creaMockUsuario(nombreApellidoGestor);
		final Dictionary tipo = creaMockDictionary(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO, "Gestor");
		return new EXTUsuarioRelacionadoInfo() {
			
			@Override
			public Usuario getUsuario() {
				return gestor;
			}
			
			@Override
			public Dictionary getTipoGestor() {
				return tipo;
			}
			
			@Override
			public String getIdCompuesto() {
				return "" + random.nextLong();
			}
		};
	}

}
