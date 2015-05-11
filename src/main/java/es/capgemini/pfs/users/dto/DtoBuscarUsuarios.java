package es.capgemini.pfs.users.dto;

import org.hibernate.validator.constraints.Length;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.AbstractDto;

/**
 * Dto para buscar usuarios.
 *
 */
public class DtoBuscarUsuarios extends AbstractDto {

    @Length(min = 4, message = "dtoBuscarUsuarios.criterio.length")
    private String criterio;

    private static final long serialVersionUID = 1L;

    /**
     * Constructor.
     */
    public DtoBuscarUsuarios() {

    }

    /**
     * @return criterio
     */
    public String getCriterio() {
        return criterio;
    }

    /**
     * @param criterio string
     */
    public void setCriterio(String criterio) {
        this.criterio = criterio;
    }

    /**
     * Valida los datos del usuario.
     * @param messageContext MessageContext
     * @return boolean
     */
    public boolean validateUsuariosData(MessageContext messageContext) {
        //TODO Esto está vacio, que hace??
        // if (StringUtils.isNumeric(criterio)) {
        // throw new UserNotDeleteableException();
        // }
        // if (criterio != null && criterio.length() > 10) {
        // messageContext.addMessage(error("", "nombre", "",
        // "El nombre no puede ser tan largo"));
        // }
        // Validator validator = new Validator();
        // List<ConstraintViolation> violations = validator.validate(this);
        // for (ConstraintViolation constraintViolation : violations) {
        // System.out.println(constraintViolation.getMessage());
        // }
        // SpringValidator svalidator = new SpringValidator(validator);
        //
        // MessageContextErrors errors = new
        // MessageContextErrors(messageContext);
        // svalidator.validate(this, errors);
        return true;
    }

}
