package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.test.cambiogestores.testcases;

import java.util.Random;

import org.mockito.Mockito;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.api.UsuarioApi;

/**
 * Factoría de casos de prueba para las peticiones de cambios masivos de gestores
 * @author bruno
 *
 */
public class PeticionCambioMasivoGestoresTestCaseFactory {

	/**
	 * Genera un caso de prueba estándar pra uan petición de cambio masivo
	 * @param usuarioManager Si es distinto a NULL, manager que inicializa para simular el usuario logado.
	 * @return
	 */
	public PeticionCambioMasivoTestCase peticionCambioMasivo(UsuarioApi usuarioManager) {
		Usuario usuarioLogado = creaUsuarioLogado();
		if (usuarioManager != null){
			Mockito.when(usuarioManager.getUsuarioLogado()).thenReturn(usuarioLogado );
		}
		return new PeticionCambioMasivoTestCase(usuarioLogado);
	}

	/**
	 * Crea un usuario logado para la simulación en el caso de pruebas 
	 * @return
	 */
	private Usuario creaUsuarioLogado() {
		Random r = new Random();
		Usuario u = new Usuario();
		u.setId(r.nextLong());
		return u;
	}

}
