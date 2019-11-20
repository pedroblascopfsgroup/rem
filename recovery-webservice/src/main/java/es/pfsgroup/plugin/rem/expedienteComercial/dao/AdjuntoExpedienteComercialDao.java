package es.pfsgroup.plugin.rem.expedienteComercial.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;

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
    
    /**
     * Este método recoge un dtoAdjunto que tenga como id el campo idDocRestClient (ADE_ID_DOCUMENTO_REST de la tabla ADE_ADJUNTO_EXPEDIENTE
     * del Documento y devuelve un dtoAdjunto con el id (ADE_ID de la tabla ADE_ADJUNTO_EXPEDIENTE). 
     * 
     * @param dtoAdjunto
     * @return dtoAdjunto
     */
	DtoAdjunto getAdjuntoByIdDocRest(DtoAdjunto dtoAdjunto);
}
