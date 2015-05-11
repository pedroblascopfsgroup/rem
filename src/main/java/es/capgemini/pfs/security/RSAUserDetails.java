package es.capgemini.pfs.security;

import org.springframework.security.GrantedAuthority;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.pfs.security.manager.RSADecripterStatus;

public class RSAUserDetails implements UserDetails{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1630777400706231370L;

	private UserDetails userDetails;
	
	private RSADecripterStatus decrypterStatus;
	

	public RSAUserDetails(UserDetails userDetails,
			RSADecripterStatus decrypterStatus) {
		super();
		this.userDetails = userDetails;
		this.decrypterStatus = decrypterStatus;
	}

	public RSADecripterStatus getDecrypterStatus() {
		return decrypterStatus;
	}

	public void setDecrypterStatus(RSADecripterStatus decrypterStatus) {
		this.decrypterStatus = decrypterStatus;
	}

	public UserDetails getUserDetails() {
		return userDetails;
	}

	public void setUserDetails(UserDetails userDetails) {
		this.userDetails = userDetails;
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


}
