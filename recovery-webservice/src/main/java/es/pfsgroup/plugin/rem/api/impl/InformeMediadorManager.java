package es.pfsgroup.plugin.rem.api.impl;

import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.impl.ActivoDaoImpl;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.HistoricoFasePublicacionActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.InformeMediadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoBanyo;
import es.pfsgroup.plugin.rem.model.ActivoCarpinteriaExterior;
import es.pfsgroup.plugin.rem.model.ActivoCarpinteriaInterior;
import es.pfsgroup.plugin.rem.model.ActivoCocina;
import es.pfsgroup.plugin.rem.model.ActivoDistribucion;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfraestructura;
import es.pfsgroup.plugin.rem.model.ActivoInstalacion;
import es.pfsgroup.plugin.rem.model.ActivoLocalComercial;
import es.pfsgroup.plugin.rem.model.ActivoParamentoVertical;
import es.pfsgroup.plugin.rem.model.ActivoPlazaAparcamiento;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoSolado;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.ActivoZonaComun;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDFasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubfasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInfoComercial;
import es.pfsgroup.plugin.rem.rest.api.DtoToEntityApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dao.impl.GenericaRestDaoImp;
import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.rest.dto.PlantaDto;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import net.sf.json.JSONObject;

@Service("informeMediadorManager")
public class InformeMediadorManager implements InformeMediadorApi {

	private HashMap<String, HashMap<String, Boolean>> obligatorios;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private RestApi restApi;

	@Autowired
	private DtoToEntityApi dtoToEntity;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoAdapter adapter;

	@Autowired
	private GenericaRestDaoImp genericaRestDaoImp;

	@Autowired
	private UpdaterStateApi updaterState;
	
	@Autowired
	private ActivoAdapter activoAdapterApi;
	
	@Autowired
	private HistoricoFasePublicacionActivoDao historicoFasePublicacionActivoDao;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	private static final String REST_USER_USERNAME = "REST-USER";

