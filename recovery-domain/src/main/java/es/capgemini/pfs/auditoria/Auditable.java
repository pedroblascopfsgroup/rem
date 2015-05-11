package es.capgemini.pfs.auditoria;

import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Interfaz a implementar por las entidades que tengan que ser auditadas.
 * @author amarinso
 *
 */
public interface Auditable {

    /**
     * @return Auditoria
     */
    Auditoria getAuditoria();

    /**
     * @param auditoria Auditoria
     */
    void setAuditoria(Auditoria auditoria);
}
