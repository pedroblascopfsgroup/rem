package es.capgemini.pfs.security;

import java.sql.Timestamp;
import java.util.Calendar;

import org.springframework.security.GrantedAuthority;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.pfs.security.model.UsuarioSecurity;

public class KerberosUserDetails implements UserDetails {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6044885904301044856L;

	private UserDetails userDetails;
	
	private KerberosAuthenticationFacade kerberosAuthenticationFacade;
	private String workingCode;
	
	public KerberosUserDetails(UserDetails userDetails, 
			KerberosAuthenticationFacade facadeKerberos,
			String workingCode) {
		
		super();
		
		UsuarioSecurity user = (UsuarioSecurity) userDetails;
		user.setLoginTime(Calendar.getInstance().getTimeInMillis());
		this.userDetails = (UserDetails) user;
				
		this.kerberosAuthenticationFacade = facadeKerberos;
		this.workingCode = workingCode;

	}

	public KerberosUserDetails(UserDetails userDetails, 
			KerberosAuthenticationFacade facadeKerberos) {
		
		super();
		
		UsuarioSecurity user = (UsuarioSecurity) userDetails;
		user.setLoginTime(Calendar.getInstance().getTimeInMillis());
		this.userDetails = (UserDetails) user;
				
		this.kerberosAuthenticationFacade = facadeKerberos;

	}

	@Override
	public GrantedAuthority[] getAuthorities() {
		
		return this.userDetails.getAuthorities();
		
	}

	@Override
	public String getPassword() {
		return this.userDetails.getPassword();
	}

	@Override
	public String getUsername() {
		return this.userDetails.getUsername();
	}

	public void setUserDetails(UserDetails userDetails) {
		this.userDetails = userDetails;
	}

	public UserDetails getUserDetails() {
		return userDetails;
	}
	
	@Override
	public boolean isAccountNonExpired() {
		
		return this.userDetails.isAccountNonExpired();
		
	}

	@Override
	public boolean isAccountNonLocked() {

		return this.userDetails.isAccountNonLocked();
		
	}

	@Override
	public boolean isCredentialsNonExpired() {

		return this.userDetails.isCredentialsNonExpired();
		
	}

	@Override
	public boolean isEnabled() {
		
		return this.userDetails.isEnabled();
		
	}

	public KerberosAuthenticationFacade getKerberosAuthenticationFacade() {
		return kerberosAuthenticationFacade;
	}

	public void setKerberosAuthenticationFacade(
			KerberosAuthenticationFacade kerberosAuthenticationFacade) {
		this.kerberosAuthenticationFacade = kerberosAuthenticationFacade;
	}

	public String getWorkingCode() {
		return workingCode;
	}

	public void setWorkingCode(String workingCode) {
		this.workingCode = workingCode;
	}

	
}