	public InformeMediadorManager() {
		obligatorios = new HashMap<String, HashMap<String, Boolean>>();

		// codEstadoConservacion
		HashMap<String, Boolean> codEstadoConservacion = new HashMap<String, Boolean>();
		codEstadoConservacion.put(DDTipoActivo.COD_VIVIENDA, true);
		codEstadoConservacion.put(DDTipoActivo.COD_COMERCIAL, true);
		codEstadoConservacion.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		codEstadoConservacion.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("codestadoconservacion", codEstadoConservacion);

		// anyoConstruccion
		HashMap<String, Boolean> anyoConstruccion = new HashMap<String, Boolean>();
		anyoConstruccion.put(DDTipoActivo.COD_VIVIENDA, true);
		anyoConstruccion.put(DDTipoActivo.COD_COMERCIAL, true);
		anyoConstruccion.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		anyoConstruccion.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("anyoconstruccion", anyoConstruccion);

		// anyoRehabilitacion
		HashMap<String, Boolean> anyoRehabilitacion = new HashMap<String, Boolean>();
		anyoRehabilitacion.put(DDTipoActivo.COD_VIVIENDA, true);
		anyoRehabilitacion.put(DDTipoActivo.COD_COMERCIAL, true);
		anyoRehabilitacion.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		anyoRehabilitacion.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("anyorehabilitacion", anyoRehabilitacion);

		// codOrientacion
		HashMap<String, Boolean> codOrientacion = new HashMap<String, Boolean>();
		codOrientacion.put(DDTipoActivo.COD_VIVIENDA, true);
		codOrientacion.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("codorientacion", codOrientacion);

		// ultimaPlanta
		HashMap<String, Boolean> ultimaPlanta = new HashMap<String, Boolean>();
		ultimaPlanta.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("ultimaplanta", ultimaPlanta);

		// ocupado
		HashMap<String, Boolean> ocupado = new HashMap<String, Boolean>();
		ocupado.put(DDTipoActivo.COD_VIVIENDA, true);
		ocupado.put(DDTipoActivo.COD_COMERCIAL, true);
		ocupado.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		ocupado.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("ocupado", ocupado);

		// ocupado
		HashMap<String, Boolean> numeroPlantas = new HashMap<String, Boolean>();
		numeroPlantas.put(DDTipoActivo.COD_VIVIENDA, true);
		numeroPlantas.put(DDTipoActivo.COD_COMERCIAL, true);
		numeroPlantas.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("numeroPlantas", numeroPlantas);

		// codNivelRenta
		HashMap<String, Boolean> codNivelRenta = new HashMap<String, Boolean>();
		codNivelRenta.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("codnivelrenta", codNivelRenta);

		// ultimaPlanta
		HashMap<String, Boolean> plantas = new HashMap<String, Boolean>();
		plantas.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("plantas", plantas);

		// numeroTerrazasDescubiertas
		HashMap<String, Boolean> numeroTerrazasDescubiertas = new HashMap<String, Boolean>();
		numeroTerrazasDescubiertas.put(DDTipoActivo.COD_VIVIENDA, true);
		numeroTerrazasDescubiertas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numeroterrazasdescubiertas", numeroTerrazasDescubiertas);

		// descripcionTerrazasDescubiertas
		HashMap<String, Boolean> descripcionTerrazasDescubiertas = new HashMap<String, Boolean>();
		descripcionTerrazasDescubiertas.put(DDTipoActivo.COD_VIVIENDA, true);
		descripcionTerrazasDescubiertas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("descripcionterrazasdescubiertas", descripcionTerrazasDescubiertas);

		// numeroTerrazasCubiertas
		HashMap<String, Boolean> numeroTerrazasCubiertas = new HashMap<String, Boolean>();
		numeroTerrazasCubiertas.put(DDTipoActivo.COD_VIVIENDA, true);
		numeroTerrazasCubiertas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numeroterrazascubiertas", numeroTerrazasCubiertas);

		// descripcionTerrazasCubiertas
		HashMap<String, Boolean> descripcionTerrazasCubiertas = new HashMap<String, Boolean>();
		descripcionTerrazasCubiertas.put(DDTipoActivo.COD_VIVIENDA, true);
		descripcionTerrazasCubiertas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("descripcionterrazascubiertas", descripcionTerrazasCubiertas);

		// despensaOtrasDependencias
		HashMap<String, Boolean> despensaOtrasDependencias = new HashMap<String, Boolean>();
		despensaOtrasDependencias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("despensaotrasdependencias", despensaOtrasDependencias);

		// lavaderoOtrasDependencias
		HashMap<String, Boolean> lavaderoOtrasDependencias = new HashMap<String, Boolean>();
		lavaderoOtrasDependencias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("lavaderootrasdependencias", lavaderoOtrasDependencias);

		// azoteaOtrasDependencias
		HashMap<String, Boolean> azoteaOtrasDependencias = new HashMap<String, Boolean>();
		azoteaOtrasDependencias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("lavaderootrasdependencias", azoteaOtrasDependencias);

		// otrosOtrasDependencias
		HashMap<String, Boolean> otrosOtrasDependencias = new HashMap<String, Boolean>();
		azoteaOtrasDependencias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otrosotrasdependencias", otrosOtrasDependencias);

		// instalacionElectricidadInstalaciones
		HashMap<String, Boolean> instalacionElectricidadInstalaciones = new HashMap<String, Boolean>();
		instalacionElectricidadInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		instalacionElectricidadInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("instalacionelectricidadinstalaciones", instalacionElectricidadInstalaciones);

		// contadorElectricidadInstalaciones
		HashMap<String, Boolean> contadorElectricidadInstalaciones = new HashMap<String, Boolean>();
		contadorElectricidadInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		contadorElectricidadInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("contadorelectricidadinstalaciones", contadorElectricidadInstalaciones);

		// instalacionAguaInstalaciones
		HashMap<String, Boolean> instalacionAguaInstalaciones = new HashMap<String, Boolean>();
		instalacionAguaInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		instalacionAguaInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("instalacionaguainstalaciones", instalacionAguaInstalaciones);

		// contadorAguaInstalaciones
		HashMap<String, Boolean> contadorAguaInstalaciones = new HashMap<String, Boolean>();
		contadorAguaInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		contadorAguaInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("contadoraguainstalaciones", contadorAguaInstalaciones);

		// gasInstalaciones
		HashMap<String, Boolean> gasInstalaciones = new HashMap<String, Boolean>();
		gasInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		gasInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("gasinstalaciones", gasInstalaciones);

		// contadorGasInstalacion
		HashMap<String, Boolean> contadorGasInstalacion = new HashMap<String, Boolean>();
		contadorGasInstalacion.put(DDTipoActivo.COD_VIVIENDA, true);
		contadorGasInstalacion.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("contadorgasinstalacion", contadorGasInstalacion);

		// exteriorCarpinteriaReformasNecesarias
		HashMap<String, Boolean> exteriorCarpinteriaReformasNecesarias = new HashMap<String, Boolean>();
		exteriorCarpinteriaReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("exteriorcarpinteriareformasNecesarias", exteriorCarpinteriaReformasNecesarias);

		// interiorCarpinteriaReformasNecesarias
		HashMap<String, Boolean> interiorCarpinteriaReformasNecesarias = new HashMap<String, Boolean>();
		interiorCarpinteriaReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("interiorCarpinteriaReformasNecesarias", interiorCarpinteriaReformasNecesarias);

		// cocinaReformasNecesarias
		HashMap<String, Boolean> cocinaReformasNecesarias = new HashMap<String, Boolean>();
		cocinaReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("cocinaReformasNecesarias", cocinaReformasNecesarias);

		// suelosReformasNecesarias
		HashMap<String, Boolean> suelosReformasNecesarias = new HashMap<String, Boolean>();
		suelosReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("suelosreformasnecesarias", suelosReformasNecesarias);

		// pinturaReformasNecesarias
		HashMap<String, Boolean> pinturaReformasNecesarias = new HashMap<String, Boolean>();
		pinturaReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("pinturareformasnecesarias", pinturaReformasNecesarias);

		// integralReformasNecesarias
		HashMap<String, Boolean> integralReformasNecesarias = new HashMap<String, Boolean>();
		integralReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("integralreformasnecesarias", integralReformasNecesarias);

		// banyosReformasNecesarias
		HashMap<String, Boolean> banyosReformasNecesarias = new HashMap<String, Boolean>();
		banyosReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("banyosreformasnecesarias", banyosReformasNecesarias);

		// otrasReformasNecesarias
		HashMap<String, Boolean> otrasReformasNecesarias = new HashMap<String, Boolean>();
		otrasReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otrasreformasnecesarias", otrasReformasNecesarias);

		// otrasReformasNecesariasImporteAproximado
		HashMap<String, Boolean> otrasReformasNecesariasImporteAproximado = new HashMap<String, Boolean>();
		otrasReformasNecesariasImporteAproximado.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otrasreformasnecesariasimporteAproximado", otrasReformasNecesariasImporteAproximado);

		// activosVinculados
		HashMap<String, Boolean> activosVinculados = new HashMap<String, Boolean>();
		activosVinculados.put(DDTipoActivo.COD_VIVIENDA, true);
		activosVinculados.put(DDTipoActivo.COD_COMERCIAL, true);
		activosVinculados.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("activosvinculados", activosVinculados);

		// distribucionInterior
		HashMap<String, Boolean> distribucionInterior = new HashMap<String, Boolean>();
		distribucionInterior.put(DDTipoActivo.COD_VIVIENDA, true);
		distribucionInterior.put(DDTipoActivo.COD_SUELO, true);
		distribucionInterior.put(DDTipoActivo.COD_COMERCIAL, true);
		distribucionInterior.put(DDTipoActivo.COD_INDUSTRIAL, true);
		distribucionInterior.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		distribucionInterior.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("distribucioninterior", distribucionInterior);

		// divisible
		HashMap<String, Boolean> divisible = new HashMap<String, Boolean>();
		divisible.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("otrasreformasnecesarias", divisible);

		// numeroAscensores
		HashMap<String, Boolean> numeroAscensores = new HashMap<String, Boolean>();
		numeroAscensores.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("numeroascensores", numeroAscensores);

		// descripcionPlantas
		HashMap<String, Boolean> descripcionPlantas = new HashMap<String, Boolean>();
		descripcionPlantas.put(DDTipoActivo.COD_COMERCIAL, true);
		descripcionPlantas.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("numeroascensores", descripcionPlantas);

		// otrasCaracteristicas
		HashMap<String, Boolean> otrasCaracteristicas = new HashMap<String, Boolean>();
		otrasCaracteristicas.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("otrascaracteristicas", otrasCaracteristicas);

		// fachadaReformasNecesarias
		HashMap<String, Boolean> fachadaReformasNecesarias = new HashMap<String, Boolean>();
		fachadaReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("fachadareformasnecesarias", fachadaReformasNecesarias);

		// escaleraReformasNecesarias
		HashMap<String, Boolean> escaleraReformasNecesarias = new HashMap<String, Boolean>();
		escaleraReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("escalerareformasnecesarias", escaleraReformasNecesarias);

		// portalReformasNecesarias
		HashMap<String, Boolean> portalReformasNecesarias = new HashMap<String, Boolean>();
		portalReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("portalreformasnecesarias", portalReformasNecesarias);

		// ascensorReformasNecesarias
		HashMap<String, Boolean> ascensorReformasNecesarias = new HashMap<String, Boolean>();
		ascensorReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("ascensorreformasnecesarias", ascensorReformasNecesarias);

		// cubierta
		HashMap<String, Boolean> cubierta = new HashMap<String, Boolean>();
		cubierta.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("cubierta", cubierta);

		// otrasZonasComunesReformasNecesarias
		HashMap<String, Boolean> otrasZonasComunesReformasNecesarias = new HashMap<String, Boolean>();
		otrasZonasComunesReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("otraszonascomunesreformasnecesarias", otrasZonasComunesReformasNecesarias);

		// otrosReformasNecesarias
		HashMap<String, Boolean> otrosReformasNecesarias = new HashMap<String, Boolean>();
		otrosReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("otrosreformasnecesarias", otrosReformasNecesarias);

		// descripcionEdificio
		HashMap<String, Boolean> descripcionEdificio = new HashMap<String, Boolean>();
		descripcionEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		descripcionEdificio.put(DDTipoActivo.COD_SUELO, true);
		descripcionEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		descripcionEdificio.put(DDTipoActivo.COD_INDUSTRIAL, true);
		descripcionEdificio.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		descripcionEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("descripcionedificio", descripcionEdificio);

		// infraestructurasEntorno
		HashMap<String, Boolean> infraestructurasEntorno = new HashMap<String, Boolean>();
		infraestructurasEntorno.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("infraestructurasentorno", infraestructurasEntorno);

		// comunicacionesEntorno
		HashMap<String, Boolean> comunicacionesEntorno = new HashMap<String, Boolean>();
		comunicacionesEntorno.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("comunicacionesEntorno", comunicacionesEntorno);

		// idoneoUso
		HashMap<String, Boolean> idoneoUso = new HashMap<String, Boolean>();
		idoneoUso.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("idoneoUso", idoneoUso);

		// existeAnteriorUso;
		HashMap<String, Boolean> existeAnteriorUso = new HashMap<String, Boolean>();
		existeAnteriorUso.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("existeanterioruso", existeAnteriorUso);

		// anteriorUso
		HashMap<String, Boolean> anteriorUso = new HashMap<String, Boolean>();
		anteriorUso.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("anterioruso", anteriorUso);

		// numeroEstancias
		HashMap<String, Boolean> numeroEstancias = new HashMap<String, Boolean>();
		numeroEstancias.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numeroestancias", numeroEstancias);

		// numeroBanyos
		HashMap<String, Boolean> numeroBanyos = new HashMap<String, Boolean>();
		numeroBanyos.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numerobanyos", numeroBanyos);

		// numeroAseos
		HashMap<String, Boolean> numeroAseos = new HashMap<String, Boolean>();
		numeroAseos.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numeroaseos", numeroAseos);

		// metrosLinealesFachadaPrincipal
		HashMap<String, Boolean> metrosLinealesFachadaPrincipal = new HashMap<String, Boolean>();
		metrosLinealesFachadaPrincipal.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("metroslinealesfachadaprincipal", metrosLinealesFachadaPrincipal);

		// altura
		HashMap<String, Boolean> altura = new HashMap<String, Boolean>();
		altura.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("altura", altura);

		// numeroPlazasGaraje
		HashMap<String, Boolean> numeroPlazasGaraje = new HashMap<String, Boolean>();
		numeroPlazasGaraje.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numeroplazasgaraje", numeroPlazasGaraje);

		// superficiePlazasGaraje
		HashMap<String, Boolean> superficiePlazasGaraje = new HashMap<String, Boolean>();
		superficiePlazasGaraje.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("superficieplazasgaraje", superficiePlazasGaraje);

		// codSubtipoPlazasGaraje
		HashMap<String, Boolean> codSubtipoPlazasGaraje = new HashMap<String, Boolean>();
		codSubtipoPlazasGaraje.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("codsubtipoplazasgaraje", codSubtipoPlazasGaraje);

		// salidaHumosOtrasCaracteristicas
		HashMap<String, Boolean> salidaHumosOtrasCaracteristicas = new HashMap<String, Boolean>();
		salidaHumosOtrasCaracteristicas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("salidahumosotrascaracteristicas", salidaHumosOtrasCaracteristicas);

		// salidaEmergenciaOtrasCaracteristicas
		HashMap<String, Boolean> salidaEmergenciaOtrasCaracteristicas = new HashMap<String, Boolean>();
		salidaEmergenciaOtrasCaracteristicas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("salidaemergenciaotrascaracteristicas", salidaEmergenciaOtrasCaracteristicas);

		// accesoMinusvalidosOtrasCaracteristicas
		HashMap<String, Boolean> accesoMinusvalidosOtrasCaracteristicas = new HashMap<String, Boolean>();
		accesoMinusvalidosOtrasCaracteristicas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("accesominusvalidosotrascaracteristicas", accesoMinusvalidosOtrasCaracteristicas);

		// otrosOtrasCaracteristicas
		HashMap<String, Boolean> otrosOtrasCaracteristicas = new HashMap<String, Boolean>();
		otrosOtrasCaracteristicas.put(DDTipoActivo.COD_COMERCIAL, true);
		otrosOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("otrosotrascaracteristicas", otrosOtrasCaracteristicas);

		// codTipoVario
		HashMap<String, Boolean> codTipoVario = new HashMap<String, Boolean>();
		codTipoVario.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("codtipovario", codTipoVario);

		// ancho
		HashMap<String, Boolean> ancho = new HashMap<String, Boolean>();
		ancho.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("ancho", ancho);

		// alto
		HashMap<String, Boolean> alto = new HashMap<String, Boolean>();
		alto.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("alto", alto);

		// largo
		HashMap<String, Boolean> largo = new HashMap<String, Boolean>();
		largo.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("largo", largo);

		// codUso
		HashMap<String, Boolean> codUso = new HashMap<String, Boolean>();
		codUso.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("codUso", codUso);

		// codManiobrabilidad
		HashMap<String, Boolean> codManiobrabilidad = new HashMap<String, Boolean>();
		codManiobrabilidad.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("codmaniobrabilidad", codManiobrabilidad);

		// licenciaOtrasCaracteristicas
		HashMap<String, Boolean> licenciaOtrasCaracteristicas = new HashMap<String, Boolean>();
		licenciaOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("licenciaotrascaracteristicas", licenciaOtrasCaracteristicas);

		// servidumbreOtrasCaracteristicas
		HashMap<String, Boolean> servidumbreOtrasCaracteristicas = new HashMap<String, Boolean>();
		servidumbreOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("servidumbreotrascaracteristicas", servidumbreOtrasCaracteristicas);

		// ascensorOMontacargasOtrasCaracteristicas
		HashMap<String, Boolean> ascensorOMontacargasOtrasCaracteristicas = new HashMap<String, Boolean>();
		ascensorOMontacargasOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("ascensoromontacargasotrascaracteristicas", ascensorOMontacargasOtrasCaracteristicas);

		// columnasOtrasCaracteristicas
		HashMap<String, Boolean> columnasOtrasCaracteristicas = new HashMap<String, Boolean>();
		columnasOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("columnasotrascaracteristicas", columnasOtrasCaracteristicas);

		// seguridadOtrasCaracteristicas
		HashMap<String, Boolean> seguridadOtrasCaracteristicas = new HashMap<String, Boolean>();
		seguridadOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("seguridadotrascaracteristicas", seguridadOtrasCaracteristicas);

		// buenEstadoInstalacionElectricidadInstalaciones
		HashMap<String, Boolean> buenEstadoInstalacionElectricidadInstalaciones = new HashMap<String, Boolean>();
		buenEstadoInstalacionElectricidadInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadoinstalacionelectricidadinstalaciones",
				buenEstadoInstalacionElectricidadInstalaciones);

