package es.pfsgroup.plugin.rem.expedienteComercial.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoExpediente;

public interface DDSubtipoDocumentoExpedienteDao extends AbstractDao<DDSubtipoDocumentoExpediente, Long> {

    /**
     * Este método obtiene una entrada del diccionario DDSubtipoDocumentoExpediente en base a la matricula asociada al mismo.
     *
     * @param matriculaDocumento: matricula asociada al tipo de documento del expediente comercial.
     * @return Devuelve el tipo de documento por la matricula especificada.
     */
    DDSubtipoDocumentoExpediente getSubtipoDocumentoExpedienteComercialPorMatricula(String matriculaDocumento);

    /**
     * Este método devuelve True si la matricula pasada por parámetro se encuentra registra en algún subtipo de documento,
     * False si no lo está.
     *
     * @return Devuelve True si la matricula existe en algún subtipo de documento, False si no existe.
     */
    Boolean existeMatriculaRegistradaEnSubtipoDocumento(String matricula);
}
