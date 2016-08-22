package es.capgemini.pfs.users.web.dto;

import org.springframework.binding.message.MessageContext;

import es.capgemini.pfs.users.domain.Usuario;

public class AltaUsuario extends es.capgemini.devon.dto.WebDto {

	/**
	 * serial.
	 */
	private static final long serialVersionUID = -6637787835506547314L;

    private Usuario usuario = new Usuario();
    private String[] roles;

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    /**
     * este método validará los datos
     */

    public void validateMostrarFormulario(MessageContext messageContext) {
        addValidation(this, messageContext).addValidation(this.getUsuario(), messageContext, "usuario").validate();
    }

    public String[] getRoles() {
        return roles;
    }

    public void setRoles(String[] roles) {
        this.roles = roles;
    }
}