		// buenEstadoContadorElectricidadInstalaciones
		HashMap<String, Boolean> buenEstadoContadorElectricidadInstalaciones = new HashMap<String, Boolean>();
		buenEstadoContadorElectricidadInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadocontadorelectricidadinstalaciones", buenEstadoContadorElectricidadInstalaciones);

		// buenEstadoInstalacionAguaInstalaciones
		HashMap<String, Boolean> buenEstadoInstalacionAguaInstalaciones = new HashMap<String, Boolean>();
		buenEstadoInstalacionAguaInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadoinstalacionaguainstalaciones", buenEstadoInstalacionAguaInstalaciones);

		// buenEstadoContadorAguaInstalaciones
		HashMap<String, Boolean> buenEstadoContadorAguaInstalaciones = new HashMap<String, Boolean>();
		buenEstadoContadorAguaInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadocontadoraguainstalaciones", buenEstadoContadorAguaInstalaciones);

		// buenEstadoGasInstalaciones
		HashMap<String, Boolean> buenEstadoGasInstalaciones = new HashMap<String, Boolean>();
		buenEstadoGasInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadogasinstalaciones", buenEstadoGasInstalaciones);

		// buenEstadoContadorGasInstalacion
		HashMap<String, Boolean> buenEstadoContadorGasInstalacion = new HashMap<String, Boolean>();
		buenEstadoContadorGasInstalacion.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadocontadorgasinstalacion", buenEstadoContadorGasInstalacion);

		// buenEstadoConservacionEdificio
		HashMap<String, Boolean> buenEstadoConservacionEdificio = new HashMap<String, Boolean>();
		buenEstadoConservacionEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		buenEstadoConservacionEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		buenEstadoConservacionEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadoconservacionedificio", buenEstadoConservacionEdificio);

		// anyoRehabilitacionEdificio
		HashMap<String, Boolean> anyoRehabilitacionEdificio = new HashMap<String, Boolean>();
		anyoRehabilitacionEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		anyoRehabilitacionEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		anyoRehabilitacionEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("anyorehabilitacionedificio", anyoRehabilitacionEdificio);

		// numeroPlantasEdificio
		HashMap<String, Boolean> numeroPlantasEdificio = new HashMap<String, Boolean>();
		numeroPlantasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		numeroPlantasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		numeroPlantasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("numeroplantasedificio", numeroPlantasEdificio);

		// numeroAscensoresEdificio
		HashMap<String, Boolean> numeroAscensoresEdificio = new HashMap<String, Boolean>();
		numeroAscensoresEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		numeroAscensoresEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		numeroAscensoresEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("numeroascensoresedificio", numeroAscensoresEdificio);

		// existeComunidadEdificio
		HashMap<String, Boolean> existeComunidadEdificio = new HashMap<String, Boolean>();
		existeComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		existeComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		existeComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("existecomunidadedificio", existeComunidadEdificio);

		// cuotaComunidadEdificio
		HashMap<String, Boolean> cuotaComunidadEdificio = new HashMap<String, Boolean>();
		cuotaComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		cuotaComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		cuotaComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("cuotacomunidadedificio", cuotaComunidadEdificio);

		// nombrePresidenteComunidadEdificio
		HashMap<String, Boolean> nombrePresidenteComunidadEdificio = new HashMap<String, Boolean>();
		nombrePresidenteComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		nombrePresidenteComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		nombrePresidenteComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("nombrepresidentecomunidadedificio", nombrePresidenteComunidadEdificio);

		// telefonoPresidenteComunidadEdificio
		HashMap<String, Boolean> telefonoPresidenteComunidadEdificio = new HashMap<String, Boolean>();
		telefonoPresidenteComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		telefonoPresidenteComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		telefonoPresidenteComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("telefonopresidentecomunidadedificio", telefonoPresidenteComunidadEdificio);

		// nombreAdministradorComunidadEdificio
		HashMap<String, Boolean> nombreAdministradorComunidadEdificio = new HashMap<String, Boolean>();
		nombreAdministradorComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		nombreAdministradorComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		nombreAdministradorComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("nombreadministradorcomunidadedificio", nombreAdministradorComunidadEdificio);

		// telefonoAdministradorComunidadEdificio
		HashMap<String, Boolean> telefonoAdministradorComunidadEdificio = new HashMap<String, Boolean>();
		telefonoAdministradorComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		telefonoAdministradorComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		telefonoAdministradorComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("telefonoadministradorcomunidadedificio", telefonoAdministradorComunidadEdificio);

		// descripcionDerramaComunidadEdificio
		HashMap<String, Boolean> descripcionDerramaComunidadEdificio = new HashMap<String, Boolean>();
		descripcionDerramaComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		descripcionDerramaComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		descripcionDerramaComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("descripcionderramacomunidadedificio", descripcionDerramaComunidadEdificio);

		// ascensorReformasNecesariasEdificio
		HashMap<String, Boolean> ascensorReformasNecesariasEdificio = new HashMap<String, Boolean>();
		ascensorReformasNecesariasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		ascensorReformasNecesariasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		ascensorReformasNecesariasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("ascensorreformasnecesariasedificio", ascensorReformasNecesariasEdificio);

