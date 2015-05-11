package es.capgemini.pfs.security;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.security.AuthenticationServiceException;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UserDetailsService;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;


@RunWith(MockitoJUnitRunner.class)
public class KerberosAuthenticationProviderTest {

	@InjectMocks
	private KerberosAuthenticationProvider kerberosAuthenticationProvider;

	@Mock
	private KerberosAuthenticationFacade facadeKerberos;
	
	@Test
	public void testAdditionalAuthenticationChecks() {
		
		UserDetails userDetails = mock(KerberosUserDetails.class);
		UsernamePasswordAuthenticationToken authentication = mock(UsernamePasswordAuthenticationToken.class);
		KerberosWebAuthenticationDetails ad = mock(KerberosWebAuthenticationDetails.class);
		HttpServletRequest request = mock(HttpServletRequest.class);
		
		when(authentication.getDetails()).thenReturn(ad);
		when(ad.getRequest()).thenReturn(request);
		
		kerberosAuthenticationProvider.additionalAuthenticationChecks(userDetails, authentication);

		verify(facadeKerberos).checkAuthentication(userDetails, request);
		
		reset(facadeKerberos);
	}

	@Test(expected = AuthenticationServiceException.class)
	public void testAdditionalAuthenticationChecksRequestNull() {
		
		UserDetails userDetails = mock(KerberosUserDetails.class);
		UsernamePasswordAuthenticationToken authentication = mock(UsernamePasswordAuthenticationToken.class);
		KerberosWebAuthenticationDetails ad = mock(KerberosWebAuthenticationDetails.class);
		
		when(authentication.getDetails()).thenReturn(ad);
		when(ad.getRequest()).thenReturn(null);
		
		kerberosAuthenticationProvider.additionalAuthenticationChecks(userDetails, authentication);

		verify(facadeKerberos, never()).checkAuthentication(userDetails, null);
		
		reset(facadeKerberos);
	}

	@Test
	public void testRetrieveUserWithWorkingCode() {
		
		KerberosUserDetails kerberosUserDetails = mock(KerberosUserDetails.class);
		UserDetails userDetailsEsperado = mock(UserDetails.class);
		UserDetails userDetailsRetornado = mock(UserDetails.class);

		UsernamePasswordAuthenticationToken authentication = mock(UsernamePasswordAuthenticationToken.class);
		KerberosWebAuthenticationDetails ad = mock(KerberosWebAuthenticationDetails.class);
		HttpServletRequest request = mock(HttpServletRequest.class);
		
		String workingCode = "9999";
		String username = "usuarioPruebas";
		
		when(authentication.getDetails()).thenReturn(ad);
		when(ad.getRequest()).thenReturn(request);
		when(ad.getWorkingCode()).thenReturn(workingCode);

		KerberosUserDetailsService servicio = mock(KerberosUserDetailsService.class);
		
		kerberosAuthenticationProvider.setUserDetailsService(servicio);
		
		when(facadeKerberos.getUsername(username, request)).thenReturn(username);
		when(servicio.loadUserByUsernameAndEntity(username, workingCode)).thenReturn(kerberosUserDetails);
		when(kerberosUserDetails.getUserDetails()).thenReturn(userDetailsEsperado);
		
		userDetailsRetornado = kerberosAuthenticationProvider.retrieveUser(username, authentication);
		
		verify(facadeKerberos, times(1)).setRequest(request);

		assertFalse("UserDetails retornado no debe ser nulo", userDetailsRetornado == null);
		assertEquals("Los detalles de usuario recuperados no coinciden", userDetailsEsperado, userDetailsRetornado);
		
		reset(facadeKerberos);
	}

	@Test
	public void testRetrieveUserWithoutWorkingCode() {
		
		KerberosUserDetails kerberosUserDetails = mock(KerberosUserDetails.class);
		UserDetails userDetailsEsperado = mock(UserDetails.class);
		UserDetails userDetailsRetornado = mock(UserDetails.class);

		UsernamePasswordAuthenticationToken authentication = mock(UsernamePasswordAuthenticationToken.class);
		KerberosWebAuthenticationDetails ad = mock(KerberosWebAuthenticationDetails.class);
		HttpServletRequest request = mock(HttpServletRequest.class);
		
		String workingCode = null;
		String username = "usuarioPruebas";
		
		
		when(authentication.getDetails()).thenReturn(ad);
		when(ad.getRequest()).thenReturn(request);
		when(ad.getWorkingCode()).thenReturn(workingCode);

		KerberosUserDetailsService servicio = mock(KerberosUserDetailsService.class);
		
		kerberosAuthenticationProvider.setUserDetailsService(servicio);
		when(facadeKerberos.getUsername(username, request)).thenReturn(username);
		when(servicio.loadUserByUsername(username)).thenReturn(kerberosUserDetails);
		when(kerberosUserDetails.getUserDetails()).thenReturn(userDetailsEsperado);
		
		userDetailsRetornado = kerberosAuthenticationProvider.retrieveUser(username, authentication);
		
		verify(facadeKerberos, times(1)).setRequest(request);

		assertFalse("UserDetails retornado no debe ser nulo", userDetailsRetornado == null);
		assertEquals("Los detalles de usuario recuperados no coinciden", userDetailsEsperado, userDetailsRetornado);
		
		reset(facadeKerberos);
	}
}
