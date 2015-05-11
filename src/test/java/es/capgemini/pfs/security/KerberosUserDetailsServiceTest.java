package es.capgemini.pfs.security;

import static org.junit.Assert.assertNotNull;

import org.apache.commons.logging.Log;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.security.AuthenticationServiceException;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class KerberosUserDetailsServiceTest {

	@InjectMocks
	private KerberosUserDetailsService kerberosUserDetailsService;

	@Mock
	private Log logger;

	@Test(expected = NullPointerException.class)
	public void testLoadUserByUsernameAndEntityNullFacade() {
		
		KerberosUserDetails kud = kerberosUserDetailsService.loadUserByUsernameAndEntity(null, null);
		assertNotNull(kud);

	}
	
	@Test(expected = NullPointerException.class)
	public void testLoadUserByUsernameAndEntityOK() {
		
		String username = "usuario";
		String workingCode = "9999";
		KerberosAuthenticationFacade kaf = mock(KerberosAuthenticationFacade.class);
		kerberosUserDetailsService.setFacadeKerberos(kaf);
		
		KerberosUserDetails kud=kerberosUserDetailsService.loadUserByUsernameAndEntity(username, workingCode);
		assertNotNull("No se recupera un usuario/entidad correcto", kud);

	}
		
}