		// cubiertaReformasNecesariasEdificio
		HashMap<String, Boolean> cubiertaReformasNecesariasEdificio = new HashMap<String, Boolean>();
		cubiertaReformasNecesariasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		cubiertaReformasNecesariasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		cubiertaReformasNecesariasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("cubiertareformasnecesariasedificio", cubiertaReformasNecesariasEdificio);

		// otrasZonasComunesReformasNecesariasEdificio
		HashMap<String, Boolean> otrasZonasComunesReformasNecesariasEdificio = new HashMap<String, Boolean>();
		otrasZonasComunesReformasNecesariasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		otrasZonasComunesReformasNecesariasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		otrasZonasComunesReformasNecesariasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("otraszonascomunesreformasnecesariasedificio", otrasZonasComunesReformasNecesariasEdificio);

		// otrosReformasNecesariasEdificio
		HashMap<String, Boolean> otrosReformasNecesariasEdificio = new HashMap<String, Boolean>();
		otrosReformasNecesariasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		otrosReformasNecesariasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		otrosReformasNecesariasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("otrosreformasnecesariasedificio", otrosReformasNecesariasEdificio);

		// infraestructurasEntornoEdificio
		HashMap<String, Boolean> infraestructurasEntornoEdificio = new HashMap<String, Boolean>();
		infraestructurasEntornoEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		infraestructurasEntornoEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		infraestructurasEntornoEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("infraestructurasentornoedificio", infraestructurasEntornoEdificio);

		// comunicacionesEntornoEdificio
		HashMap<String, Boolean> comunicacionesEntornoEdificio = new HashMap<String, Boolean>();
		comunicacionesEntornoEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		comunicacionesEntornoEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		comunicacionesEntornoEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("comunicacionesentornoedificio", comunicacionesEntornoEdificio);

		// existeOcio
		HashMap<String, Boolean> existeOcio = new HashMap<String, Boolean>();
		existeOcio.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existeocio", existeOcio);

		// existenHoteles
		HashMap<String, Boolean> existenHoteles = new HashMap<String, Boolean>();
		existenHoteles.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenhoteles", existenHoteles);

		// hoteles
		HashMap<String, Boolean> hoteles = new HashMap<String, Boolean>();
		hoteles.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("hoteles", hoteles);

		// existenTeatros
		HashMap<String, Boolean> existenTeatros = new HashMap<String, Boolean>();
		existenTeatros.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenteatros", existenTeatros);

		// teatros
		HashMap<String, Boolean> teatros = new HashMap<String, Boolean>();
		teatros.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("teatros", teatros);

		// existenSalasDeCine
		HashMap<String, Boolean> existenSalasDeCine = new HashMap<String, Boolean>();
		existenSalasDeCine.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existensalasdecine", existenSalasDeCine);

		// salasDeCine
		HashMap<String, Boolean> salasDeCine = new HashMap<String, Boolean>();
		salasDeCine.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("salasdecine", salasDeCine);

		// existenInstalacionesDeportivas
		HashMap<String, Boolean> existenInstalacionesDeportivas = new HashMap<String, Boolean>();
		existenInstalacionesDeportivas.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existeninstalacionesdeportivas", existenInstalacionesDeportivas);

		// instalacionesDeportivas
		HashMap<String, Boolean> instalacionesDeportivas = new HashMap<String, Boolean>();
		instalacionesDeportivas.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("instalacionesdeportivas", instalacionesDeportivas);

		// existenCentrosComerciales
		HashMap<String, Boolean> existenCentrosComerciales = new HashMap<String, Boolean>();
		existenCentrosComerciales.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existencentroscomerciales", existenCentrosComerciales);

		// centrosComerciales
		HashMap<String, Boolean> centrosComerciales = new HashMap<String, Boolean>();
		centrosComerciales.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("centroscomerciales", centrosComerciales);

		// otrosOcio
		HashMap<String, Boolean> otrosOcio = new HashMap<String, Boolean>();
		otrosOcio.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otrosocio", otrosOcio);

		// existenCentrosEducativos
		HashMap<String, Boolean> existenCentrosEducativos = new HashMap<String, Boolean>();
		existenCentrosEducativos.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existencentroseducativos", existenCentrosEducativos);

		// existenEscuelasInfantiles
		HashMap<String, Boolean> existenEscuelasInfantiles = new HashMap<String, Boolean>();
		existenEscuelasInfantiles.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenEscuelasInfantiles", existenEscuelasInfantiles);

		// escuelasInfantiles
		HashMap<String, Boolean> escuelasInfantiles = new HashMap<String, Boolean>();
		escuelasInfantiles.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("escuelasinfantiles", escuelasInfantiles);

		// existenColegios
		HashMap<String, Boolean> existenColegios = new HashMap<String, Boolean>();
		existenColegios.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existencolegios", existenColegios);

		// colegios
		HashMap<String, Boolean> colegios = new HashMap<String, Boolean>();
		colegios.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("colegios", colegios);

		// existenInstitutos
		HashMap<String, Boolean> existenInstitutos = new HashMap<String, Boolean>();
		existenInstitutos.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existeninstitutos", existenInstitutos);

		// institutos
		HashMap<String, Boolean> institutos = new HashMap<String, Boolean>();
		institutos.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("institutos", institutos);

		// existenUniversidades
		HashMap<String, Boolean> existenUniversidades = new HashMap<String, Boolean>();
		existenUniversidades.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenuniversidades", existenUniversidades);

		// universidades
		HashMap<String, Boolean> universidades = new HashMap<String, Boolean>();
		universidades.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("universidades", universidades);

		// otrosCentrosEducativos
		HashMap<String, Boolean> otrosCentrosEducativos = new HashMap<String, Boolean>();
		otrosCentrosEducativos.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otroscentroseducativos", otrosCentrosEducativos);

		// existenCentrosSanitarios
		HashMap<String, Boolean> existenCentrosSanitarios = new HashMap<String, Boolean>();
		existenCentrosSanitarios.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existencentrossanitarios", existenCentrosSanitarios);

		// existenCentrosDeSalud
		HashMap<String, Boolean> existenCentrosDeSalud = new HashMap<String, Boolean>();
		existenCentrosDeSalud.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existencentrosdesalud", existenCentrosDeSalud);

		// centrosDeSalud
		HashMap<String, Boolean> centrosDeSalud = new HashMap<String, Boolean>();
		centrosDeSalud.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("centrosdesalud", centrosDeSalud);

		// existenClinicas
		HashMap<String, Boolean> existenClinicas = new HashMap<String, Boolean>();
		existenClinicas.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenClinicas", existenClinicas);

		// clinicas
		HashMap<String, Boolean> clinicas = new HashMap<String, Boolean>();
		clinicas.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("clinicas", clinicas);

		// existenHospitales
		HashMap<String, Boolean> existenHospitales = new HashMap<String, Boolean>();
		existenHospitales.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenhospitales", existenHospitales);

		// hospitales
		HashMap<String, Boolean> hospitales = new HashMap<String, Boolean>();
		hospitales.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("hospitales", hospitales);

		// existenOtrosCentrosSanitarios
		HashMap<String, Boolean> existenOtrosCentrosSanitarios = new HashMap<String, Boolean>();
		existenOtrosCentrosSanitarios.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenotroscentrossanitarios", existenOtrosCentrosSanitarios);

		// otrosCentrosSanitarios
		HashMap<String, Boolean> otrosCentrosSanitarios = new HashMap<String, Boolean>();
		otrosCentrosSanitarios.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otroscentrossanitarios", otrosCentrosSanitarios);

		// codTipoAparcamientoEnSuperficie
		HashMap<String, Boolean> codTipoAparcamientoEnSuperficie = new HashMap<String, Boolean>();
		codTipoAparcamientoEnSuperficie.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("codtipoaparcamientoensuperficie", codTipoAparcamientoEnSuperficie);

		// existenComunicaciones
		HashMap<String, Boolean> existenComunicaciones = new HashMap<String, Boolean>();
		existenComunicaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existencomunicaciones", existenComunicaciones);

		// existeFacilAccesoPorCarretera
		HashMap<String, Boolean> existeFacilAccesoPorCarretera = new HashMap<String, Boolean>();
		existeFacilAccesoPorCarretera.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existefacilaccesoporcarretera", existeFacilAccesoPorCarretera);

		// facilAccesoPorCarretera
		HashMap<String, Boolean> facilAccesoPorCarretera = new HashMap<String, Boolean>();
		facilAccesoPorCarretera.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("facilaccesoporcarretera", facilAccesoPorCarretera);

		// existeLineasDeAutobus
		HashMap<String, Boolean> existeLineasDeAutobus = new HashMap<String, Boolean>();
		existeLineasDeAutobus.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existelineasdeautobus", existeLineasDeAutobus);

