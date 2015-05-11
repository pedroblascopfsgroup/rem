package es.capgemini.pfs.config;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * TODO Documentar.
 * @author Nicolás Cornaglia
 */
@Entity
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class Config implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    private String id;
    private String valor;

    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * @return the valor
     */
    public String getValor() {
        return valor;
    }

    /**
     * @param valor the valor to set
     */
    public void setValor(String valor) {
        this.valor = valor;
    }

}
