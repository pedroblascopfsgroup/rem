package es.pfsgroup.plugin.rem.expedienteComercial.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;

public interface AdjuntoExpedienteComercialDao extends AbstractDao<AdjuntoExpedienteComercial, Long> {

    /**
     * Este método indica si un documento existe en la tabla de adjuntos asociados a expediente comercial para un expediente
     * en especifico en base al nombre del adjunto, la matrícula del adjunto y el número del expediente comercial.
     *
     * @param nombreAdjunto: nombre del documento.
     * @param matriculaDocumento: matricula asociada al tipo de documento del expediente comercial.
     * @param numExpedienteComercial: número del expediente comercial asociado al documento.
     * @return Devuelve True si el documento con las caracteristicas especificadas está asociado al expediente comercial, False si no lo está.
     */
    Boolean existeAdjuntoPorNombreYTipoDocumentoYNumExpedienteComercial(String nombreAdjunto, String matriculaDocumento, Long numExpedienteComercial);
}