		// lineasDeAutobus
		HashMap<String, Boolean> lineasDeAutobus = new HashMap<String, Boolean>();
		lineasDeAutobus.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("lineasdeautobus", lineasDeAutobus);

		// existeMetro
		HashMap<String, Boolean> existeMetro = new HashMap<String, Boolean>();
		existeMetro.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existemetro", existeMetro);

		// metro
		HashMap<String, Boolean> metro = new HashMap<String, Boolean>();
		metro.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("metro", metro);

		// existeEstacionesDeTren
		HashMap<String, Boolean> existeEstacionesDeTren = new HashMap<String, Boolean>();
		existeEstacionesDeTren.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existeestacionesdetren", existeEstacionesDeTren);

		// estacionesDeTren
		HashMap<String, Boolean> estacionesDeTren = new HashMap<String, Boolean>();
		estacionesDeTren.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("estacionesdetren", estacionesDeTren);

		// otrosComunicaciones
		HashMap<String, Boolean> otrosComunicaciones = new HashMap<String, Boolean>();
		otrosComunicaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otroscomunicaciones", otrosComunicaciones);

		// buenEstadoPuertaEntradaNormal
		HashMap<String, Boolean> buenEstadoPuertaEntradaNormal = new HashMap<String, Boolean>();
		buenEstadoPuertaEntradaNormal.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopuertaentradanormal", buenEstadoPuertaEntradaNormal);

		// buenEstadoPuertaEntradaBlindada
		HashMap<String, Boolean> buenEstadoPuertaEntradaBlindada = new HashMap<String, Boolean>();
		buenEstadoPuertaEntradaBlindada.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopuertaentradablindada", buenEstadoPuertaEntradaBlindada);

		// buenEstadoPuertaEntradaAcorazada
		HashMap<String, Boolean> buenEstadoPuertaEntradaAcorazada = new HashMap<String, Boolean>();
		buenEstadoPuertaEntradaAcorazada.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopuertaentradaacorazada", buenEstadoPuertaEntradaAcorazada);

		// buenEstadoPuertaPasoMaciza
		HashMap<String, Boolean> buenEstadoPuertaPasoMaciza = new HashMap<String, Boolean>();
		buenEstadoPuertaPasoMaciza.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopuertapasomaciza", buenEstadoPuertaPasoMaciza);

		// buenEstadoPuertaPasoHueca
		HashMap<String, Boolean> buenEstadoPuertaPasoHueca = new HashMap<String, Boolean>();
		buenEstadoPuertaPasoHueca.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopuertapasohueca", buenEstadoPuertaPasoHueca);

		// buenEstadoPuertaPasoLacada
		HashMap<String, Boolean> buenEstadoPuertaPasoLacada = new HashMap<String, Boolean>();
		buenEstadoPuertaPasoLacada.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopuertapasolacada", buenEstadoPuertaPasoLacada);

		// existenArmariosEmpotrados
		HashMap<String, Boolean> existenArmariosEmpotrados = new HashMap<String, Boolean>();
		existenArmariosEmpotrados.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenarmariosempotrados", existenArmariosEmpotrados);

		// codAcabadoCarpinteria
		HashMap<String, Boolean> codAcabadoCarpinteria = new HashMap<String, Boolean>();
		codAcabadoCarpinteria.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("codacabadocarpinteria", codAcabadoCarpinteria);

		// otrosCarpinteriaInterior
		HashMap<String, Boolean> otrosCarpinteriaInterior = new HashMap<String, Boolean>();
		otrosCarpinteriaInterior.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otroscarpinteriainterior", otrosCarpinteriaInterior);

		// buenEstadoVentanaHierro
		HashMap<String, Boolean> buenEstadoVentanaHierro = new HashMap<String, Boolean>();
		buenEstadoVentanaHierro.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadoventanahierro", buenEstadoVentanaHierro);

		// buenEstadoVentanaAnodizado
		HashMap<String, Boolean> buenEstadoVentanaAnodizado = new HashMap<String, Boolean>();
		buenEstadoVentanaAnodizado.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadoventanaanodizado", buenEstadoVentanaAnodizado);

		// buenEstadoVentanaLacado
		HashMap<String, Boolean> buenEstadoVentanaLacado = new HashMap<String, Boolean>();
		buenEstadoVentanaLacado.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadoventanalacado", buenEstadoVentanaLacado);

		// buenEstadoVentanaPvc
		HashMap<String, Boolean> buenEstadoVentanaPvc = new HashMap<String, Boolean>();
		buenEstadoVentanaPvc.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadoventanapvc", buenEstadoVentanaPvc);

		// buenEstadoVentanaMadera
		HashMap<String, Boolean> buenEstadoVentanaMadera = new HashMap<String, Boolean>();
		buenEstadoVentanaMadera.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadoventanamadera", buenEstadoVentanaMadera);

		// buenEstadoPersianaPlastico
		HashMap<String, Boolean> buenEstadoPersianaPlastico = new HashMap<String, Boolean>();
		buenEstadoPersianaPlastico.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopersianaplastico", buenEstadoPersianaPlastico);

		// buenEstadoPersianaAluminio
		HashMap<String, Boolean> buenEstadoPersianaAluminio = new HashMap<String, Boolean>();
		buenEstadoPersianaAluminio.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopersianaaluminio", buenEstadoPersianaAluminio);

		// buenEstadoAperturaVentanaCorrederas
		HashMap<String, Boolean> buenEstadoAperturaVentanaCorrederas = new HashMap<String, Boolean>();
		buenEstadoAperturaVentanaCorrederas.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadoaperturaventanacorrederas", buenEstadoAperturaVentanaCorrederas);

		// buenEstadoAperturaVentanaAbatibles
		HashMap<String, Boolean> buenEstadoAperturaVentanaAbatibles = new HashMap<String, Boolean>();
		buenEstadoAperturaVentanaAbatibles.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadoaperturaventanaabatibles", buenEstadoAperturaVentanaAbatibles);

		// buenEstadoAperturaVentanaOscilobat
		HashMap<String, Boolean> buenEstadoAperturaVentanaOscilobat = new HashMap<String, Boolean>();
		buenEstadoAperturaVentanaOscilobat.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadoaperturaventanaoscilobat", buenEstadoAperturaVentanaOscilobat);

		// buenEstadoDobleAcristalamientoOClimalit
		HashMap<String, Boolean> buenEstadoDobleAcristalamientoOClimalit = new HashMap<String, Boolean>();
		buenEstadoDobleAcristalamientoOClimalit.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadodobleacristalamientooclimalit", buenEstadoDobleAcristalamientoOClimalit);

		// otrosCarpinteriaExterior
		HashMap<String, Boolean> otrosCarpinteriaExterior = new HashMap<String, Boolean>();
		otrosCarpinteriaExterior.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otroscarpinteriaexterior", otrosCarpinteriaExterior);

		// humedadesPared
		HashMap<String, Boolean> humedadesPared = new HashMap<String, Boolean>();
		humedadesPared.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("humedadespared", humedadesPared);

		// humedadesTecho
		HashMap<String, Boolean> humedadesTecho = new HashMap<String, Boolean>();
		humedadesTecho.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("humedadestecho", humedadesTecho);

		// grietasPared
		HashMap<String, Boolean> grietasPared = new HashMap<String, Boolean>();
		grietasPared.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("grietaspared", grietasPared);

		// grietasTecho
		HashMap<String, Boolean> grietasTecho = new HashMap<String, Boolean>();
		grietasTecho.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("grietastecho", grietasTecho);

		// buenEstadoPinturaParedesGotele
		HashMap<String, Boolean> buenEstadoPinturaParedesGotele = new HashMap<String, Boolean>();
		buenEstadoPinturaParedesGotele.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopinturaparedesgotele", buenEstadoPinturaParedesGotele);

		// buenEstadoPinturaParedesLisa
		HashMap<String, Boolean> buenEstadoPinturaParedesLisa = new HashMap<String, Boolean>();
		buenEstadoPinturaParedesLisa.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopinturaparedeslisa", buenEstadoPinturaParedesLisa);

		// buenEstadoPinturaParedesPintado
		HashMap<String, Boolean> buenEstadoPinturaParedesPintado = new HashMap<String, Boolean>();
		buenEstadoPinturaParedesPintado.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopinturaparedespintado", buenEstadoPinturaParedesPintado);

		// buenEstadoPinturaTechoGotele
		HashMap<String, Boolean> buenEstadoPinturaTechoGotele = new HashMap<String, Boolean>();
		buenEstadoPinturaTechoGotele.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopinturatechogotele", buenEstadoPinturaTechoGotele);

		// buenEstadoPinturaTechoLisa
		HashMap<String, Boolean> buenEstadoPinturaTechoLisa = new HashMap<String, Boolean>();
		buenEstadoPinturaTechoLisa.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopinturatecholisa", buenEstadoPinturaTechoLisa);

