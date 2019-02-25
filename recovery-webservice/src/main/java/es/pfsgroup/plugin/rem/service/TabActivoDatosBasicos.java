package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoInfoLiberbank;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.DtoListadoGestores;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.VAdmisionDocumentos;
import es.pfsgroup.plugin.rem.model.VPreciosVigentes;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEntradaActivoBankia;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpIncorrienteBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpRiesgoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivoBDE;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivoBDE;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProductoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class TabActivoDatosBasicos implements TabActivoService {
	
	private static final String MSG_ERROR_PERIMETRO_COMERCIALIZACION_OFERTAS_VIVAS = "activo.aviso.demsarcar.comercializar.ofertas.vivas";
	private static final String MSG_ERROR_PERIMETRO_FORMALIZACION_EXPEDIENTE_VIVO = "activo.aviso.demsarcar.formalizar.expediente.vivo";
	private static final String MSG_ERROR_PERIMETRO_COMERCIALIZACION_AGR_RESTRINGIDA_NO_PRINCIPAL = "activo.aviso.demsarcar.comercializar.agr.restringida.no.principal";
	private static final String AVISO_TITULO_GESTOR_COMERCIAL = "activo.aviso.titulo.cambio.gestor.comercial";
	private static final String AVISO_MENSAJE_GESTOR_COMERCIAL = "activo.aviso.descripcion.cambio.gestor.comercial";
	private static final String MSG_ERROR_DESTINO_COMERCIAL_OFERTAS_VIVAS_VENTA = "msg.error.tipo.comercializacion.ofertas.vivas";
	private static final String MSG_ERROR_DESTINO_COMERCIAL_OFERTAS_VIVAS_ALQUILER = "msg.error.tipo.comercializacion.ofertas.vivas";


	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UpdaterStateApi updaterState;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private AnotacionApi anotacionApi;
	

	
	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Autowired
	private ParticularValidatorApi particularValidator;

	@Autowired
	private ActivoAdapter adapter;
	
	@Autowired
	private TareaActivoApi tareaActivoApi;

	@Resource
	private MessageService messageServices;
	
	protected static final Log logger = LogFactory.getLog(TabActivoDatosBasicos.class);	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_DATOS_BASICOS};
	}
	
	
	public DtoActivoFichaCabecera getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();

		BeanUtils.copyProperties(activoDto, activo);

		if (activo.getLocalizacion() != null) {
			BeanUtils.copyProperties(activoDto, activo.getLocalizacion().getLocalizacionBien());
			BeanUtils.copyProperties(activoDto, activo.getLocalizacion());
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
				BeanUtils.copyProperty(activoDto, "tipoViaCodigo", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getCodigo());
			}
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
				BeanUtils.copyProperty(activoDto, "tipoViaDescripcion", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion());
			}
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getPais() != null) {
				BeanUtils.copyProperty(activoDto, "paisCodigo", activo.getLocalizacion().getLocalizacionBien().getPais().getCodigo());
			}
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null) {
				BeanUtils.copyProperty(activoDto, "municipioCodigo", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getCodigo());
				BeanUtils.copyProperty(activoDto, "municipioDescripcion", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion());
			}
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional() != null) {
				BeanUtils.copyProperty(activoDto, "inferiorMunicipioCodigo", activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().getCodigo());
				BeanUtils.copyProperty(activoDto, "inferiorMunicipioDescripcion", activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().getDescripcion());
			}
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null
					&& activo.getLocalizacion().getLocalizacionBien().getProvincia() != null) {
				BeanUtils.copyProperty(activoDto, "provinciaCodigo", activo.getLocalizacion().getLocalizacionBien().getProvincia().getCodigo());
				BeanUtils.copyProperty(activoDto, "provinciaDescripcion", activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion());

			}
			
		}
		
		if (activo.getMotivoActivo() != null) {
			BeanUtils.copyProperty(activoDto, "motivoActivo", activo.getMotivoActivo());
		}

		if (activo.getCartera() != null) {
			BeanUtils.copyProperty(activoDto, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
			BeanUtils.copyProperty(activoDto, "entidadPropietariaDescripcion", activo.getCartera().getDescripcion());
		}
		if(!Checks.esNulo(activo.getSubcartera())) {
			BeanUtils.copyProperty(activoDto, "subcarteraCodigo", activo.getSubcartera().getCodigo());
			BeanUtils.copyProperty(activoDto, "subcarteraDescripcion", activo.getSubcartera().getDescripcion());
		}
		if (activo.getRating() != null ) {
			BeanUtils.copyProperty(activoDto, "rating", activo.getRating().getCodigo());
		}
		
		BeanUtils.copyProperty(activoDto, "propietario", activo.getFullNamePropietario());	
		
		BeanUtils.copyProperty(activoDto, "tieneOkTecnico", activo.getTieneOkTecnico());

		if(activo.getTipoActivo() != null ) {
			BeanUtils.copyProperty(activoDto, "tipoActivoCodigo", activo.getTipoActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoActivoDescripcion", activo.getTipoActivo().getDescripcion());
			
			if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
				// Comprobar si el tipo de activo es el mismo tanto en el activo como en el informe comercial.
				BeanUtils.copyProperty(activoDto, "tipoActivoAdmisionMediadorCorresponde", activo.getTipoActivo().getCodigo().equals(activo.getInfoComercial().getTipoActivo().getCodigo()));
			}
		}
		Filter filterLbk = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoInfoLiberbank actInfLiber = genericDao.get(ActivoInfoLiberbank.class, filterLbk);

		if (!Checks.esNulo(actInfLiber)){
			if (!Checks.esNulo(actInfLiber.getTipoActivoBde())){
				BeanUtils.copyProperty(activoDto, "tipoActivoCodigoBde", actInfLiber.getTipoActivoBde().getCodigo());
				BeanUtils.copyProperty(activoDto, "tipoActivoDescripcionBde", actInfLiber.getTipoActivoBde().getDescripcion());
			}
			if (!Checks.esNulo(actInfLiber.getSubtipoActivoBde())){
				BeanUtils.copyProperty(activoDto, "subtipoActivoCodigoBde", actInfLiber.getSubtipoActivoBde().getCodigo());
				BeanUtils.copyProperty(activoDto, "subtipoActivoDescripcionBde", actInfLiber.getSubtipoActivoBde().getDescripcion());
			}
			if (!Checks.esNulo(actInfLiber.getCodPromocion())){
				BeanUtils.copyProperty(activoDto, "codPromocionFinal", actInfLiber.getCodPromocion());
			}
			if (!Checks.esNulo(actInfLiber.getCategoriaContable())){
				BeanUtils.copyProperty(activoDto, "catContableDescripcion", actInfLiber.getCategoriaContable().getDescripcion());
			}
		}

		if (activo.getSubtipoActivo() != null ) {
			BeanUtils.copyProperty(activoDto, "subtipoActivoCodigo", activo.getSubtipoActivo().getCodigo());	
			BeanUtils.copyProperty(activoDto, "subtipoActivoDescripcion", activo.getSubtipoActivo().getDescripcion());	
		}
		
		if (activo.getTipoTitulo() != null) {
			BeanUtils.copyProperty(activoDto, "tipoTitulo", activo.getTipoTitulo().getDescripcion());
			BeanUtils.copyProperty(activoDto, "tipoTituloCodigo", activo.getTipoTitulo().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoTituloDescripcion", activo.getTipoTitulo().getDescripcion());
		}
		
		if (activo.getSubtipoTitulo() != null) {
			BeanUtils.copyProperty(activoDto, "subtipoTitulo", activo.getSubtipoTitulo().getDescripcion());
			BeanUtils.copyProperty(activoDto, "subtipoTituloCodigo", activo.getSubtipoTitulo().getCodigo());
			BeanUtils.copyProperty(activoDto, "subtipoTituloDescripcion", activo.getSubtipoTitulo().getDescripcion());
		}
		
		if (activo.getCartera() != null) {
			BeanUtils.copyProperty(activoDto, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
			BeanUtils.copyProperty(activoDto, "entidadPropietariaDescripcion", activo.getCartera().getDescripcion());
		}
		
		if (activo.getBien().getLocalizaciones() != null && activo.getBien().getLocalizaciones().get(0).getLocalidad() != null) {
			BeanUtils.copyProperty(activoDto, "municipioDescripcion", activo.getBien().getLocalizaciones().get(0).getLocalidad().getDescripcion());
		}
		
		if (activo.getEstadoActivo() != null) {
			BeanUtils.copyProperty(activoDto, "estadoActivoCodigo", activo.getEstadoActivo().getCodigo());
		}
		
		if (activo.getTipoUsoDestino() != null) {
			BeanUtils.copyProperty(activoDto, "tipoUsoDestinoCodigo", activo.getTipoUsoDestino().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoUsoDestinoDescripcion", activo.getTipoUsoDestino().getDescripcion());
		}
		
		if (activo.getInfoComercial() != null && activo.getInfoComercial().getTipoInfoComercial() != null) {
			BeanUtils.copyProperty(activoDto, "tipoInfoComercialCodigo", activo.getInfoComercial().getTipoInfoComercial().getCodigo());
		}

		if(activo.getTipoComercializar() != null){
			BeanUtils.copyProperty(activoDto, "tipoComercializarCodigo", activo.getTipoComercializar().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoComercializarDescripcion", activo.getTipoComercializar().getDescripcion());
		}
		//Hace referencia a Destino Comercial (Si te lía el nombre, habla con Fernando)
		if(!Checks.esNulo(activo.getActivoPublicacion()) && !Checks.esNulo(activo.getActivoPublicacion().getTipoComercializacion())){
			BeanUtils.copyProperty(activoDto, "tipoComercializacionCodigo", activo.getActivoPublicacion().getTipoComercializacion().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoComercializacionDescripcion", activo.getActivoPublicacion().getTipoComercializacion().getDescripcion());
		}
		
		if(activo.getTipoAlquiler() != null){
			BeanUtils.copyProperty(activoDto, "tipoAlquilerCodigo", activo.getTipoAlquiler().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoAlquilerDescripcion", activo.getTipoAlquiler().getDescripcion());
		}
		
		if(!activo.getAgrupaciones().isEmpty()) {
			Boolean pertenceAgrupacionRestringida = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja())) {
					if(!Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())){
						pertenceAgrupacionRestringida = true;
						break;
					}
				}
			}
			Boolean perteneceAgrupacionRestringidaVigente = false;
			Date currentDate = new Date();
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja())) {
					if(!Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion())
							&& DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())
							&& (Checks.esNulo(agrupaciones.getAgrupacion().getFechaFinVigencia())
									|| (!Checks.esNulo(agrupaciones.getAgrupacion().getFechaFinVigencia())
											&& (agrupaciones.getAgrupacion().getFechaFinVigencia().before(currentDate)
											|| agrupaciones.getAgrupacion().getFechaFinVigencia().equals(currentDate))))
					){
						perteneceAgrupacionRestringidaVigente = true;
						if (!Checks.esNulo(agrupaciones.getAgrupacion().getActivoPrincipal())) {
							BeanUtils.copyProperty(activoDto, "activoPrincipalRestringida",
									agrupaciones.getAgrupacion().getActivoPrincipal().getNumActivo());
						}
						break;
					}
				}
			}
			Boolean pertenceAgrupacionComercial = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja())) {
					if(!Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())){
						pertenceAgrupacionComercial = true;
						break;
					}
				}
			}
			Boolean pertenceAgrupacionAsistida = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja()) && !Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) &&
						DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					pertenceAgrupacionAsistida = true;
					break;
				}
			}
			Boolean pertenceAgrupacionObraNueva = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja()) && !Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) &&
						DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					pertenceAgrupacionObraNueva = true;
					break;
				}
			}

			Boolean pertenceAgrupacionProyecto = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja()) && !Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) &&
						DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					pertenceAgrupacionProyecto = true;
					break;
				}
			}

			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionRestringida", pertenceAgrupacionRestringida);
			BeanUtils.copyProperty(activoDto, "perteneceAgrupacionRestringidaVigente", perteneceAgrupacionRestringidaVigente);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionComercial", pertenceAgrupacionComercial);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionAsistida", pertenceAgrupacionAsistida);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionObraNueva", pertenceAgrupacionObraNueva);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionProyecto", pertenceAgrupacionProyecto);
		}

		for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
			if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja()) && !Checks.esNulo(agrupaciones.getAgrupacion().getId())) {
				BeanUtils.copyProperty(activoDto,"idAgrupacion", agrupaciones.getAgrupacion().getId());
				break;
			}
		}

		BeanUtils.copyProperty(activoDto, "informeComercialAceptado", activoApi.isInformeComercialAceptado(activo));

		//Obtener si tiene posible informe mediador
		if (!Checks.esNulo(activo.getInfoComercial())) {
			if (!Checks.esNulo(activo.getInfoComercial().getPosibleInforme())){
				if (activo.getInfoComercial().getPosibleInforme() == 1){
					BeanUtils.copyProperty(activoDto, "tienePosibleInformeMediador", true);
				} else {
					BeanUtils.copyProperty(activoDto, "tienePosibleInformeMediador", false);
				}
			} else {
				BeanUtils.copyProperty(activoDto, "tienePosibleInformeMediador", true);
			}
		}
		else {
			BeanUtils.copyProperty(activoDto, "tienePosibleInformeMediador", true);
		}


		if(!Checks.esNulo(activo.getSituacionComercial())) {
			BeanUtils.copyProperty(activoDto, "situacionComercialCodigo", activo.getSituacionComercial().getCodigo());
			BeanUtils.copyProperty(activoDto, "situacionComercialDescripcion", activo.getSituacionComercial().getDescripcion());
		}

		// Perimetros ------------------		
		// Datos de perimetro del activo al Dto de datos basicos
		// - Puede no existir registro de perimetros en la tabla. Esto no producira errores de carga/guardado
		// - En caso de no haber registro relacionado con el activo, no se habilitaran validaciones/bloqueos 
		//   relacionados con el perimetro.
		// - Aunque no haya registro de perimetros, en estos activos aparecerán todos los checks activos de la pantalla
		//   de datos basicos (para indicar que se incluyen todos los modulos del activo y no hay bloqueos)
		PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
		BeanUtils.copyProperties(activoDto, perimetroActivo);
		
		// Si no esta en el perimetro, el activo se considera SOLO CONSULTA
		BeanUtils.copyProperty(activoDto, "incluidoEnPerimetro", perimetroActivo.getIncluidoEnPerimetro() == 1);
		
		if(!Checks.esNulo(activo.getAuditoria()) && !Checks.esNulo(activo.getAuditoria().getFechaCrear())) {
			BeanUtils.copyProperty(activoDto, "fechaAltaActivoRem", activo.getAuditoria().getFechaCrear());
		}
		
		if(!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getMotivoAplicaComercializar())) {
			BeanUtils.copyProperty(activoDto, "motivoAplicaComercializarCodigo", perimetroActivo.getMotivoAplicaComercializar().getCodigo());
			BeanUtils.copyProperty(activoDto, "motivoAplicaComercializarDescripcion", perimetroActivo.getMotivoAplicaComercializar().getDescripcion());
		}
		
		if(!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getMotivoNoAplicaComercializar())) {
			BeanUtils.copyProperty(activoDto, "motivoNoAplicaComercializar", perimetroActivo.getMotivoNoAplicaComercializar());
		}
		
		// Si no exite perimetro en BBDD, se crea una nueva instancia PerimetroActivo, con todas las condiciones marcadas
		// y por tanto, por defecto se marcan los checkbox.
		BeanUtils.copyProperty(activoDto,"aplicaTramiteAdmision", new Integer(1).equals(perimetroActivo.getAplicaTramiteAdmision()));
		BeanUtils.copyProperty(activoDto,"aplicaGestion", new Integer(1).equals(perimetroActivo.getAplicaGestion()));
		BeanUtils.copyProperty(activoDto,"aplicaAsignarMediador", new Integer(1).equals(perimetroActivo.getAplicaAsignarMediador()));
		BeanUtils.copyProperty(activoDto,"aplicaComercializar", new Integer(1).equals(perimetroActivo.getAplicaComercializar()));
		BeanUtils.copyProperty(activoDto,"aplicaFormalizar", new Integer(1).equals(perimetroActivo.getAplicaFormalizar()));
		if(!Checks.esNulo(perimetroActivo.getAplicaPublicar()))
			BeanUtils.copyProperty(activoDto,"aplicaPublicar", new Integer(1).equals(perimetroActivo.getAplicaPublicar() ? 1 : 0));
		BeanUtils.copyProperty(activoDto,"enTramite", activo.getEnTramite());
		BeanUtils.copyProperty(activoDto,"aplicaTramiteAdmision", new Integer(1).equals( perimetroActivo.getAplicaTramiteAdmision())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaGestion", new Integer(1).equals( perimetroActivo.getAplicaGestion())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaAsignarMediador", new Integer(1).equals(perimetroActivo.getAplicaAsignarMediador())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaComercializar", new Integer(1).equals(perimetroActivo.getAplicaComercializar())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaFormalizar", new Integer(1).equals(perimetroActivo.getAplicaFormalizar())? true: false);
		BeanUtils.copyProperty(activoDto,"enTramite", activo.getEnTramite());
		if(!Checks.esNulo(perimetroActivo.getAplicaPublicar()))
			BeanUtils.copyProperty(activoDto,"aplicaPublicar", new Integer(1).equals(perimetroActivo.getAplicaPublicar() ? 1 : 0));

		// En la sección de perímetro pero no dependiente del mismo.
		BeanUtils.copyProperty(activoDto, "numInmovilizadoBankia", activo.getNumInmovilizadoBnk());

		//Comprobar los condicionantes del indicador Venta y Alquiler
		BeanUtils.copyProperties(activoDto, perimetroActivo);

		// Indicador del estado de publicación para venta y alquiler.
		activoDto.setEstadoVenta(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionVenta(activo));
		activoDto.setEstadoAlquiler(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAlquiler(activo));

		// Datos de activo bancario del activo al Dto de datos basicos
		ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getClaseActivo())) {
			BeanUtils.copyProperty(activoDto, "claseActivoCodigo", activoBancario.getClaseActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "claseActivoDescripcion", activoBancario.getClaseActivo().getDescripcion());
		}
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getSubtipoClaseActivo())) {
			BeanUtils.copyProperty(activoDto, "subtipoClaseActivoCodigo", activoBancario.getSubtipoClaseActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "subtipoClaseActivoDescripcion", activoBancario.getSubtipoClaseActivo().getDescripcion());
		}

		//Como no envian el diccionario de tipoProducto, lo hemos sustituido por texto libre
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getProductoDescripcion())) {
			BeanUtils.copyProperty(activoDto, "productoDescripcion", activoBancario.getProductoDescripcion());
		}

		if(!Checks.esNulo(activoBancario)) {
			BeanUtils.copyProperty(activoDto, "numExpRiesgo", activoBancario.getNumExpRiesgo());
		}

		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getEstadoExpRiesgo())) {
			BeanUtils.copyProperty(activoDto, "estadoExpRiesgoCodigo", activoBancario.getEstadoExpRiesgo().getCodigo());
			BeanUtils.copyProperty(activoDto, "estadoExpRiesgoDescripcion", activoBancario.getEstadoExpRiesgo().getDescripcion());
		}

		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getEstadoExpIncorriente())) {
			BeanUtils.copyProperty(activoDto, "estadoExpIncorrienteCodigo", activoBancario.getEstadoExpIncorriente().getCodigo());
		}

		// En la sección de activo bancario pero no dependiente del mismo.
		if(!Checks.esNulo(activo.getEntradaActivoBankia())) {
			BeanUtils.copyProperty(activoDto, "entradaActivoBankiaCodigo", activo.getEntradaActivoBankia().getCodigo());
		}

		BeanUtils.copyProperty(activoDto, "integradoEnAgrupacionAsistida",activoApi.isIntegradoAgrupacionAsistida(activo));
		
		//Tipo de activo segun el Mediador
		if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
			BeanUtils.copyProperty(activoDto, "tipoActivoMediadorCodigo", activo.getInfoComercial().getTipoActivo().getCodigo());
		}
		
		if(!Checks.esNulo(activo.getGestorSelloCalidad())){
			BeanUtils.copyProperty(activoDto, "nombreGestorSelloCalidad", activo.getGestorSelloCalidad().getApellidoNombre());
		}

		List<VPreciosVigentes> listaPrecios = activoApi.getPreciosVigentesById(activo.getId());
		for (VPreciosVigentes listaPrecio : listaPrecios) {
			if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO)) {
				BeanUtils.copyProperty(activoDto, "minimoAutorizado", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA)) {
				BeanUtils.copyProperty(activoDto, "aprobadoVentaWeb", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA)) {
				BeanUtils.copyProperty(activoDto, "aprobadoRentaWeb", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_APROBADO)) {
				BeanUtils.copyProperty(activoDto, "descuentoAprobado", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO)) {
				BeanUtils.copyProperty(activoDto, "descuentoPublicado", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT)) {
				BeanUtils.copyProperty(activoDto, "valorNetoContable", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_COSTE_ADQUISICION)) {
				BeanUtils.copyProperty(activoDto, "costeAdquisicion", listaPrecio.getImporte());
			}
		}

		if(!Checks.esNulo(activo.getTasacion()) && !activo.getTasacion().isEmpty()){
			ActivoTasacion tasacionMasReciente = activo.getTasacion().get(0);
			BeanUtils.copyProperty(activoDto, "valorUltimaTasacion", tasacionMasReciente.getImporteTasacionFin());
		}

		if(!Checks.esNulo(activo.getCodigoPromocionPrinex())) {
			BeanUtils.copyProperty(activoDto, "codigoPromocionPrinex", activo.getCodigoPromocionPrinex());
		}

		if(!Checks.esNulo(activo.getActivoBNK()) && !Checks.esNulo(activo.getActivoBNK().getAcbCoreaeTexto())){
			BeanUtils.copyProperty(activoDto, "acbCoreaeTexto", activo.getActivoBNK().getAcbCoreaeTexto());
		}

		if(!Checks.esNulo(activo.getActivoPublicacion())){
			BeanUtils.copyProperty(activoDto, "estadoAlquilerDescripcion", !Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionAlquiler()) ? activo.getActivoPublicacion().getEstadoPublicacionAlquiler().getDescripcion() : "");
			BeanUtils.copyProperty(activoDto, "estadoVentaDescripcion", !Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionVenta()) ? activo.getActivoPublicacion().getEstadoPublicacionVenta().getDescripcion(): "");
			BeanUtils.copyProperty(activoDto, "estadoAlquilerCodigo", !Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionAlquiler()) ? activo.getActivoPublicacion().getEstadoPublicacionAlquiler().getCodigo() : "");
			BeanUtils.copyProperty(activoDto, "estadoVentaCodigo", !Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionVenta()) ? activo.getActivoPublicacion().getEstadoPublicacionVenta().getCodigo(): "");
		}

		// Buscamos los campos que pueden ser propagados para esta pestaña
		activoDto.setCamposPropagables(TabActivoService.TAB_DATOS_BASICOS);

		if (!Checks.esNulo(activo.getSituacionPosesoria()) && !Checks.esNulo(activo.getSituacionPosesoria().getOcupado())) {
			activoDto.setOcupado(activo.getSituacionPosesoria().getOcupado());
		} else {
			activoDto.setOcupado(0);
		}

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		List<DtoListadoGestores> listaGestores = adapter.getGestoresActivos(activo.getId());
		for(DtoListadoGestores gestor : listaGestores){
			if(usuarioLogado.getId().equals(gestor.getIdUsuario())
					&& (GestorActivoApi.CODIGO_GESTOR_ALQUILERES.equals(gestor.getCodigo())
					|| GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES.equals(gestor.getCodigo())
					|| GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES.equals(gestor.getCodigo())
					|| GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES.equals(gestor.getCodigo()))) {
				BeanUtils.copyProperty(activoDto, "esGestorAlquiler", true);
				break;
			}
		}

		ActivoPatrimonio activoP = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
		if(!Checks.esNulo(activoP)) {
			if (!Checks.esNulo(activoP.getTipoEstadoAlquiler())) {
				activoDto.setTipoEstadoAlquiler(activoP.getTipoEstadoAlquiler().getCodigo());

			}

			if(!Checks.esNulo(activoP.getCheckHPM())) {
				BeanUtils.copyProperty(activoDto, "activoChkPerimetroAlquiler", activoP.getCheckHPM());
			}

			if(!Checks.esNulo(activoP.getTipoInquilino())) {
				activoDto.setTipoInquilino(activoP.getTipoInquilino().getCodigo());
			}
		}
		
		boolean tieneOfertaAlquilerViva = false;
		
		//Cambiamos la forma de obtener si una oferta esta viva, de comprobar si el estado de la oferta es 
		//Aceptado/tramitada a comprobar si una oferta tiene tareas activas, si tiene alguna tarea activa,
		//la oferta estara viva, si por el contrario, tiene todas las tareas finalizadas la oferta no estara viva
		/*for(ActivoOferta activoOferta : activo.getOfertas()) {
			Oferta oferta = ofertaApi.getOfertaById(activoOferta.getOferta());
			if(DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
				tieneOfertaAlquilerViva = true;
			}
		}*/
		List<TareaActivo> listaTareas = tareaActivoApi.getTareasActivo(activo.getId(),ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_ALQUILER);
		if (!Checks.estaVacio(listaTareas)) {
			for (TareaActivo tarea : listaTareas) {
				if (!tarea.getTareaFinalizada()) {
					tieneOfertaAlquilerViva = true;
					break;
				}
			}
		}
		
		
		BeanUtils.copyProperty(activoDto, "tieneOfertaAlquilerViva", tieneOfertaAlquilerViva);

		Usuario gestorComercial = gestorActivoApi.getGestorComercialActual(activo, "GCOM");
		Usuario supervisorComercial = gestorActivoApi.getGestorComercialActual(activo, "SCOM");
		if(usuarioLogado.equals(gestorComercial) || usuarioLogado.equals(supervisorComercial) || genericAdapter.isSuper(usuarioLogado)) {
			activoDto.setIsLogUsuGestComerSupComerSupAdmin(true);
		}else{
			activoDto.setIsLogUsuGestComerSupComerSupAdmin(false);
		}
		
		List<VAdmisionDocumentos> admisionDocumentos = adapter.getListAdmisionCheckDocumentos(activo.getId());
		
		for (VAdmisionDocumentos doc : admisionDocumentos) {
			if ("CEE (Certificado de eficiencia energética)".equals(doc.getDescripcionTipoDoc()) && doc.getAplica().equals("1")) {
				BeanUtils.copyProperty(activoDto, "tieneCEE", true);
				break;
			}
		}

		return activoDto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto)  throws JsonViewerException {
		DtoActivoFichaCabecera dto = (DtoActivoFichaCabecera) webDto;
		
		try {
			beanUtilNotNull.copyProperties(activo, dto);
			
			boolean reiniciarPBC = false;
			
			if (Checks.esNulo(activo.getLocalizacion())) {
				activo.setLocalizacion(new ActivoLocalizacion());
				activo.getLocalizacion().setActivo(activo);
			}
			
			if (Checks.esNulo(activo.getLocalizacion().getLocalizacionBien())){
				NMBLocalizacionesBien localizacionesVacia = new NMBLocalizacionesBien();
				localizacionesVacia.setBien(activo.getBien());
				activo.getLocalizacion().setLocalizacionBien(localizacionesVacia);
				activo.getLocalizacion().setLocalizacionBien(genericDao.save(NMBLocalizacionesBien.class, activo.getLocalizacion().getLocalizacionBien()));
			}
			
			beanUtilNotNull.copyProperties(activo.getLocalizacion(), dto);
			beanUtilNotNull.copyProperties(activo.getLocalizacion().getLocalizacionBien(), dto);
			
			activo.setLocalizacion(genericDao.save(ActivoLocalizacion.class, activo.getLocalizacion()));

			if (!Checks.esNulo(dto.getPaisCodigo())) {
				DDCicCodigoIsoCirbeBKP pais = (DDCicCodigoIsoCirbeBKP) diccionarioApi.dameValorDiccionarioByCod(DDCicCodigoIsoCirbeBKP.class,  dto.getPaisCodigo());
				activo.getLocalizacion().getLocalizacionBien().setPais(pais);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getTipoViaCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoViaCodigo());
				DDTipoVia tipoViaNueva = (DDTipoVia) genericDao.get(DDTipoVia.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setTipoVia(tipoViaNueva);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getProvinciaCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
				DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setProvincia(provincia);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getMunicipioCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setLocalidad(municipioNuevo);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getInferiorMunicipioCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getInferiorMunicipioCodigo());
				DDUnidadPoblacional inferiorNuevo = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setUnidadPoblacional(inferiorNuevo);
				reiniciarPBC = true;
			}
			
			activo.getLocalizacion().setLocalizacionBien(genericDao.save(NMBLocalizacionesBien.class, activo.getLocalizacion().getLocalizacionBien()));
			
			if (!Checks.esNulo(dto.getTipoActivoCodigo())) {
				DDTipoActivo tipoActivo = (DDTipoActivo) diccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class,  dto.getTipoActivoCodigo());
				activo.setTipoActivo(tipoActivo);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getSubtipoActivoCodigo())) {
				DDSubtipoActivo subtipoActivo = (DDSubtipoActivo) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivo.class,  dto.getSubtipoActivoCodigo());
				activo.setSubtipoActivo(subtipoActivo);
				reiniciarPBC = true;
			}
			
			Filter filterLbk = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoInfoLiberbank actInfLiber = genericDao.get(ActivoInfoLiberbank.class, filterLbk);

			if (!Checks.esNulo(actInfLiber)){
				if (!Checks.esNulo(dto.getTipoActivoCodigoBde())){
					DDTipoActivoBDE tipoActivoBde = (DDTipoActivoBDE) diccionarioApi.dameValorDiccionarioByCod(DDTipoActivoBDE.class,  dto.getTipoActivoCodigoBde());
					actInfLiber.setTipoActivoBde(tipoActivoBde);
				}
				if (!Checks.esNulo(dto.getSubtipoActivoCodigoBde())){
					DDSubtipoActivoBDE subTipoActivoBde = (DDSubtipoActivoBDE) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivoBDE.class,  dto.getSubtipoActivoCodigoBde());
					actInfLiber.setSubtipoActivoBde(subTipoActivoBde);
				}
				genericDao.update(ActivoInfoLiberbank.class, actInfLiber);
			} else {
				actInfLiber = new ActivoInfoLiberbank();
				if (!Checks.esNulo(dto.getTipoActivoCodigoBde())){
					DDTipoActivoBDE tipoActivoBde = (DDTipoActivoBDE) diccionarioApi.dameValorDiccionarioByCod(DDTipoActivoBDE.class,  dto.getTipoActivoCodigoBde());
					actInfLiber.setTipoActivoBde(tipoActivoBde);
				}
				if (!Checks.esNulo(dto.getSubtipoActivoCodigoBde())){
					DDSubtipoActivoBDE subTipoActivoBde = (DDSubtipoActivoBDE) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivoBDE.class,  dto.getSubtipoActivoCodigoBde());
					actInfLiber.setSubtipoActivoBde(subTipoActivoBde);
				}
				actInfLiber.setId(activo.getId());
				genericDao.save(ActivoInfoLiberbank.class, actInfLiber);
			}

			if (!Checks.esNulo(dto.getTipoTitulo())) {
				DDTipoTituloActivo tipoTitulo = (DDTipoTituloActivo) diccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivo.class,  dto.getTipoTitulo());
				activo.setTipoTitulo(tipoTitulo);
			}
			
			if (!Checks.esNulo(dto.getTipoUsoDestinoCodigo())) {
				DDTipoUsoDestino tipoUsoDestino = (DDTipoUsoDestino) diccionarioApi.dameValorDiccionarioByCod(DDTipoUsoDestino.class,  dto.getTipoUsoDestinoCodigo());
				activo.setTipoUsoDestino(tipoUsoDestino);				
				//Actualizar el tipoComercialización del activo
				updaterState.updaterStateTipoComercializacion(activo);
			}
			
			if (!Checks.esNulo(dto.getEstadoActivoCodigo())) {
				DDEstadoActivo estadoActivo = (DDEstadoActivo) diccionarioApi.dameValorDiccionarioByCod(DDEstadoActivo.class,  dto.getEstadoActivoCodigo());
				activo.setEstadoActivo(estadoActivo);
			}
			
			// Se genera un registro en el histórico por la modificación de los datos en el apartado de 'Datos Admisión' de informe comercial.
			if(
				!Checks.esNulo(dto.getTipoActivoCodigo()) || !Checks.esNulo(dto.getSubtipoActivoCodigo()) ||
				!Checks.esNulo(dto.getTipoViaCodigo()) || !Checks.esNulo(dto.getNombreVia()) || 
				!Checks.esNulo(dto.getNumeroDomicilio()) || !Checks.esNulo(dto.getEscalera()) ||
				!Checks.esNulo(dto.getPiso()) || !Checks.esNulo(dto.getPuerta()) ||
				!Checks.esNulo(dto.getCodPostal()) || !Checks.esNulo(dto.getMunicipioCodigo()) ||
				!Checks.esNulo(dto.getProvinciaCodigo()) || !Checks.esNulo(dto.getLatitud()) ||
				!Checks.esNulo(dto.getLongitud()))
			{
				ActivoEstadosInformeComercialHistorico activoEstadoInfComercialHistorico = new ActivoEstadosInformeComercialHistorico();
				activoEstadoInfComercialHistorico.setActivo(activo);
				Filter filtroDDInfComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_MODIFICACION);
				DDEstadoInformeComercial ddInfComercial = genericDao.get(DDEstadoInformeComercial.class, filtroDDInfComercial);
				activoEstadoInfComercialHistorico.setEstadoInformeComercial(ddInfComercial);
				activoEstadoInfComercialHistorico.setFecha(new Date());
				activoEstadoInfComercialHistorico.setMotivo(DtoEstadosInformeComercialHistorico.ESTADO_MOTIVO_MODIFICACION_MANUAL);
				genericDao.save(ActivoEstadosInformeComercialHistorico.class, activoEstadoInfComercialHistorico);
				reiniciarPBC = true;
			}
			
			// Perimetro -------
			// Solo se guardan los datos si el usuario ha cambiado algun campo de perimetros
			// El control de cambios se realiza revisando los datos que transporta el dto
			// Solo se modifican/crean nuevos registros de perimetros si hay guardado de datos
			if(dto.getAplicaAsignarMediador() != null || dto.getAplicaComercializar() != null || dto.getAplicaFormalizar() != null ||
				dto.getAplicaGestion() != null  || dto.getAplicaTramiteAdmision() != null || dto.getMotivoAplicaComercializarCodigo() != null ||
				dto.getMotivoNoAplicaComercializar() != null || dto.getIncluidoEnPerimetro() != null ||	dto.getFechaAltaActivoRem() != null ||
				dto.getFechaAplicaTramiteAdmision() != null || dto.getMotivoAplicaTramiteAdmision() != null || dto.getFechaAplicaGestion() != null ||
				dto.getMotivoAplicaGestion() != null || dto.getFechaAplicaAsignarMediador() != null || dto.getMotivoAplicaAsignarMediador() != null ||
				dto.getFechaAplicaComercializar() != null || dto.getMotivoAplicaComercializarDescripcion() != null ||
				dto.getFechaAplicaFormalizar() != null || dto.getMotivoAplicaFormalizar() != null || dto.getAplicaPublicar() != null ||
				dto.getFechaAplicaPublicar() != null || dto.getMotivoAplicaPublicar() != null)
			{
				PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
				beanUtilNotNull.copyProperties(perimetroActivo, dto);
				
				//Si no existe perimetro, se creará un registro nuevo, con las opciones por defecto
				if(Checks.esNulo(perimetroActivo.getActivo())) {
					perimetroActivo.setActivo(activo);
					perimetroActivo.setIncluidoEnPerimetro(1);
					perimetroActivo.setAplicaAsignarMediador(1);
					perimetroActivo.setAplicaComercializar(1);
					perimetroActivo.setAplicaFormalizar(1);
					perimetroActivo.setAplicaGestion(1);
					perimetroActivo.setAplicaTramiteAdmision(1);
				}
				
				// Conversion manual. En el dto son booleanos y en la entidad Integer.
				// Asignar al cambiar estado de los checks también la fecha de hoy.
				if(!Checks.esNulo(dto.getAplicaAsignarMediador())) {
					perimetroActivo.setAplicaAsignarMediador(dto.getAplicaAsignarMediador() ? 1 : 0);
					perimetroActivo.setFechaAplicaAsignarMediador(new Date());
				}
				if(!Checks.esNulo(dto.getAplicaComercializar())) {
					perimetroActivo.setAplicaComercializar(dto.getAplicaComercializar() ? 1 : 0);
					perimetroActivo.setFechaAplicaComercializar(new Date());
					
					//Acciones al desmarcar check comercializar
					if(!dto.getAplicaComercializar()) {
						this.accionesDesmarcarComercializar(activo);
					}
				}
				if(!Checks.esNulo(dto.getAplicaFormalizar())) {
					perimetroActivo.setAplicaFormalizar(dto.getAplicaFormalizar() ? 1 : 0);
					perimetroActivo.setFechaAplicaFormalizar(new Date());
					
					//Validacion al desmarcar check formalizar
					if(!dto.getAplicaFormalizar()) {
						this.validarPerimetroActivo(activo,2);
					}
				}

				if(!Checks.esNulo(dto.getAplicaGestion())) {
					perimetroActivo.setAplicaGestion(dto.getAplicaGestion() ? 1 : 0);
					perimetroActivo.setFechaAplicaGestion(new Date());
				}

				if(!Checks.esNulo(dto.getAplicaTramiteAdmision())) {
					perimetroActivo.setAplicaTramiteAdmision(dto.getAplicaTramiteAdmision() ? 1 : 0);
					perimetroActivo.setFechaAplicaTramiteAdmision(new Date());
				}

				if (!Checks.esNulo(dto.getMotivoAplicaComercializarCodigo())) {
					DDMotivoComercializacion motivoAplicaComercializar = (DDMotivoComercializacion) diccionarioApi.dameValorDiccionarioByCod(DDMotivoComercializacion.class,  dto.getMotivoAplicaComercializarCodigo());
					perimetroActivo.setMotivoAplicaComercializar(motivoAplicaComercializar);
				}

				if(!Checks.esNulo(dto.getAplicaPublicar())) {
					perimetroActivo.setAplicaPublicar(dto.getAplicaPublicar());
					perimetroActivo.setFechaAplicaPublicar(new Date());
				}

				beanUtilNotNull.copyProperty(perimetroActivo, "motivoNoAplicaComercializar", dto.getMotivoNoAplicaComercializar());

				activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);
			}
			
			// --------- Perimetro --> Bloque Comercializción
			if (!Checks.esNulo(dto.getTipoComercializarCodigo())) {
				DDTipoComercializar tipoComercializar = (DDTipoComercializar) diccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class,  dto.getTipoComercializarCodigo());
				activo.setTipoComercializar(tipoComercializar);
			}
			//Hace referencia a Destino Comercial (Si te lía el nombre, habla con Fernando)
			if (!Checks.esNulo(dto.getTipoComercializacionCodigo()) && !Checks.esNulo(activo.getActivoPublicacion())) {

				// Hace throws en caso de inflingir alguna valdiacion con el cambio de TipoComercializacion a realizar
				validarCambiosTipoComercializacion(activo,dto);

				activoEstadoPublicacionApi.actualizarPublicacionActivoCambioTipoComercializacion(activo, dto.getTipoComercializacionCodigo());

				// Actualizar registros del Historico Destino Comercial
				activoApi.updateHistoricoDestinoComercial(activo, null);
			}
			
			if (!Checks.esNulo(dto.getTipoAlquilerCodigo())) {
				DDTipoAlquiler tipoAlquiler = (DDTipoAlquiler) diccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class,  dto.getTipoAlquilerCodigo());
				activo.setTipoAlquiler(tipoAlquiler);
			}

			// --------- Perimetro --> Bloque Administración.
			beanUtilNotNull.copyProperty(activo, "numInmovilizadoBnk", dto.getNumInmovilizadoBankia());
			
			//HREOS-1983 - Si marcan el check de sello de calidad, ponemos la fecha actual y el gestor logueado.
			if((!Checks.esNulo(dto.getSelloCalidad()) && dto.getSelloCalidad()) || 
				(!Checks.esNulo(dto.getFechaRevisionSelloCalidad()) && !Checks.esNulo(dto.getNombreGestorSelloCalidad()))) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				if(!Checks.esNulo(usuarioLogado)){
					activo.setGestorSelloCalidad(usuarioLogado);
				}
				activo.setFechaRevisionSelloCalidad(new Date());
				activo.setSelloCalidad(true);
			}else if(!Checks.esNulo(dto.getSelloCalidad()) && !dto.getSelloCalidad()){
				activo.setGestorSelloCalidad(null);
				activo.setFechaRevisionSelloCalidad(null);
				activo.setSelloCalidad(false);
			}
			
			// Activo bancario -------------
			// Solo se guardan los datos si el usuario ha cambiado algun campo del activo bancario.
			// El control de cambios se realiza revisando los datos que transporta el dto
			// Solo se modifican/crean nuevos registros de activo bancario si hay guardado de datos
			if(
				dto.getClaseActivoCodigo() != null || 
				dto.getClaseActivoDescripcion() != null || 
				dto.getSubtipoClaseActivoCodigo() != null || 
				dto.getSubtipoClaseActivoDescripcion() != null || 
				dto.getNumExpRiesgo() != null || 
				dto.getTipoProductoCodigo() != null || 
				dto.getTipoProductoDescripcion() != null || 
				dto.getEstadoExpRiesgoCodigo() != null || 
				dto.getEstadoExpRiesgoDescripcion() != null || 
				dto.getEstadoExpIncorrienteCodigo() != null || 
				dto.getEstadoExpIncorrienteDescripcion() != null ||
				dto.getProductoDescripcion() != null) 
			{
				
				ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
				
				beanUtilNotNull.copyProperties(activoBancario, dto);
	
				if(!Checks.esNulo(activoBancario) && Checks.esNulo(activoBancario.getActivo())) {
					activoBancario.setActivo(activo);
				}
				
				if(!Checks.esNulo(dto.getClaseActivoCodigo())) {
					DDClaseActivoBancario claseActivo = (DDClaseActivoBancario) diccionarioApi.dameValorDiccionarioByCod(DDClaseActivoBancario.class, dto.getClaseActivoCodigo());
					activoBancario.setClaseActivo(claseActivo);
				} else {
					DDClaseActivoBancario claseActivo = (DDClaseActivoBancario) diccionarioApi.dameValorDiccionarioByCod(DDClaseActivoBancario.class, DDClaseActivoBancario.CODIGO_INMOBILIARIO);
					activoBancario.setClaseActivo(claseActivo);
				}
				
				if(!Checks.esNulo(dto.getSubtipoClaseActivoCodigo())) {
					DDSubtipoClaseActivoBancario subtipoClaseActivo = (DDSubtipoClaseActivoBancario) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoClaseActivoBancario.class, dto.getSubtipoClaseActivoCodigo());
					activoBancario.setSubtipoClaseActivo(subtipoClaseActivo);
				}
	
				if(!Checks.esNulo(dto.getTipoProductoCodigo())) {
					DDTipoProductoBancario tipoProducto = (DDTipoProductoBancario) diccionarioApi.dameValorDiccionarioByCod(DDTipoProductoBancario.class, dto.getTipoProductoCodigo());
					activoBancario.setTipoProducto(tipoProducto);
				}
				
				if(!Checks.esNulo(dto.getEstadoExpRiesgoCodigo())) {
					DDEstadoExpRiesgoBancario estadoExpRiesgo = (DDEstadoExpRiesgoBancario) diccionarioApi.dameValorDiccionarioByCod(DDEstadoExpRiesgoBancario.class, dto.getEstadoExpRiesgoCodigo());
					activoBancario.setEstadoExpRiesgo(estadoExpRiesgo);
				}
	
				if(!Checks.esNulo(dto.getEstadoExpIncorrienteCodigo())) {
					DDEstadoExpIncorrienteBancario estadoExpIncorriente = (DDEstadoExpIncorrienteBancario) diccionarioApi.dameValorDiccionarioByCod(DDEstadoExpIncorrienteBancario.class, dto.getEstadoExpIncorrienteCodigo());
					activoBancario.setEstadoExpIncorriente(estadoExpIncorriente);
				}
				
				activoApi.saveOrUpdateActivoBancario(activoBancario);
			
			}

			if(!Checks.esNulo(dto.getEntradaActivoBankiaCodigo())) {
				DDEntradaActivoBankia entradaActivoBankia = (DDEntradaActivoBankia) diccionarioApi.dameValorDiccionarioByCod(DDEntradaActivoBankia.class, dto.getEntradaActivoBankiaCodigo());
				activo.setEntradaActivoBankia(entradaActivoBankia);
			}
			// -----
			
			if(reiniciarPBC) {
				ExpedienteComercial expediente = expedienteComercialApi.getExpedienteComercialResetPBC(activo);
				if(!Checks.esNulo(expediente)) {
					ofertaApi.resetPBC(expediente, false);
				}
			}

		} catch(JsonViewerException jve) {
			throw jve;
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
	}
	
	/**
	 * Acciones al desmarcar check Comercializar
	 * 1. Valida si se puede demarcar (Activo sin ofertas vivas).
	 * 2. Valida si el activo pertenece a una agrupación de tipo restringida y es el activo principal.
	 * 3. Si puede desmarcar y es activo principal de una agrupación de tipo restringida, actualizar estado publicación.
	 *
	 * @param activo: activo sobre el que se desmarca comercializar.
	 */
	private void accionesDesmarcarComercializar(Activo activo) {
		ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();
		idActivoActualizarPublicacion.add(activo.getId());
		this.validarPerimetroActivo(activo,1);
		this.validarPerimetroActivo(activo,3);
		activoAdapter.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion,false);
		//activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
	}
	
	/**
	 * Valida condiciones del perimitro, según se marque/desmarque los checks.
	 * case 1: Al desmarcar check comercializar, no se puede hacer si el activo tiene ofertas vivas. (estado != rechazada)
	 * case 2: Al desmarcar check formalizar, no se puede hacer si el activo tiene un exp. comercial vivo (tareas activas)
	 * case 3: Al desmarcar check comercializar, no se puede hacer si el activo se encuentra en una agrupación restringida y NO es activo principal.
	 * @param activo
	 * @return
	 */
	private void validarPerimetroActivo(Activo activo, Integer numVal) {
		
		String error = null;
		
		switch(numVal) {
			case 1: {
				if(activoApi.isActivoConOfertasVivas(activo))
					error = messageServices.getMessage(MSG_ERROR_PERIMETRO_COMERCIALIZACION_OFERTAS_VIVAS);
				break;
			}
			case 2: {
				if(expedienteComercialApi.isExpedienteComercialVivoByActivo(activo))
					error = messageServices.getMessage(MSG_ERROR_PERIMETRO_FORMALIZACION_EXPEDIENTE_VIVO);
				break;
			}
			case 3: {
				if(activoApi.isIntegradoAgrupacionRestringida(activo.getId(), genericAdapter.getUsuarioLogado())) {
					if(activoApi.isActivoPrincipalAgrupacionRestringida(activo.getId())) {
						// Quitar comercializar todos los activos de la misma AGR restringida que el activo.
						this.quitarComercializacionEnActivosAgrupacionRestringidaPorActivo(activo);
					} else {
						error = messageServices.getMessage(MSG_ERROR_PERIMETRO_COMERCIALIZACION_AGR_RESTRINGIDA_NO_PRINCIPAL);
					}
				}

				break;
			}
			default:
				break;
		}
		
		if(!Checks.esNulo(error))
			throw new JsonViewerException(error);
	}

	/**
	 * Este método pone la comercialización de todos los activos de una agrupación de tipo restringida
	 * a NO. Obtiene la agrupación en base a un activo.
	 * 
	 * @param activo: activo desde el que obtener la agrupación de tipo restringida.
	 */
	private void quitarComercializacionEnActivosAgrupacionRestringidaPorActivo(Activo activo) {
		ActivoAgrupacionActivo activoAgrupacionActivo = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId());

		if(activoAgrupacionActivo == null) {
			return;
		}

		List<ActivoAgrupacionActivo> activoAgrupacionActivoList = activoAgrupacionActivo.getAgrupacion().getActivos();

		for(ActivoAgrupacionActivo activos : activoAgrupacionActivoList) {
			// No modificar el perímetro del activo de procedencia, su perimetro se actualiza en el método padre de la tab.
			if(activos.getActivo().getId() == activo.getId()) {
				continue;
			}

			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activos.getActivo().getId());
			if(perimetroActivo != null) {
				perimetroActivo.setAplicaComercializar(0);
				perimetroActivo.setFechaAplicaComercializar(new Date());

				perimetroActivo.setAplicaFormalizar(0);
				perimetroActivo.setFechaAplicaFormalizar(new Date());

				activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);
			}
		}
	}
	
	public void afterSaveTabActivo(Activo activo, WebDto dto) {
		
		DtoActivoFichaCabecera dtoFicha = (DtoActivoFichaCabecera) dto;
		
		// Comprueba si ha habido cambios en el Tipo Comercializar para
				// actualizar el gestor comercial de las tareas
		if (!Checks.esNulo(dtoFicha.getTipoComercializarCodigo())) {
			String codGestorSingular = "GCOMSIN", codGestorRetail = "GCOMRET";
			Boolean isActivoRetail = DDTipoComercializar.CODIGO_RETAIL.equals(activo.getTipoComercializar().getCodigo());

			// Comprobamos que se pueda realizar el cambio, analizando tareas
			// activas comerciales y si hay gestor adecuado en el activo
			if (gestorActivoApi.existeGestorEnActivo(activo, isActivoRetail ? codGestorRetail : codGestorSingular)) {
				if (gestorActivoApi.validarTramitesNoMultiActivo(activo.getId()))
					gestorActivoApi.actualizarTareas(activo.getId());
				else {
					// El activo pertenece a un trámite multiactivo, y por tanto no
					// se puede cambiar el gestor en las taras, enviamos un aviso al
					// gestor comercial anterior
					// Si ahora el activo es Retail, entonces antes era Singular. Y
					// viceversa.
					String codComercialAnterior = isActivoRetail ? "GCOMSIN" : "GCOMRET";
					Usuario usuario = gestorActivoApi.getGestorComercialActual(activo, codComercialAnterior);

					if (!Checks.esNulo(usuario) && activoTareaExternaApi.existenTareasActivasByTramiteAndTipoGestor(activo,
							ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA, codComercialAnterior)) {
						Notificacion notif = new Notificacion();
						String tipoComercialDesc = !isActivoRetail ? DDTipoComercializar.DESCRIPCION_SINGULAR
								: DDTipoComercializar.DESCRIPCION_RETAIL;
						String tipoComercialDescAnterior = isActivoRetail ? DDTipoComercializar.DESCRIPCION_SINGULAR
								: DDTipoComercializar.DESCRIPCION_RETAIL;
						String[] datosDescripcion = { activo.getNumActivo().toString(), tipoComercialDescAnterior,
								tipoComercialDesc };
						String descripcion = messageServices.getMessage(AVISO_MENSAJE_GESTOR_COMERCIAL, datosDescripcion);

						notif.setIdActivo(activo.getId());
						notif.setDestinatario(usuario.getId());
						notif.setTitulo(messageServices.getMessage(AVISO_TITULO_GESTOR_COMERCIAL));
						notif.setDescripcion(descripcion);
						notif.setFecha(null);
						try {
							anotacionApi.saveNotificacion(notif);
						} catch (ParseException e) {
							logger.error("No se ha podido enviar el aviso por no poder cambiar el gestor comercial en las tareas: " + e);
						}
					}
				}
			}
		}
		
	}

	public void validarCambiosTipoComercializacion(Activo activo, DtoActivoFichaCabecera dto) {

		// Si intentamos cambiar de venta a alquiler
		// o de Alquiler y venta a alquiler
		// Se validará que no exista ninguna oferta viva de tipo venta

		if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dto.getTipoComercializacionCodigo())
				&& (DDTipoComercializacion.CODIGO_VENTA.equals(activo.getTipoComercializacion().getCodigo())
						|| DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(activo.getTipoComercializacion().getCodigo()))
				&& particularValidator.existeActivoConOfertaVentaViva("" + activo.getNumActivo())) {

				throw new JsonViewerException(messageServices.getMessage(MSG_ERROR_DESTINO_COMERCIAL_OFERTAS_VIVAS_VENTA));

		}

		// Si intentamos cambiar de alquiler a venta
		// o de Alquiler y venta a Venta
		// Se validará que no exista ninguna oferta viva de tipo alquiler

		if (DDTipoComercializacion.CODIGO_VENTA.equals(dto.getTipoComercializacionCodigo())
				&& (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(activo.getTipoComercializacion().getCodigo())
						|| DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(activo.getTipoComercializacion().getCodigo()))
				&& particularValidator.existeActivoConOfertaAlquilerViva("" + activo.getNumActivo())) {

				throw new JsonViewerException(messageServices.getMessage(MSG_ERROR_DESTINO_COMERCIAL_OFERTAS_VIVAS_ALQUILER));

		}


	}

}
