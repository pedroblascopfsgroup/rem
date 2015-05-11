package es.capgemini.pfs.security;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import javax.servlet.http.HttpServletRequest;

import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.junit.Test;

@RunWith(MockitoJUnitRunner.class)
public class KerberosWebAuthenticationDetailsTest {

	@InjectMocks
	private KerberosWebAuthenticationDetails kerberosWebAuthenticationDetails;

	@Mock
	HttpServletRequest request;
	
	@Test
	public void testDoPopulateAdditionalInformation() {
		
		kerberosWebAuthenticationDetails.doPopulateAdditionalInformation(request);
		HttpServletRequest requestResult = kerberosWebAuthenticationDetails.getRequest();
		
		assertNotNull("Tras la ejecución de doPopulateAdditionalInformation, request no debe ser nulo", requestResult);
		assertTrue("Resultado de isEnabled no es el esperado " + request, 
				request.equals(requestResult));
		
	}
}