		// buenEstadoPinturaTechoPintado
		HashMap<String, Boolean> buenEstadoPinturaTechoPintado = new HashMap<String, Boolean>();
		buenEstadoPinturaTechoPintado.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadopinturatechopintado", buenEstadoPinturaTechoPintado);

		// buenEstadoMolduraEscayola
		HashMap<String, Boolean> buenEstadoMolduraEscayola = new HashMap<String, Boolean>();
		buenEstadoMolduraEscayola.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("buenestadomolduraescayola", buenEstadoMolduraEscayola);

		// otrosParamentosVerticales
		addObligatorioVivienda("otrosParamentosVerticales");

		// buenEstadoTarimaFlotanteSolados
		addObligatorioVivienda("buenEstadoTarimaFlotanteSolados");

		// buenEstadoParqueSolados
		addObligatorioVivienda("buenEstadoParqueSolados");

		// buenEstadoMarmolSolados
		addObligatorioVivienda("buenEstadoMarmolSolados");

		// buenEstadoPlaquetaSolados
		addObligatorioVivienda("buenEstadoPlaquetaSolados");

		// otrosSolados
		addObligatorioVivienda("otrosSolados");

		// buenEstadoCocinaAmuebladaCocina
		addObligatorioVivienda("buenEstadoCocinaAmuebladaCocina");

		// buenEstadoEncimeraGranitoCocina
		addObligatorioVivienda("buenEstadoEncimeraGranitoCocina");

		// buenEstadoEncimeraMarmolCocina
		addObligatorioVivienda("buenEstadoEncimeraMarmolCocina");

		// buenEstadoEncimeraMaterialCocina
		addObligatorioVivienda("buenEstadoEncimeraMaterialCocina");

		// buenEstadoVitroceramicaCocina
		addObligatorioVivienda("buenEstadoVitroceramicaCocina");

		// buenEstadoLavadoraCocina
		addObligatorioVivienda("buenEstadoLavadoraCocina");

		// buenEstadoFrigorificoCocina
		addObligatorioVivienda("buenEstadoFrigorificoCocina");

		// buenEstadoLavavajillasCocina
		addObligatorioVivienda("buenEstadoLavavajillasCocina");

		// buenEstadoMicroondasCocina
		addObligatorioVivienda("buenEstadoMicroondasCocina");

		// buenEstadoHornoCocina
		addObligatorioVivienda("buenEstadoHornoCocina");

		// buenEstadoSueloCocina
		addObligatorioVivienda("buenEstadoSueloCocina");

		// buenEstadoAzulejosCocina
		addObligatorioVivienda("buenEstadoAzulejosCocina");

		// buenEstadoSueloCocina
		addObligatorioVivienda("buenEstadoSueloCocina");

		// buenEstadoGriferiaMonomandoCocina
		addObligatorioVivienda("buenEstadoGriferiaMonomandoCocina");

		// otrosCocina
		addObligatorioVivienda("otrosCocina");

		// buenEstadoDuchaBanyo
		addObligatorioVivienda("buenEstadoDuchaBanyo");

		// buenEstadoBanyeraNormalBanyo
		addObligatorioVivienda("buenEstadoBanyeraNormalBanyo");

		// buenEstadoBanyeraHidromasajeBanyo
		addObligatorioVivienda("buenEstadoBanyeraHidromasajeBanyo");

		// buenEstadoColumnaHidromasajeBanyo
		addObligatorioVivienda("buenEstadoColumnaHidromasajeBanyo");

		// buenEstadoAlicatadoMarmolBanyo
		addObligatorioVivienda("buenEstadoAlicatadoMarmolBanyo");

		// buenEstadoAlicatadoGranitoBanyo
		addObligatorioVivienda("buenEstadoAlicatadoGranitoBanyo");

		// buenEstadoAlicatadoAzulejoBanyo
		addObligatorioVivienda("buenEstadoAlicatadoAzulejoBanyo");

		// buenEstadoEncimeraMarmolBanyo
		addObligatorioVivienda("buenEstadoEncimeraMarmolBanyo");

		// buenEstadoEncimeraGranitoBanyo
		addObligatorioVivienda("buenEstadoEncimeraGranitoBanyo");

		// buenEstadoEncimeraMaterialBanyo
		addObligatorioVivienda("buenEstadoEncimeraMaterialBanyo");

		// buenEstadoSanitariosBanyo
		addObligatorioVivienda("buenEstadoSanitariosBanyo");

		// buenEstadoSueloBanyo
		addObligatorioVivienda("buenEstadoSueloBanyo");

		// buenEstadoGriferiaMonomandoBanyo
		addObligatorioVivienda("buenEstadoGriferiaMonomandoBanyo");

		// otrosBanyo
		addObligatorioVivienda("otrosBanyo");

		// buenEstadoInstalacionElectrica
		addObligatorioVivienda("buenEstadoInstalacionElectrica");

		// instalacionElectricaAntiguaODefectuosa
		addObligatorioVivienda("instalacionElectricaAntiguaODefectuosa");

		// existeCalefaccionGasNatural
		addObligatorioVivienda("existeCalefaccionGasNatural");

		// existenRadiadoresDeAluminio
		addObligatorioVivienda("existenRadiadoresDeAluminio");

		// existeAguaCalienteCentral
		addObligatorioVivienda("existeAguaCalienteCentral");

		// existeAguaCalienteGasNatural
		addObligatorioVivienda("existeAguaCalienteGasNatural");

		// existeAireAcondicionadoPreinstalacion
		addObligatorioVivienda("existeAireAcondicionadoPreinstalacion");

		// existeAireAcondicionadoInstalacion
		addObligatorioVivienda("existeAireAcondicionadoInstalacion");

		// existeAireAcondicionadoCalor
		addObligatorioVivienda("existeAireAcondicionadoCalor");

		// otrosInstalaciones
		addObligatorioVivienda("otrosInstalaciones");

		// existenJardinesZonasVerdes
		addObligatorioVivienda("existenJardinesZonasVerdes");

		// existePiscina
		addObligatorioVivienda("existePiscina");

		// existePistaPadel
		addObligatorioVivienda("existePistaPadel");

