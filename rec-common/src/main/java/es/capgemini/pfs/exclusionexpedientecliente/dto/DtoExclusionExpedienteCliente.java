package es.capgemini.pfs.exclusionexpedientecliente.dto;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;

/**
 * DTO para el formulario de exclusi�n de la evaluaci�n de clientes en un expediente.
 * @author marruiz
 */
public class DtoExclusionExpedienteCliente extends WebDto {

    private static final long serialVersionUID = -8583892987801069859L;

    private Long idExclusion;
    private String excluidos;
    private String observaciones;

    private List<Long> idsClientesExcluidos;


    /**
     * Transforma la lista de excluidos que está en un String en el
     * formato "id1, id2, ..." a un objeto List (idsClientesExcluidos).
     */
    private void parseExcluidos() {
        idsClientesExcluidos = new ArrayList<Long>();
        List<String> list = Arrays.asList((excluidos.split(",")));
        for(int i=0; i<list.size(); i++) {
            if(!list.get(i).equals("")) {
                idsClientesExcluidos.add(new Long(list.get(i)));
            }
        }
    }

    /**
     * Valida el formulario.
     * @param messageContext MessageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        if(excluidos!=null) {
            parseExcluidos();
        }
        // Si se está creando una exclusi�n se debe elegir al menos un
        // cliente, pero sino puede destildarse todos (se estar�a cancelando la exclusi�n
        if(excluidos==null || idsClientesExcluidos.size()==0 && idExclusion==null) {
                messageContext.addMessage(new MessageBuilder().code("exclusioncliente.error.carga").error().source("").defaultText(
                      "**Debe excluir al menos a un cliente.").build());
                addValidation(excluidos, messageContext, "excluidos").addValidation(this, messageContext).validate();
        }
    }

    /**
     * @return the excluidos
     */
    public String getExcluidos() {
        return excluidos;
    }

    /**
     * @param excluidos the excluidos to set
     */
    public void setExcluidos(String excluidos) {
        this.excluidos = excluidos;
    }

    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    /**
     * @return the idsClientesExcluidos
     */
    public List<Long> getIdsClientesExcluidos() {
        return idsClientesExcluidos;
    }
    /**
     * @param idsClientesExcluidos the idsClientesExcluidos to set
     */
    public void setIdsClientesExcluidos(List<Long> idsClientesExcluidos) {
        this.idsClientesExcluidos = idsClientesExcluidos;
    }

    /**
     * @return the idExclusion
     */
    public Long getIdExclusion() {
        return idExclusion;
    }

    /**
     * @param idExclusion the idExclusion to set
     */
    public void setIdExclusion(Long idExclusion) {
        this.idExclusion = idExclusion;
    }
}
