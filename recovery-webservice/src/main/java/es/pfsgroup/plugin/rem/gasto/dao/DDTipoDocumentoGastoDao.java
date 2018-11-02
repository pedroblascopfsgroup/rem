package es.pfsgroup.plugin.rem.gasto.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;

public interface DDTipoDocumentoGastoDao extends AbstractDao<DDTipoDocumentoGasto, Long> {

    /**
     * Este método obtiene una entrada del diccionario DDTipoDocumentoGasto en base a la matricula asociada al mismo.
     *
     * @param matriculaDocumento: matricula asociada al tipo de documento del gasto.
     * @return Devuelve el tipo de documento por la matricula especificada.
     */
    DDTipoDocumentoGasto getTipoDocumentoGastoPorMatricula(String matriculaDocumento);

    /**
     * Este método devuelve True si la matricula pasada por parámetro se encuentra registra en algún tipo de documento,
     * False si no lo está.
     *
     * @return Devuelve True si la matricula existe en algún tipo de documento, False si no existe.
     */
    Boolean existeMatriculaRegistradaEnTipoDocumento(String matricula);
}
