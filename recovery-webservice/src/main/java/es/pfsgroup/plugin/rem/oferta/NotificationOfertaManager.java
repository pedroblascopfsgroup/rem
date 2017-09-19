package es.pfsgroup.plugin.rem.oferta;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

/**
 * Notificacion por correo cuando una nueva oferta llegue
 * 
 * HREOS-2044
 */
@Service
public class NotificationOfertaManager extends AbstractNotificatorService {

	private final Log logger = LogFactory.getLog(this.getClass());
	private static final String USUARIO_FICTICIO_OFERTA_CAJAMAR = "ficticioOfertaCajamar";

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private GestorActivoApi gestorActivoManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UsuarioManager usuarioManager;

	/**
	 * Cada vez que llegue una oferta de un activo, 
	 * se enviará una notificación (correo) al gestor comercial correspondiente, 
	 * con independencia de que dicha oferta se muestre en el listado de ofertas del módulo comercial en el estado que corresponda (pendiente o congelada).
	 * 
	 * @param tramite
	 */
	public void sendNotification(Oferta oferta) {

		Usuario usuario = null;
		Usuario supervisor= null;
		Activo activo = oferta.getActivoPrincipal();

		if (!Checks.esNulo(oferta.getAgrupacion()) 
		        && !Checks.esNulo(oferta.getAgrupacion().getTipoAgrupacion())
		        && DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())) {

			ActivoLoteComercial activoLoteComercial = genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
			usuario = activoLoteComercial.getUsuarioGestorComercial();
			if(!Checks.estaVacio(oferta.getAgrupacion().getActivos())){
				supervisor= gestorActivoManager.getGestorByActivoYTipo(oferta.getAgrupacion().getActivos().get(0).getActivo(), GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
			}

		} else {
			// por activo
			usuario = gestorActivoManager.getGestorByActivoYTipo(activo, "GCOM");
			supervisor = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		}

		if (activo != null && (usuario != null || supervisor != null)) {

			String titulo = "Solicitud de oferta para compra del inmueble con referencia: " + activo.getNumActivo();
			String tipoDocIndentificacion= "";
			String docIdentificacion="";
			String codigoPrescriptor="";
			String nombrePrescriptor="";
			
			DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();

			dtoSendNotificator.setNumActivo(activo.getNumActivo());
			dtoSendNotificator.setDireccion(generateDireccion(activo));
			dtoSendNotificator.setTitulo(titulo);

			if(!Checks.esNulo(oferta.getAgrupacion())) {
				dtoSendNotificator.setNumAgrupacion(oferta.getAgrupacion().getNumAgrupRem());	
			}

			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();

			if(!Checks.esNulo(usuario)){
				mailsPara.add(usuario.getEmail());
			}
			if(!Checks.esNulo(supervisor)){
				mailsPara.add(supervisor.getEmail());
			}
			if(!Checks.esNulo(activo.getCartera()) && DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())){
				if(!Checks.esNulo(usuarioManager.getByUsername(USUARIO_FICTICIO_OFERTA_CAJAMAR))){
					mailsPara.add(usuarioManager.getByUsername(USUARIO_FICTICIO_OFERTA_CAJAMAR).getEmail());
				}				
			}			
			mailsCC.add(this.getCorreoFrom());
			
			if(!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getCliente()) && !Checks.esNulo(oferta.getCliente().getTipoDocumento())){
				tipoDocIndentificacion= oferta.getCliente().getTipoDocumento().getDescripcion();
				docIdentificacion= oferta.getCliente().getDocumento();
			}
			if(!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getPrescriptor())){
				if(!Checks.esNulo(oferta.getPrescriptor().getCodigoProveedorRem())){
					codigoPrescriptor= oferta.getPrescriptor().getCodigoProveedorRem().toString();
				}
				nombrePrescriptor= oferta.getPrescriptor().getNombre();
			}
			
			String contenido = 
					String.format("<p>Ha recibido una nueva oferta con número identificador %s, a nombre de %s con identificador %s %s, por importe de %s €. Prescriptor: %s %s.</p>", 
							oferta.getNumOferta().toString(), oferta.getCliente().getNombreCompleto(),tipoDocIndentificacion,docIdentificacion, NumberFormat.getNumberInstance(new Locale("es", "ES")).format(oferta.getImporteOferta()),codigoPrescriptor,nombrePrescriptor );

			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
	}

	
}
