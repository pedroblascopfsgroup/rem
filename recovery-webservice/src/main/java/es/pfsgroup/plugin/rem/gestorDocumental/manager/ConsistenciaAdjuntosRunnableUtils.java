package es.pfsgroup.plugin.rem.gestorDocumental.manager;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.IdentificacionDocumento;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAdjuntoActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.DDTipoDocumentoActivoDao;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.AdjuntoExpedienteComercialDao;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.DDSubtipoDocumentoExpedienteDao;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gasto.dao.AdjuntoGastoDao;
import es.pfsgroup.plugin.rem.gasto.dao.DDTipoDocumentoGastoDao;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.context.SecurityContextHolder;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ConsistenciaAdjuntosRunnableUtils implements Runnable {

    protected static final Log logger = LogFactory.getLog(ConsistenciaAdjuntosRunnableUtils.class);
    private static final String ENCODING_UTF8 = "UTF-8";
    private final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    private final IdentificacionDocumento[] documentos;
    private final GestorDocumentalConstants.Contenedor contenedor;

    @Autowired
    private ActivoAdjuntoActivoDao activoAdjuntoActivoDao;

    @Autowired
    private AdjuntoExpedienteComercialDao adjuntoExpedienteComercialDao;

    @Autowired
    private AdjuntoGastoDao adjuntoGastoDao;

    @Autowired
    private ActivoDao activoDao;

    @Autowired
    private ExpedienteComercialDao expedienteComercialDao;

    @Autowired
    private GastoDao gastoDao;

    @Autowired
    private DDTipoDocumentoActivoDao ddTipoDocumentoActivoDao;

    @Autowired
    private DDSubtipoDocumentoExpedienteDao ddSubtipoDocumentoExpedienteDao;

    @Autowired
    private DDTipoDocumentoGastoDao ddTipoDocumentoGastoDao;
    
    @Autowired
	private RestApi restApi;
    
    private String usuarioLogado;


    public ConsistenciaAdjuntosRunnableUtils(IdentificacionDocumento[] documentos, GestorDocumentalConstants.Contenedor contenedor,String usuarioLogado) {
        this.documentos = documentos;
        this.contenedor = contenedor;
        this.usuarioLogado = usuarioLogado;
    }

	/**
	 * Establecer aquí las diferentes iteraciones por tipo de contenedor del
	 * gestor documental.
	 */
	public void run() {
		try {
			restApi.doSessionConfig(this.usuarioLogado);
			switch (contenedor) {
			case Activo:
				comprobarDocumentosAdjuntosEnActivo();
				// FUTURE: limpiarDocumentosAdjuntosEnDesusoEnActivo();
				break;
			case ExpedienteComercial:
				comprobarDocumentosAdjuntosEnExpedientes();
				// FUTURE: limpiarDocumentosAdjuntosEnDesusoEnExpedientes();
				break;
			case Gasto:
				comprobarDocumentosAdjuntosEnGastos();
				// FUTURE: limpiarDocumentosAdjuntosEnDesusoEnGastos();
				break;
			default:
				logger.error(
						"Error en ConsistenciaAdjuntosRunnableUtils en el tipo de contenedor a comprobar del gestor documental");
				break;
			}
		} catch (Exception e) {
			logger.error(
					"Error en ConsistenciaAdjuntosRunnableUtils en el tipo de contenedor a comprobar del gestor documental",
					e);
		}
	}

    /**
     * Este método comprueba si existen una serie de documentos por gasto obtenidos desde el gestor documental. Si no existen en
     * las bases de REM genera las asociaciones en las bases. No adjunta ningún documento.
     */
    private void comprobarDocumentosAdjuntosEnGastos() {
        for (IdentificacionDocumento doc : documentos) {
            String nombreDocumento = obtenerNombreDocumentoLimpio(doc.getNombreNodo());

            // Comprobar que el documento no se encuentre asociado al gasto para llevar a cabo la asociación, además, comprobar que la matrícula
            // se encuentre registrada al tipo de documento en las bases de REM.
            if(!adjuntoGastoDao.existeAdjuntoPorNombreYTipoDocumentoYNumeroHayaGasto(nombreDocumento, doc.getMatriculaCompleta(), Long.parseLong(doc.getIdExpedienteHaya()))
                    && ddTipoDocumentoGastoDao.existeMatriculaRegistradaEnTipoDocumento(doc.getMatriculaCompleta())) {

                GastoProveedor gastoProveedor = gastoDao.getGastoPorNumeroGastoHaya(Long.parseLong(doc.getIdExpedienteHaya()));
                AdjuntoGasto adjuntoGasto = new AdjuntoGasto();
                adjuntoGasto.setGastoProveedor(gastoProveedor);
                adjuntoGasto.setTipoDocumentoGasto(ddTipoDocumentoGastoDao.getTipoDocumentoGastoPorMatricula(doc.getMatriculaCompleta()));
                adjuntoGasto.setContentType(doc.getContentType());
                adjuntoGasto.setTamanyo(doc.getFileSizeInLongBytes());
                adjuntoGasto.setNombre(nombreDocumento);
                adjuntoGasto.setDescripcion(doc.getDescripcionDocumento());
                adjuntoGasto.setFechaDocumento(dameFechaFormateada(doc.getCreatedate()));
                adjuntoGasto.setIdDocRestClient(Long.parseLong(doc.getIdentificadorNodo().toString()));
                Auditoria.save(adjuntoGasto);

                adjuntoGastoDao.save(adjuntoGasto);
            }
        }
    }

    /**
     * Este método comprueba si existen una serie de documentos por expediente obtenidos desde el gestor documental. Si no existen en
     * las bases de REM genera las asociaciones en las bases. No adjunta ningún documento.
     */
    private void comprobarDocumentosAdjuntosEnExpedientes() {
        for (IdentificacionDocumento doc : documentos) {
            String nombreDocumento = obtenerNombreDocumentoLimpio(doc.getNombreNodo());

            // Comprobar que el documento no se encuentre asociado al expediente comercial para llevar a cabo la asociación, además, comprobar que la matrícula
            // se encuentre registrada al tipo de documento en las bases de REM.
            if(!adjuntoExpedienteComercialDao.existeAdjuntoPorNombreYTipoDocumentoYNumExpedienteComercial(nombreDocumento, doc.getMatriculaCompleta(), Long.parseLong(doc.getIdExpedienteHaya()))
                    && ddSubtipoDocumentoExpedienteDao.existeMatriculaRegistradaEnSubtipoDocumento(doc.getMatriculaCompleta())) {
                ExpedienteComercial expedienteComercial = expedienteComercialDao.getExpedienteComercialByNumExpediente(Long.parseLong(doc.getIdExpedienteHaya()));
                AdjuntoExpedienteComercial adjuntoExpediente = new AdjuntoExpedienteComercial();
                adjuntoExpediente.setExpediente(expedienteComercial);
                adjuntoExpediente.setSubtipoDocumentoExpediente(ddSubtipoDocumentoExpedienteDao.getSubtipoDocumentoExpedienteComercialPorMatricula(doc.getMatriculaCompleta()));
                adjuntoExpediente.setTipoDocumentoExpediente(adjuntoExpediente.getSubtipoDocumentoExpediente().getTipoDocumentoExpediente());
                adjuntoExpediente.setContentType(doc.getContentType());
                adjuntoExpediente.setTamanyo(doc.getFileSizeInLongBytes());
                adjuntoExpediente.setNombre(nombreDocumento);
                adjuntoExpediente.setDescripcion(doc.getDescripcionDocumento());
                adjuntoExpediente.setFechaDocumento(dameFechaFormateada(doc.getCreatedate()));
                adjuntoExpediente.setIdDocRestClient(Long.parseLong(doc.getIdentificadorNodo().toString()));
                Auditoria.save(adjuntoExpediente);

                adjuntoExpedienteComercialDao.save(adjuntoExpediente);
            }
        }
    }

    /**
     * Este método comprueba si existen una serie de documentos por activo obtenidos desde el gestor documental. Si no existen en
     * las bases de REM genera las asociaciones en las bases. No adjunta ningún documento.
     */
    private void comprobarDocumentosAdjuntosEnActivo() {
        for (IdentificacionDocumento doc : documentos) {
            String nombreDocumento = obtenerNombreDocumentoLimpio(doc.getNombreNodo());

            // Comprobar que el documento no se encuentre asociado al activo para llevar a cabo la asociación, además, comprobar que la matrícula se encuentre registrada
            // al tipo de documento en las bases de REM.
            if (!activoAdjuntoActivoDao.existeAdjuntoPorNombreYTipoDocumentoYNumActivo(nombreDocumento, doc.getMatriculaCompleta(), Long.parseLong(doc.getId_activo()))
                    && ddTipoDocumentoActivoDao.existeMatriculaRegistradaEnTipoDocumento(doc.getMatriculaCompleta())) {
                Activo activo = activoDao.getActivoByNumActivo(Long.parseLong(doc.getId_activo()));
                ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
                adjuntoActivo.setActivo(activo);
                adjuntoActivo.setIdDocRestClient(Long.parseLong(doc.getIdentificadorNodo().toString()));
                adjuntoActivo.setTipoDocumentoActivo(ddTipoDocumentoActivoDao.getDDTipoDocumentoActivoPorMatricula(doc.getMatriculaCompleta()));
                adjuntoActivo.setContentType(doc.getContentType());
                adjuntoActivo.setTamanyo(doc.getFileSizeInLongBytes());
                adjuntoActivo.setNombre(nombreDocumento);
                adjuntoActivo.setDescripcion(doc.getDescripcionDocumento());
                adjuntoActivo.setFechaDocumento(dameFechaFormateada(doc.getCreatedate()));
                Auditoria.save(adjuntoActivo);
                activoAdjuntoActivoDao.save(adjuntoActivo);
            }
        }
    }

    /**
     * Este método devuelve un nombre de fichero limpio de carácteres especiales a partir del nombre que obtiene como parámetro.
     *
     * @param nombreDocumento: nombre original del fichero sin limpiar.
     * @return Devuelve el nombre sin carácteres especiales.
     */
    private String obtenerNombreDocumentoLimpio(String nombreDocumento) {
        try {
            nombreDocumento = nombreDocumento.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
            nombreDocumento = URLDecoder.decode(nombreDocumento, ENCODING_UTF8);
            nombreDocumento = nombreDocumento.replace("'", "'||'''");

        } catch (UnsupportedEncodingException e) {
            logger.error("Error en ConsistenciaAdjuntosRunnableUtils al procesar la codificación del nombre del documento a comprobar", e);
        }

        return nombreDocumento;
    }

    /**
     * Este método formatea una fecha pasada por parámetro como literal a un formato estándar. Null si no ha sido posible dar formato a la fecha.
     *
     * @param dateToFormat: literal con la fecha a formatear.
     * @return Devuelve un objeto date con el formato estándar.
     */
    private Date dameFechaFormateada(String dateToFormat) {
        try {
            return df.parse(dateToFormat);
        } catch (ParseException e) {
            logger.error("Error en ConsistenciaAdjuntosRunnableUtils al procesar la fecha para un nuevo documento", e);
        }

        return null;
    }

    /**
     * Devuelve el tipo de contenedor referente al gestor documental seleccionado para la tarea de consistencia.
     *
     * @return Devuelve un enum GestorDocumentalConstants.Contenedor indicando el tipo de contendor seleccionado.
     */
    public GestorDocumentalConstants.Contenedor getContenedor() {
        return this.contenedor;
    }

    /**
     * Este método establece el contexto de seguridad de Spring, entre lo que se eincluye el usuario logueado que está realizando
     * la petición, para que se permita ejecutar en el entorno las peticiones de la clase runnable.
     *
     * @param context: contexto de seguridad de Spring con los recursos de seguridad de la sesión en Spring.
     */
    void setSpringSecurityContext(SecurityContext context) {
        SecurityContextHolder.setContext(context);
    }

}
