package es.capgemini.pfs.diccionarios;

import java.io.Serializable;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * PONER JAVADOC FO.
 * @author FO
 *
 */
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public interface Dictionary extends Serializable{

	/**
	 * PONER JAVADOC FO.
	 * @return id
	 */
    Long getId();
    /**
     * PONER JAVADOC FO.
     * @return codigo
     */
    String getCodigo();
    /**
     * PONER JAVADOC FO.
     * @return desc
     */
    String getDescripcion();
    /**
     * PONER JAVADOC FO.
     * @return desclarga
     */
    String getDescripcionLarga();
}
