package es.capgemini.pfs.security;

import org.junit.After;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.userdetails.UserDetails;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

@RunWith(MockitoJUnitRunner.class)
public class KerberosUserDetailsTest {

	
	@Mock 
	private KerberosAuthenticationFacade kerberosAuthenticationFacade;
	
	private String username = "usuario";
	private String workingCode = "9999";
	
	@Mock
	private KerberosUserDetails kerberosUserDetails;

	@Mock
	private UserDetails userDetails;
	
	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);
		kerberosUserDetails = new KerberosUserDetails(kerberosUserDetails, kerberosAuthenticationFacade);
		kerberosUserDetails.setWorkingCode(workingCode);
	}

	@After
	public void teardown() {
		reset(kerberosAuthenticationFacade);
	}
	
	@Test
	@Ignore
	public void testGetAuthorities() {
		
		GrantedAuthority[] authoritiesOriginal = {new GrantedAuthorityImpl("ROLE1"), new GrantedAuthorityImpl("ROLE2")};
		when(kerberosUserDetails.getUserDetails().getAuthorities()).thenReturn(authoritiesOriginal);
		
		GrantedAuthority[] authorities = kerberosUserDetails.getAuthorities();
		assertNotNull("Resultado de getAuthorities no debe ser nulo", authorities);
		assertTrue("Resultado de getAuthorities no es el esperado " + authoritiesOriginal, authorities.equals(authoritiesOriginal));

	}

	@Test
	@Ignore
	public void testGetPassword() {
		
		String password = "pass123";

		when(kerberosAuthenticationFacade.getUserDetails()).thenReturn(userDetails);
		when(userDetails.getPassword()).thenReturn(password);
		
		String passwordResult = kerberosUserDetails.getPassword();
		assertNotNull("Resultado de getPassword no debe ser nulo", passwordResult);
		assertTrue("Resultado de getPassword no es el esperado " + password, password.equals(passwordResult));

	}

	@Test
	@Ignore
	public void testGetUsername() {
		
		when(kerberosAuthenticationFacade.getUserDetails()).thenReturn(userDetails);
		when(userDetails.getUsername()).thenReturn(username);
		
		String usernameResult = kerberosUserDetails.getUsername();
		assertNotNull("Resultado de getUsername no debe ser nulo", usernameResult);
		assertTrue("Resultado de getUsername no es el esperado " + username, username.equals(usernameResult));

	}

	@Test
	@Ignore
	public void testIsAccountNonExpired() {
		
		Boolean accountNonExpired = false;

		when(kerberosAuthenticationFacade.getUserDetails()).thenReturn(userDetails);
		when(userDetails.isAccountNonExpired()).thenReturn(accountNonExpired);
		
		Boolean accountNonExpiredResult = kerberosUserDetails.isAccountNonExpired();
		assertNotNull("Resultado de isAccountNonExpired no debe ser nulo", accountNonExpiredResult);
		assertTrue("Resultado de isAccountNonExpired no es el esperado " + accountNonExpired, 
				accountNonExpired.equals(accountNonExpiredResult));

	}

	@Test
	@Ignore
	public void testIsAccountNonLocked() {
		
		Boolean accountNonLocked = false;

		when(kerberosAuthenticationFacade.getUserDetails()).thenReturn(userDetails);
		when(userDetails.isAccountNonLocked()).thenReturn(accountNonLocked);
		
		Boolean accountNonLockedResult = kerberosUserDetails.isAccountNonLocked();
		assertNotNull("Resultado de isAccountNonLocked no debe ser nulo", accountNonLockedResult);
		assertTrue("Resultado de isAccountNonLockedd no es el esperado " + accountNonLocked, 
				accountNonLocked.equals(accountNonLockedResult));

	}

	@Test
	@Ignore
	public void testIsCredentialsNonExpired() {
		
		Boolean credentialsNonExpired = false;

		when(kerberosAuthenticationFacade.getUserDetails()).thenReturn(userDetails);
		when(userDetails.isCredentialsNonExpired()).thenReturn(credentialsNonExpired);
		
		Boolean credentialsNonExpiredResult = kerberosUserDetails.isCredentialsNonExpired();
		assertNotNull("Resultado de isCredentialsNonExpired no debe ser nulo", credentialsNonExpiredResult);
		assertTrue("Resultado de isCredentialsNonExpired no es el esperado " + credentialsNonExpired, 
				credentialsNonExpired.equals(credentialsNonExpiredResult));

	}

	@Test
	@Ignore
	public void testIsEnabled() {
		
		Boolean enabled = false;

		when(kerberosAuthenticationFacade.getUserDetails()).thenReturn(userDetails);
		when(userDetails.isEnabled()).thenReturn(enabled);
		
		Boolean enabledResult = kerberosUserDetails.isEnabled();
		assertNotNull("Resultado de isEnabled no debe ser nulo", enabledResult);
		assertTrue("Resultado de isEnabled no es el esperado " + enabled, 
				enabled.equals(enabledResult));

	}

}