		// existePistaTenis
		addObligatorioVivienda("existePistaTenis");

	}

	private void addObligatorioVivienda(String name) {
		HashMap<String, Boolean> aux = new HashMap<String, Boolean>();
		aux.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put(name.toLowerCase(), aux);
	}

	@Override
	public void validateInformeField(HashMap<String, String> errorsList, String fiedlName, Object fieldValor,
			String codigoTipoBien) throws Exception {
		fiedlName = fiedlName.substring(3);
		HashMap<String, Boolean> permisos = obligatorios.get(fiedlName.toLowerCase());
		if (permisos != null) {
			if (permisos.containsKey(codigoTipoBien)
					&& (fieldValor == null || (fieldValor instanceof String && ((String) fieldValor).isEmpty()))) {
				if (fiedlName.length() > 2) {
					fiedlName = fiedlName.substring(0, 1).toLowerCase().concat(fiedlName.substring(1));
				}
				errorsList.put(fiedlName, RestApi.REST_MSG_MISSING_REQUIRED);
			}
		}
	}

	@Override
	public void validateInformeMediadorDto(InformeMediadorDto informe, String codigoTipoBien,
			HashMap<String, String> errorsList) throws Exception {
		for (PropertyDescriptor propertyDescriptor : Introspector.getBeanInfo(InformeMediadorDto.class)
				.getPropertyDescriptors()) {
			if (propertyDescriptor.getReadMethod() != null) {
				Object obj = propertyDescriptor.getReadMethod().invoke(informe);
				this.validateInformeField(errorsList, propertyDescriptor.getReadMethod().getName(), obj,
						codigoTipoBien);
			}

		}

	}

	@Override
	public boolean existeInformemediadorActivo(Long numActivo) throws Exception {
		Activo activo;
		Serializable objetoEntity = null;
		boolean resultado = false;

		if (numActivo != null) {
			activo = (Activo) genericDao.get(Activo.class,
					genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo));
			if (activo != null) {
				objetoEntity = (ActivoInfoComercial) genericDao.get(ActivoInfoComercial.class,
						genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", numActivo));
			}

		}
		if (objetoEntity != null) {
			resultado = true;
		}
		return resultado;

	}

	/**
	 * Cuando cambias el tipo de activo, si pasa de una tabla especifica a otra
	 * falla()claves duplicadas. Borramos el registro en la tabla general
	 * 
	 * @param objeto
	 * @param informe
	 * @throws Exception
	 */
	private void parcheEspecificacionTablas(InformeMediadorDto informe) throws Exception {
		genericaRestDaoImp.deleteInformeMediador(informe);
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdateInformeMediador(List<InformeMediadorDto> informes,
			JSONObject jsonFields) throws Exception {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = null;

		int i = 0;
		for (InformeMediadorDto informe : informes) {
			// proveedor de confianza, puede editar el informe, sin tramite de
			// aceptacion
			boolean autorizacionWebProveedor = false;
			Long idProveedorParche = null;
			ActivoInfoComercial informeEntity = (ActivoInfoComercial) dtoToEntity.obtenerObjetoEntity(
					informe.getIdActivoHaya(), ActivoInfoComercial.class, "activo.numActivo");	
			
			parcheEspecificacionTablas(informe);
			
			map = new HashMap<String, Object>();
			HashMap<String, String> errorsList = null;
			if (this.existeInformemediadorActivo(informe.getIdActivoHaya())) {
				errorsList = restApi.validateRequestObject(informe, TIPO_VALIDACION.UPDATE);
			} else {
				errorsList = restApi.validateRequestObject(informe, TIPO_VALIDACION.INSERT);
			}
			Activo activo = activoApi.getByNumActivo(informe.getIdActivoHaya());
			if (!Checks.esNulo(informe.getPlantas()) && !Checks.estaVacio(informe.getPlantas())) {
				for (PlantaDto planta : informe.getPlantas()) {
					HashMap<String, String> errorsListPlanta = null;
					if (this.existeInformemediadorActivo(informe.getIdActivoHaya())) {
						errorsListPlanta = restApi.validateRequestObject(planta, TIPO_VALIDACION.UPDATE);
					} else {
						errorsListPlanta = restApi.validateRequestObject(planta, TIPO_VALIDACION.INSERT);
					}
					errorsList.putAll(errorsListPlanta);
				}
			}

			// validamos que no existan plantas repetidas
			if (!Checks.esNulo(informe.getPlantas()) && !Checks.estaVacio(informe.getPlantas())) {
				for (PlantaDto planta : informe.getPlantas()) {
					if (planta.getNumero() != null && planta.getCodTipoEstancia() != null) {
						int contOcurrencias = 0;
						for (PlantaDto plantaAux : informe.getPlantas()) {
							if (plantaAux.getNumero() != null && plantaAux.getCodTipoEstancia() != null
									&& plantaAux.getNumero().equals(planta.getNumero())
									&& plantaAux.getCodTipoEstancia().equals(planta.getCodTipoEstancia())) {
								contOcurrencias++;
							}
						}
						if (contOcurrencias > 1) {
							errorsList.put("plantas", RestApi.REST_UNIQUE_VIOLATED);
						}
					}
				}
			}

			if (informe.getFechaRecepcionLlavesApi() != null) {

				if (informe.getFechaRecepcionLlavesApi().compareTo(new Date()) > 0) {

					errorsList.put("fechaRecepcionLlavesApi", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}

			if (informe.getIdProveedorRem() != null) {
				ActivoProveedor mediador = genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", informe.getIdProveedorRem()));
				if (!Checks.esNulo(mediador)
					&& mediador.getAutorizacionWeb() != null
					&& mediador.getAutorizacionWeb().equals(Integer.valueOf(1))) {
						autorizacionWebProveedor = true;
				}
			}
			
			if (errorsList.size() == 0) {
				boolean tieneInformeComercialAceptado = false;
				tieneInformeComercialAceptado = activoApi.isInformeComercialAceptado(activo);
				HistoricoFasePublicacionActivo histFasePublicacionActivo = historicoFasePublicacionActivoDao
						.getHistoricoFasesPublicacionActivoActualById(activo.getId());
				if (histFasePublicacionActivo != null
						&& DDFasePublicacion.CODIGO_FASE_III_PENDIENTE_INFORMACION
								.equals(histFasePublicacionActivo.getFasePublicacion().getCodigo())
						&& (histFasePublicacionActivo.getSubFasePublicacion() != null
								&& (DDSubfasePublicacion.CODIGO_DEVUELTO
										.equals(histFasePublicacionActivo.getSubFasePublicacion().getCodigo())
										|| DDSubfasePublicacion.CODIGO_PENDIENTE_DE_INFORMACION.equals(
												histFasePublicacionActivo.getSubFasePublicacion().getCodigo())))) {
					if (!tieneInformeComercialAceptado || autorizacionWebProveedor) {
						histFasePublicacionActivo.setFechaFin(new Date());
						genericDao.save(HistoricoFasePublicacionActivo.class, histFasePublicacionActivo);					
						
						//nueva fase en estado clasificado
						HistoricoFasePublicacionActivo nuevaFase = new HistoricoFasePublicacionActivo();
						nuevaFase.setActivo(activo);
						nuevaFase.setUsuario(usuarioManager.getByUsername(REST_USER_USERNAME));
						nuevaFase.setFasePublicacion(histFasePublicacionActivo.getFasePublicacion());
						nuevaFase.setSubFasePublicacion(genericDao.get(DDSubfasePublicacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSubfasePublicacion.CODIGO_CLASIFICADO)));
						nuevaFase.setFechaInicio(new Date());
						
						genericDao.save(HistoricoFasePublicacionActivo.class, nuevaFase);					
					
						ArrayList<Serializable> entitys = new ArrayList<Serializable>();
						
						if (informeEntity.getActivo() == null) {
							informeEntity.setActivo(activo);
						}

						if (!Checks.esNulo(informe.getIdProveedorRem())) {
							idProveedorParche = informe.getIdProveedorRem();
							Filter filterPve = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", idProveedorParche);
							ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filterPve);
							if (!Checks.esNulo(proveedor)) {
								informeEntity.setMediadorInforme(proveedor);
							}
						}
						
						//LOCAL COMERCIAL
						if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_COMERCIAL)) {
							ActivoLocalComercial informeEntityLocal = (ActivoLocalComercial) dtoToEntity.obtenerObjetoEntity(
									informe.getIdActivoHaya(), ActivoLocalComercial.class, "informeComercial.activo.numActivo");
							
							informeEntity.setTipoInfoComercial(genericDao.get(DDTipoInfoComercial.class, 
									genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoInfoComercial.COD_LOCAL_COMERCIAL)));
							
							informeEntityLocal.setMtsAlturaLibre(informe.getAltura());
							
							informeEntityLocal.setInformeComercial(informeEntity);
							entitys.add(informeEntity);
							entitys.add(informeEntityLocal);
							
						//NULL
						} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_EN_COSTRUCCION)
								|| informe.getCodTipoActivo().equals(DDTipoActivo.COD_INDUSTRIAL)
								|| informe.getCodTipoActivo().equals(DDTipoActivo.COD_SUELO)
								|| informe.getCodTipoActivo().equals(DDTipoActivo.COD_EDIFICIO_COMPLETO)) {							
							
							informeEntity.setTipoInfoComercial(null);
							
							entitys.add(informeEntity);
							
						//PLAZA APARCAMIENTO	
						} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_OTROS)) {							
							ActivoPlazaAparcamiento informeEntityPlazaAp = (ActivoPlazaAparcamiento) dtoToEntity.obtenerObjetoEntity(
									informe.getIdActivoHaya(), ActivoPlazaAparcamiento.class, "informeComercial.activo.numActivo");
							
							informeEntity.setTipoInfoComercial(genericDao.get(DDTipoInfoComercial.class, 
									genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoInfoComercial.COD_PLAZA_APARCAMIENTO)));
							
							informeEntityPlazaAp.setAparcamientoAltura(informe.getAltura());
							
							informeEntityPlazaAp.setInformeComercial(informeEntity);
							entitys.add(informeEntity);
							entitys.add(informeEntityPlazaAp);
							
						//VIVIENDA	
						} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_VIVIENDA)) {
							ActivoVivienda informeEntityVivienda = (ActivoVivienda) dtoToEntity.obtenerObjetoEntity(
									informe.getIdActivoHaya(), ActivoVivienda.class, "informeComercial.activo.numActivo");
							
							informeEntity.setTipoInfoComercial(genericDao.get(DDTipoInfoComercial.class, 
									genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoInfoComercial.COD_VIVIENDA)));
							
							if (informe.getDistribucionInterior() != null) {
								informeEntityVivienda.setDistribucionTxt(informe.getDistribucionInterior());
							}
							
							ActivoInfraestructura activoInfraestructura = (ActivoInfraestructura) dtoToEntity
									.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoInfraestructura.class,
											"infoComercial.activo.numActivo");
							if(Checks.esNulo(activoInfraestructura.getInfoComercial())) {
								activoInfraestructura.setInfoComercial(informeEntity);
							}
							ActivoCarpinteriaInterior activoCarpinteriaInt = (ActivoCarpinteriaInterior) dtoToEntity
									.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoCarpinteriaInterior.class,
											"infoComercial.activo.numActivo");
							if(Checks.esNulo(activoCarpinteriaInt.getInfoComercial())) {
								activoCarpinteriaInt.setInfoComercial(informeEntity);
							}
							ActivoCarpinteriaExterior activoCarpinteriaExterior = (ActivoCarpinteriaExterior) dtoToEntity
									.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoCarpinteriaExterior.class,
											"infoComercial.activo.numActivo");
							if(Checks.esNulo(activoCarpinteriaExterior.getInfoComercial())) {
								activoCarpinteriaExterior.setInfoComercial(informeEntity);
							}
							ActivoParamentoVertical paramientoVertical = (ActivoParamentoVertical) dtoToEntity
									.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoParamentoVertical.class,
											"infoComercial.activo.numActivo");
							if(Checks.esNulo(activoInfraestructura.getInfoComercial())) {
								activoInfraestructura.setInfoComercial(informeEntity);
							}
							ActivoSolado solado = (ActivoSolado) dtoToEntity.obtenerObjetoEntity(
									informe.getIdActivoHaya(), ActivoSolado.class, "infoComercial.activo.numActivo");
							if(Checks.esNulo(solado.getInfoComercial())) {
								solado.setInfoComercial(informeEntity);
							}
							ActivoCocina cocina = (ActivoCocina) dtoToEntity.obtenerObjetoEntity(
									informe.getIdActivoHaya(), ActivoCocina.class, "infoComercial.activo.numActivo");
							if(Checks.esNulo(cocina.getInfoComercial())) {
								cocina.setInfoComercial(informeEntity);
							}
							ActivoBanyo banyo = (ActivoBanyo) dtoToEntity.obtenerObjetoEntity(informe.getIdActivoHaya(),
									ActivoBanyo.class, "infoComercial.activo.numActivo");
							if(Checks.esNulo(banyo.getInfoComercial())) {
								banyo.setInfoComercial(informeEntity);
							}
							ActivoInstalacion instalacion = (ActivoInstalacion) dtoToEntity.obtenerObjetoEntity(
									informe.getIdActivoHaya(), ActivoInstalacion.class,
									"infoComercial.activo.numActivo");
							if(Checks.esNulo(instalacion.getInfoComercial())) {
								instalacion.setInfoComercial(informeEntity);
							}
							ActivoZonaComun zonaComun = (ActivoZonaComun) dtoToEntity.obtenerObjetoEntity(
									informe.getIdActivoHaya(), ActivoZonaComun.class, "infoComercial.activo.numActivo");
							if(Checks.esNulo(zonaComun.getInfoComercial())) {
								zonaComun.setInfoComercial(informeEntity);
							}
							ActivoPropietarioActivo propActivo = (ActivoPropietarioActivo) dtoToEntity
									.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoPropietarioActivo.class,
											"activo.numActivo");						
							
							informeEntityVivienda.setInformeComercial(informeEntity);
							entitys.add(informeEntity);
							entitys.add(informeEntityVivienda);
							entitys.add(activoInfraestructura);
							entitys.add(activoCarpinteriaInt);
							entitys.add(activoCarpinteriaExterior);
							entitys.add(paramientoVertical);
							entitys.add(solado);
							entitys.add(cocina);
							entitys.add(banyo);
							entitys.add(instalacion);
							entitys.add(zonaComun);
							entitys.add(propActivo);
						}
						
						ActivoEdificio edificioEntity = null;
						if (informeEntity.getId() != null) {
							edificioEntity = (ActivoEdificio) dtoToEntity.obtenerObjetoEntity(informe.getIdActivoHaya(),
									ActivoEdificio.class, "infoComercial.activo.numActivo");
						} else {
							edificioEntity = new ActivoEdificio();
						}
						entitys.add(edificioEntity);
						
						informeEntity = (ActivoInfoComercial) dtoToEntity.saveDtoToBbdd(informe, entitys,
								(JSONObject) jsonFields.getJSONArray("data").get(i), idProveedorParche);
						// Si viene información de las plantas lo guardamos
						List<PlantaDto> plantas = informe.getPlantas();
						if (!Checks.esNulo(informe.getPlantas()) && !Checks.estaVacio(informe.getPlantas())) {

							if (!Checks.esNulo(informeEntity) && !Checks.esNulo(informeEntity.getId())) {
								Long idInfoComercial = informeEntity.getId();
								activoApi.deleteActivoDistribucion(idInfoComercial);
							}

							for (PlantaDto planta : plantas) {
								if (!Checks.esNulo(planta.getNumero()) || !Checks.esNulo(planta.getCodTipoEstancia())) {
									ActivoDistribucion activoDistribucion = new ActivoDistribucion();
									activoDistribucion.setNumPlanta(planta.getNumero());
									activoDistribucion.setInfoComercial(informeEntity);
									DDTipoHabitaculo tipoHabitaculo = null;
									if (planta.getCodTipoEstancia() != null && !planta.getCodTipoEstancia().isEmpty()) {
										tipoHabitaculo = genericDao.get(DDTipoHabitaculo.class, genericDao.createFilter(
												FilterType.EQUALS, "codigo", planta.getCodTipoEstancia()));
									}
									activoDistribucion.setTipoHabitaculo(tipoHabitaculo);
									activoDistribucion.setCantidad(planta.getNumeroEstancias());
									activoDistribucion.setSuperficie(planta.getEstancias());
									activoDistribucion.setDescripcion(planta.getDescripcionEstancias());
									genericDao.save(ActivoDistribucion.class, activoDistribucion);
								}

							}
						}
					}

					if (!tieneInformeComercialAceptado) {
						adapter.crearTramiteAprobacionInformeComercial(activo.getId());
					} else {
						ActivoEstadosInformeComercialHistorico activoEstadoInfComercialHistorico = new ActivoEstadosInformeComercialHistorico();
						activoEstadoInfComercialHistorico.setActivo(activo);
						Filter filtroDDInfComercial = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_MODIFICACION);
						DDEstadoInformeComercial ddInfComercial = genericDao.get(DDEstadoInformeComercial.class,
								filtroDDInfComercial);
						activoEstadoInfComercialHistorico.setEstadoInformeComercial(ddInfComercial);
						activoEstadoInfComercialHistorico.setFecha(new Date());
						if (autorizacionWebProveedor) {
							// se inserta una fila en el histórico de estados
							// del informe comercial de tipo 'Modificación',
							// 'Modificación del proveedor'
							activoEstadoInfComercialHistorico.setMotivo(
									DtoEstadosInformeComercialHistorico.ESTADO_MOTIVO_MODIFICACION_PROVEEDOR);
						} else {
							// se inserta una fila en el histórico de estados
							// del informe comercial de tipo 'Modificación',
							// 'Modificación rechazada. El proveedor no tiene
							// permisos para editar'
							activoEstadoInfComercialHistorico.setMotivo(
									DtoEstadosInformeComercialHistorico.ESTADO_MOTIVO_MODIFICACION_RECHAZADA);
						}
						genericDao.save(ActivoEstadosInformeComercialHistorico.class,
								activoEstadoInfComercialHistorico);

						map.put("informeComercial", RestApi.REST_INF_COM_APROBADO);
					}

					// Actualizamos la situacion comercial del activo
					updaterState.updaterStateDisponibilidadComercialAndSave(activo);

					activoAdapterApi.actualizarEstadoPublicacionActivo(activo.getId());

					// Actualizamos el rating si es un activo de tipo vivienda y tiene el informe
					// comercial aprobado
					if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo())
							&& DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())
							&& !Checks.esNulo(activo.getInfoComercial())
							&& !Checks.esNulo(activo.getInfoComercial().getFechaAceptacion())) {
						activoApi.calcularRatingActivo(activo.getId());
					}

					map.put("idInformeMediadorWebcom", informe.getIdInformeMediadorWebcom());
					if (!Checks.esNulo(informeEntity)) {
						map.put("idInformeMediadorRem", informeEntity.getId());
					} else {
						informeEntity = genericDao.get(ActivoInfoComercial.class, genericDao
								.createFilter(FilterType.EQUALS, "idWebcom", informe.getIdInformeMediadorWebcom()));
						if (!Checks.esNulo(informeEntity)) {
							map.put("idInformeMediadorRem", informeEntity.getId());
						}
					}
					map.put("success", true);
				} else {
					map.put("idInformeMediadorWebcom", informe.getIdInformeMediadorWebcom());
					map.put("success", false);
					map.put("fasesIncorrectas", RestApi.REST_FASE_SUBFASE_INVALIDAS);
				}
			} else {
				map.put("idInformeMediadorWebcom", informe.getIdInformeMediadorWebcom());
				map.put("success", false);
				map.put("invalidFields", errorsList);
			}

			listaRespuesta.add(map);
			i++;
		}
		return listaRespuesta;
	}

}
