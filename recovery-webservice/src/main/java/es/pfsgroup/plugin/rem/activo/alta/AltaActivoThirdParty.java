package es.pfsgroup.plugin.rem.activo.alta;

import java.util.Calendar;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.ActivoDistribucion;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoLocalComercial;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.ActivoPlanDinVentas;
import es.pfsgroup.plugin.rem.model.ActivoPlazaAparcamiento;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoFinanciero;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoThirdParty;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.PresupuestoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpRiesgoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTasacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.ENTIDADES;
import es.pfsgroup.plugin.rem.service.AltaActivoThirdPartyService;


@Component
public class AltaActivoThirdParty implements AltaActivoThirdPartyService {

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private GenericAdapter adapter;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private RestApi restApi;
	
	@Override
	public String[] getKeys() {
		return this.getTipoAltaActivoThirdParty();
	}
	
	@Override
	public String[] getTipoAltaActivoThirdParty() {
		return new String[] { AltaActivoThirdPartyService.CODIGO_ALTA_ACTIVO_THIRD_PARTY };
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean procesarAlta(DtoAltaActivoThirdParty dtoAATP) throws Exception {

		// Asignar los datos del DTO al nuevo activo y almacenarlo en la DB.
		Activo activo = this.dtoToEntityActivo(dtoAATP);

		// Si el nuevo activo se ha persistido correctamente, continuar con las demás entidades.
		if (!Checks.esNulo(activo)) {
			this.dtoToEntitiesOtras(dtoAATP, activo);
			restApi.marcarRegistroParaEnvio(ENTIDADES.ACTIVO, activo); //repasar
		} else {
			return false;
		}

		return true;
	}

	//crea un activo a partir del DtoAltaActivoThirdParty que recibe
	private Activo dtoToEntityActivo(DtoAltaActivoThirdParty dtoAATP) throws Exception{
		Activo activo = new Activo();
		
		beanUtilNotNull.copyProperty(activo, "numActivo", dtoAATP.getNumActivoHaya());
		activo.setNumActivoRem(activoApi.getNextNumActivoRem());
		//nos falta el tipotitulo lpm
		//beanUtilNotNull.copyProperty(activo, "tipoTitulo", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivo.class, DDTipoTituloActivo.tipoTituloPDV));
		beanUtilNotNull.copyProperty(activo, "subtipoTitulo", utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoTituloActivo.class, dtoAATP.getSubtipoTituloCodigo()));
		beanUtilNotNull.copyProperty(activo, "cartera", utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, dtoAATP.getCodCartera()));
		//aqui ira o no el numero externo ese
		beanUtilNotNull.copyProperty(activo, "tipoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class, dtoAATP.getTipoActivoCodigo()));
		beanUtilNotNull.copyProperty(activo, "subtipoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivo.class, dtoAATP.getSubtipoActivoCodigo()));
		beanUtilNotNull.copyProperty(activo, "estadoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoActivo.class, dtoAATP.getEstadoFisicoCodigo()));
		beanUtilNotNull.copyProperty(activo, "tipoUsoDestino", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoUsoDestino.class, dtoAATP.getUsoDominanteCodigo()));
		beanUtilNotNull.copyProperty(activo, "descripcion", dtoAATP.getDescripcionActivo());
		
		beanUtilNotNull.copyProperty(activo, "tipoComercializacion",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, dtoAATP.getDestinoComercialCodigo()));
		beanUtilNotNull.copyProperty(activo, "tipoAlquiler", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class, dtoAATP.getTipoAlquilerCodigo()));
				
		activo = genericDao.save(Activo.class, activo);
		return activo;
	}
	
	
private void dtoToEntitiesOtras(DtoAltaActivoThirdParty dtoAATP, Activo activo) {
		
		//Localización del bien
		NMBLocalizacionesBien localizacionBien = new  NMBLocalizacionesBien();
		
	}

}
