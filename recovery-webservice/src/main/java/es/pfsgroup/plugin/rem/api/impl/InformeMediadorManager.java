package es.pfsgroup.plugin.rem.api.impl;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.api.InformeMediadorApi;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;

@Service("informeMediadorManager")
public class InformeMediadorManager implements InformeMediadorApi {

	private HashMap<String, HashMap<String, Boolean>> obligatorios;

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
		
		//numeroTerrazasCubiertas
		HashMap<String, Boolean> numeroTerrazasCubiertas = new HashMap<String, Boolean>();
		numeroTerrazasCubiertas.put(DDTipoActivo.COD_VIVIENDA, true);
		numeroTerrazasCubiertas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numeroterrazascubiertas", numeroTerrazasCubiertas);
		
		//descripcionTerrazasCubiertas
		HashMap<String, Boolean> descripcionTerrazasCubiertas = new HashMap<String, Boolean>();
		descripcionTerrazasCubiertas.put(DDTipoActivo.COD_VIVIENDA, true);
		descripcionTerrazasCubiertas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("descripcionterrazascubiertas", descripcionTerrazasCubiertas);
		
		//despensaOtrasDependencias
		HashMap<String, Boolean> despensaOtrasDependencias = new HashMap<String, Boolean>();
		despensaOtrasDependencias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("despensaotrasdependencias", despensaOtrasDependencias);
		
		//lavaderoOtrasDependencias
		HashMap<String, Boolean> lavaderoOtrasDependencias = new HashMap<String, Boolean>();
		lavaderoOtrasDependencias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("lavaderootrasdependencias", lavaderoOtrasDependencias);
		
		//azoteaOtrasDependencias
		HashMap<String, Boolean> azoteaOtrasDependencias = new HashMap<String, Boolean>();
		azoteaOtrasDependencias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("lavaderootrasdependencias", azoteaOtrasDependencias);
		
		//otrosOtrasDependencias
		HashMap<String, Boolean> otrosOtrasDependencias = new HashMap<String, Boolean>();
		azoteaOtrasDependencias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otrosotrasdependencias", otrosOtrasDependencias);
		
		//instalacionElectricidadInstalaciones
		HashMap<String, Boolean> instalacionElectricidadInstalaciones = new HashMap<String, Boolean>();
		instalacionElectricidadInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		instalacionElectricidadInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("instalacionelectricidadinstalaciones", instalacionElectricidadInstalaciones);
		
		//contadorElectricidadInstalaciones
		HashMap<String, Boolean> contadorElectricidadInstalaciones = new HashMap<String, Boolean>();
		contadorElectricidadInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		contadorElectricidadInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("contadorelectricidadinstalaciones", contadorElectricidadInstalaciones);
		
		//instalacionAguaInstalaciones
		HashMap<String, Boolean> instalacionAguaInstalaciones = new HashMap<String, Boolean>();
		instalacionAguaInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		instalacionAguaInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("instalacionaguainstalaciones", instalacionAguaInstalaciones);
		
		//contadorAguaInstalaciones
		HashMap<String, Boolean> contadorAguaInstalaciones = new HashMap<String, Boolean>();
		contadorAguaInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		contadorAguaInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("contadoraguainstalaciones", contadorAguaInstalaciones);
		
		//gasInstalaciones
		HashMap<String, Boolean> gasInstalaciones = new HashMap<String, Boolean>();
		gasInstalaciones.put(DDTipoActivo.COD_VIVIENDA, true);
		gasInstalaciones.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("gasinstalaciones", gasInstalaciones);
		
		//contadorGasInstalacion
		HashMap<String, Boolean> contadorGasInstalacion = new HashMap<String, Boolean>();
		contadorGasInstalacion.put(DDTipoActivo.COD_VIVIENDA, true);
		contadorGasInstalacion.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("contadorgasinstalacion", contadorGasInstalacion);
		
		//exteriorCarpinteriaReformasNecesarias
		HashMap<String, Boolean> exteriorCarpinteriaReformasNecesarias = new HashMap<String, Boolean>();
		exteriorCarpinteriaReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("exteriorcarpinteriareformasNecesarias", exteriorCarpinteriaReformasNecesarias);
		
		//interiorCarpinteriaReformasNecesarias
		HashMap<String, Boolean> interiorCarpinteriaReformasNecesarias = new HashMap<String, Boolean>();
		interiorCarpinteriaReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("interiorCarpinteriaReformasNecesarias", interiorCarpinteriaReformasNecesarias);
		
		//cocinaReformasNecesarias
		HashMap<String, Boolean> cocinaReformasNecesarias = new HashMap<String, Boolean>();
		cocinaReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("cocinaReformasNecesarias", cocinaReformasNecesarias);
		
		//suelosReformasNecesarias
		HashMap<String, Boolean> suelosReformasNecesarias = new HashMap<String, Boolean>();
		suelosReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("suelosreformasnecesarias", suelosReformasNecesarias);
		
		//pinturaReformasNecesarias
		HashMap<String, Boolean> pinturaReformasNecesarias = new HashMap<String, Boolean>();
		pinturaReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("pinturareformasnecesarias", pinturaReformasNecesarias);
		
		//integralReformasNecesarias
		HashMap<String, Boolean> integralReformasNecesarias = new HashMap<String, Boolean>();
		integralReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("integralreformasnecesarias", integralReformasNecesarias);
		
		//banyosReformasNecesarias
		HashMap<String, Boolean> banyosReformasNecesarias = new HashMap<String, Boolean>();
		banyosReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("banyosreformasnecesarias", banyosReformasNecesarias);
		
		//otrasReformasNecesarias
		HashMap<String, Boolean> otrasReformasNecesarias = new HashMap<String, Boolean>();
		otrasReformasNecesarias.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otrasreformasnecesarias", otrasReformasNecesarias);
		
		//otrasReformasNecesariasImporteAproximado
		HashMap<String, Boolean> otrasReformasNecesariasImporteAproximado = new HashMap<String, Boolean>();
		otrasReformasNecesariasImporteAproximado.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("otrasreformasnecesariasimporteAproximado", otrasReformasNecesariasImporteAproximado);
		
		//activosVinculados
		HashMap<String, Boolean> activosVinculados = new HashMap<String, Boolean>();
		activosVinculados.put(DDTipoActivo.COD_VIVIENDA, true);
		activosVinculados.put(DDTipoActivo.COD_COMERCIAL, true);
		activosVinculados.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("activosvinculados", activosVinculados);
		
		//distribucionInterior
		HashMap<String, Boolean> distribucionInterior = new HashMap<String, Boolean>();
		distribucionInterior.put(DDTipoActivo.COD_VIVIENDA, true);
		distribucionInterior.put(DDTipoActivo.COD_SUELO, true);
		distribucionInterior.put(DDTipoActivo.COD_COMERCIAL, true);
		distribucionInterior.put(DDTipoActivo.COD_INDUSTRIAL, true);
		distribucionInterior.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		distribucionInterior.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("distribucioninterior", distribucionInterior);
		
		//divisible
		HashMap<String, Boolean> divisible = new HashMap<String, Boolean>();
		divisible.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("otrasreformasnecesarias", divisible);
		
		//ascensor
		HashMap<String, Boolean> ascensor = new HashMap<String, Boolean>();
		ascensor.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("ascensor", ascensor);
		
		//numeroAscensores
		HashMap<String, Boolean> numeroAscensores = new HashMap<String, Boolean>();
		numeroAscensores.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("numeroascensores", numeroAscensores);
		
		//descripcionPlantas
		HashMap<String, Boolean> descripcionPlantas = new HashMap<String, Boolean>();
		descripcionPlantas.put(DDTipoActivo.COD_COMERCIAL, true);
		descripcionPlantas.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("numeroascensores", descripcionPlantas);
		
		//otrasCaracteristicas
		HashMap<String, Boolean> otrasCaracteristicas = new HashMap<String, Boolean>();
		otrasCaracteristicas.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("otrascaracteristicas", otrasCaracteristicas);
		
		//fachadaReformasNecesarias
		HashMap<String, Boolean> fachadaReformasNecesarias = new HashMap<String, Boolean>();
		fachadaReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("fachadareformasnecesarias", fachadaReformasNecesarias);
		
		//escaleraReformasNecesarias
		HashMap<String, Boolean> escaleraReformasNecesarias = new HashMap<String, Boolean>();
		escaleraReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("escalerareformasnecesarias", escaleraReformasNecesarias);
		
		//portalReformasNecesarias
		HashMap<String, Boolean> portalReformasNecesarias = new HashMap<String, Boolean>();
		portalReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("portalreformasnecesarias", portalReformasNecesarias);
		
		//ascensorReformasNecesarias
		HashMap<String, Boolean> ascensorReformasNecesarias = new HashMap<String, Boolean>();
		ascensorReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("ascensorreformasnecesarias", ascensorReformasNecesarias);
		
		//cubierta
		HashMap<String, Boolean> cubierta = new HashMap<String, Boolean>();
		cubierta.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("cubierta", cubierta);
		
		//otrasZonasComunesReformasNecesarias
		HashMap<String, Boolean> otrasZonasComunesReformasNecesarias = new HashMap<String, Boolean>();
		otrasZonasComunesReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("otraszonascomunesreformasnecesarias", otrasZonasComunesReformasNecesarias);
		
		//otrosReformasNecesarias
		HashMap<String, Boolean> otrosReformasNecesarias = new HashMap<String, Boolean>();
		otrosReformasNecesarias.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("otrosreformasnecesarias", otrosReformasNecesarias);
		
		//descripcionEdificio
		HashMap<String, Boolean> descripcionEdificio = new HashMap<String, Boolean>();
		descripcionEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		descripcionEdificio.put(DDTipoActivo.COD_SUELO, true);
		descripcionEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		descripcionEdificio.put(DDTipoActivo.COD_INDUSTRIAL, true);
		descripcionEdificio.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		descripcionEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("descripcionedificio", descripcionEdificio);
		
		//infraestructurasEntorno
		HashMap<String, Boolean> infraestructurasEntorno = new HashMap<String, Boolean>();
		infraestructurasEntorno.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("infraestructurasentorno", infraestructurasEntorno);
		
		//comunicacionesEntorno
		HashMap<String, Boolean> comunicacionesEntorno = new HashMap<String, Boolean>();
		comunicacionesEntorno.put(DDTipoActivo.COD_EDIFICIO_COMPLETO, true);
		obligatorios.put("comunicacionesEntorno", comunicacionesEntorno);
		
		//idoneoUso
		HashMap<String, Boolean> idoneoUso = new HashMap<String, Boolean>();
		idoneoUso.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("idoneoUso", idoneoUso);
		
		//existeAnteriorUso;
		HashMap<String, Boolean> existeAnteriorUso = new HashMap<String, Boolean>();
		existeAnteriorUso.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("existeanterioruso", existeAnteriorUso);
		
		//anteriorUso
		HashMap<String, Boolean> anteriorUso = new HashMap<String, Boolean>();
		anteriorUso.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("anterioruso", anteriorUso);
		
		//numeroEstancias
		HashMap<String, Boolean> numeroEstancias = new HashMap<String, Boolean>();
		numeroEstancias.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numeroestancias", numeroEstancias);
		
		//numeroBanyos
		HashMap<String, Boolean> numeroBanyos = new HashMap<String, Boolean>();
		numeroBanyos.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numerobanyos", numeroBanyos);
		
		//numeroAseos
		HashMap<String, Boolean> numeroAseos = new HashMap<String, Boolean>();
		numeroAseos.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numeroaseos", numeroAseos);
		
		//metrosLinealesFachadaPrincipal
		HashMap<String, Boolean> metrosLinealesFachadaPrincipal = new HashMap<String, Boolean>();
		metrosLinealesFachadaPrincipal.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("metroslinealesfachadaprincipal", metrosLinealesFachadaPrincipal);
		
		//altura
		HashMap<String, Boolean> altura = new HashMap<String, Boolean>();
		altura.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("altura", altura);
		
		//numeroPlazasGaraje
		HashMap<String, Boolean> numeroPlazasGaraje = new HashMap<String, Boolean>();
		numeroPlazasGaraje.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("numeroplazasgaraje", numeroPlazasGaraje);
		
		//superficiePlazasGaraje
		HashMap<String, Boolean> superficiePlazasGaraje = new HashMap<String, Boolean>();
		superficiePlazasGaraje.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("superficieplazasgaraje", superficiePlazasGaraje);
		
		//codSubtipoPlazasGaraje
		HashMap<String, Boolean> codSubtipoPlazasGaraje = new HashMap<String, Boolean>();
		codSubtipoPlazasGaraje.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("codsubtipoplazasgaraje", codSubtipoPlazasGaraje);
		
		//salidaHumosOtrasCaracteristicas
		HashMap<String, Boolean> salidaHumosOtrasCaracteristicas = new HashMap<String, Boolean>();
		salidaHumosOtrasCaracteristicas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("salidahumosotrascaracteristicas", salidaHumosOtrasCaracteristicas);
		
		//salidaEmergenciaOtrasCaracteristicas
		HashMap<String, Boolean> salidaEmergenciaOtrasCaracteristicas = new HashMap<String, Boolean>();
		salidaEmergenciaOtrasCaracteristicas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("salidaemergenciaotrascaracteristicas", salidaEmergenciaOtrasCaracteristicas);
		
		//accesoMinusvalidosOtrasCaracteristicas
		HashMap<String, Boolean> accesoMinusvalidosOtrasCaracteristicas = new HashMap<String, Boolean>();
		accesoMinusvalidosOtrasCaracteristicas.put(DDTipoActivo.COD_COMERCIAL, true);
		obligatorios.put("accesominusvalidosotrascaracteristicas", accesoMinusvalidosOtrasCaracteristicas);
		
		//otrosOtrasCaracteristicas
		HashMap<String, Boolean> otrosOtrasCaracteristicas = new HashMap<String, Boolean>();
		otrosOtrasCaracteristicas.put(DDTipoActivo.COD_COMERCIAL, true);
		otrosOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("otrosotrascaracteristicas", otrosOtrasCaracteristicas);
		
		//codTipoVario
		HashMap<String, Boolean> codTipoVario = new HashMap<String, Boolean>();
		codTipoVario.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("codtipovario", codTipoVario);
		
		//ancho
		HashMap<String, Boolean> ancho = new HashMap<String, Boolean>();
		ancho.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("ancho", ancho);
		
		//alto
		HashMap<String, Boolean> alto = new HashMap<String, Boolean>();
		alto.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("alto", alto);
		
		//largo
		HashMap<String, Boolean> largo = new HashMap<String, Boolean>();
		largo.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("largo", largo);
		
		//codUso
		HashMap<String, Boolean> codUso = new HashMap<String, Boolean>();
		codUso.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("codUso", codUso);
		
		//codManiobrabilidad
		HashMap<String, Boolean> codManiobrabilidad = new HashMap<String, Boolean>();
		codManiobrabilidad.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("codmaniobrabilidad", codManiobrabilidad);
		
		//licenciaOtrasCaracteristicas
		HashMap<String, Boolean> licenciaOtrasCaracteristicas = new HashMap<String, Boolean>();
		licenciaOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("licenciaotrascaracteristicas", licenciaOtrasCaracteristicas);
		
		//servidumbreOtrasCaracteristicas
		HashMap<String, Boolean> servidumbreOtrasCaracteristicas = new HashMap<String, Boolean>();
		servidumbreOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("servidumbreotrascaracteristicas", servidumbreOtrasCaracteristicas);
		
		//ascensorOMontacargasOtrasCaracteristicas
		HashMap<String, Boolean> ascensorOMontacargasOtrasCaracteristicas = new HashMap<String, Boolean>();
		ascensorOMontacargasOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("ascensoromontacargasotrascaracteristicas", ascensorOMontacargasOtrasCaracteristicas);
		
		//columnasOtrasCaracteristicas
		HashMap<String, Boolean> columnasOtrasCaracteristicas = new HashMap<String, Boolean>();
		columnasOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("columnasotrascaracteristicas", columnasOtrasCaracteristicas);
		
		//seguridadOtrasCaracteristicas
		HashMap<String, Boolean> seguridadOtrasCaracteristicas = new HashMap<String, Boolean>();
		seguridadOtrasCaracteristicas.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("seguridadotrascaracteristicas", seguridadOtrasCaracteristicas);
		
		//buenEstadoInstalacionElectricidadInstalaciones
		HashMap<String, Boolean> buenEstadoInstalacionElectricidadInstalaciones = new HashMap<String, Boolean>();
		buenEstadoInstalacionElectricidadInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadoinstalacionelectricidadinstalaciones", buenEstadoInstalacionElectricidadInstalaciones);
		
		//buenEstadoContadorElectricidadInstalaciones
		HashMap<String, Boolean> buenEstadoContadorElectricidadInstalaciones = new HashMap<String, Boolean>();
		buenEstadoContadorElectricidadInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadocontadorelectricidadinstalaciones", buenEstadoContadorElectricidadInstalaciones);
		
		//buenEstadoInstalacionAguaInstalaciones
		HashMap<String, Boolean> buenEstadoInstalacionAguaInstalaciones = new HashMap<String, Boolean>();
		buenEstadoInstalacionAguaInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadoinstalacionaguainstalaciones", buenEstadoInstalacionAguaInstalaciones);
		
		//buenEstadoContadorAguaInstalaciones
		HashMap<String, Boolean> buenEstadoContadorAguaInstalaciones = new HashMap<String, Boolean>();
		buenEstadoContadorAguaInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadocontadoraguainstalaciones", buenEstadoContadorAguaInstalaciones);
		
		//buenEstadoGasInstalaciones
		HashMap<String, Boolean> buenEstadoGasInstalaciones = new HashMap<String, Boolean>();
		buenEstadoGasInstalaciones.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadogasinstalaciones", buenEstadoGasInstalaciones);
		
		//buenEstadoContadorGasInstalacion
		HashMap<String, Boolean> buenEstadoContadorGasInstalacion = new HashMap<String, Boolean>();
		buenEstadoContadorGasInstalacion.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadocontadorgasinstalacion", buenEstadoContadorGasInstalacion);
		
		//buenEstadoConservacionEdificio
		HashMap<String, Boolean> buenEstadoConservacionEdificio = new HashMap<String, Boolean>();
		buenEstadoConservacionEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		buenEstadoConservacionEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		buenEstadoConservacionEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("buenestadoconservacionedificio", buenEstadoConservacionEdificio);
		
		//anyoRehabilitacionEdificio
		HashMap<String, Boolean> anyoRehabilitacionEdificio = new HashMap<String, Boolean>();
		anyoRehabilitacionEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		anyoRehabilitacionEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		anyoRehabilitacionEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("anyorehabilitacionedificio", anyoRehabilitacionEdificio);
		
		//numeroPlantasEdificio
		HashMap<String, Boolean> numeroPlantasEdificio = new HashMap<String, Boolean>();
		numeroPlantasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		numeroPlantasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		numeroPlantasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("numeroplantasedificio", numeroPlantasEdificio);
		
		//ascensorEdificio
		HashMap<String, Boolean> ascensorEdificio = new HashMap<String, Boolean>();
		ascensorEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		ascensorEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		ascensorEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("ascensoredificio", ascensorEdificio);
		
		//numeroAscensoresEdificio
		HashMap<String, Boolean> numeroAscensoresEdificio = new HashMap<String, Boolean>();
		numeroAscensoresEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		numeroAscensoresEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		numeroAscensoresEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("numeroascensoresedificio", numeroAscensoresEdificio);
		
		//existeComunidadEdificio
		HashMap<String, Boolean> existeComunidadEdificio = new HashMap<String, Boolean>();
		existeComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		existeComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		existeComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("existecomunidadedificio", existeComunidadEdificio);
		
		//cuotaComunidadEdificio
		HashMap<String, Boolean> cuotaComunidadEdificio = new HashMap<String, Boolean>();
		cuotaComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		cuotaComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		cuotaComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("cuotacomunidadedificio", cuotaComunidadEdificio);
		
		//nombrePresidenteComunidadEdificio
		HashMap<String, Boolean> nombrePresidenteComunidadEdificio = new HashMap<String, Boolean>();
		nombrePresidenteComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		nombrePresidenteComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		nombrePresidenteComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("nombrepresidentecomunidadedificio", nombrePresidenteComunidadEdificio);
		
		//telefonoPresidenteComunidadEdificio
		HashMap<String, Boolean> telefonoPresidenteComunidadEdificio = new HashMap<String, Boolean>();
		telefonoPresidenteComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		telefonoPresidenteComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		telefonoPresidenteComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("telefonopresidentecomunidadedificio", telefonoPresidenteComunidadEdificio);
		
		//nombreAdministradorComunidadEdificio
		HashMap<String, Boolean> nombreAdministradorComunidadEdificio = new HashMap<String, Boolean>();
		nombreAdministradorComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		nombreAdministradorComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		nombreAdministradorComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("nombreadministradorcomunidadedificio", nombreAdministradorComunidadEdificio);
		
		//telefonoAdministradorComunidadEdificio
		HashMap<String, Boolean> telefonoAdministradorComunidadEdificio = new HashMap<String, Boolean>();
		telefonoAdministradorComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		telefonoAdministradorComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		telefonoAdministradorComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("telefonoadministradorcomunidadedificio", telefonoAdministradorComunidadEdificio);
		
		//descripcionDerramaComunidadEdificio
		HashMap<String, Boolean> descripcionDerramaComunidadEdificio = new HashMap<String, Boolean>();
		descripcionDerramaComunidadEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		descripcionDerramaComunidadEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		descripcionDerramaComunidadEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("descripcionderramacomunidadedificio", descripcionDerramaComunidadEdificio);
		
		//ascensorReformasNecesariasEdificio
		HashMap<String, Boolean> ascensorReformasNecesariasEdificio = new HashMap<String, Boolean>();
		ascensorReformasNecesariasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		ascensorReformasNecesariasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		ascensorReformasNecesariasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("ascensorreformasnecesariasedificio", ascensorReformasNecesariasEdificio);
		
		//cubiertaReformasNecesariasEdificio
		HashMap<String, Boolean> cubiertaReformasNecesariasEdificio = new HashMap<String, Boolean>();
		cubiertaReformasNecesariasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		cubiertaReformasNecesariasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		cubiertaReformasNecesariasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("cubiertareformasnecesariasedificio", cubiertaReformasNecesariasEdificio);
		
		//otrasZonasComunesReformasNecesariasEdificio
		HashMap<String, Boolean> otrasZonasComunesReformasNecesariasEdificio = new HashMap<String, Boolean>();
		otrasZonasComunesReformasNecesariasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		otrasZonasComunesReformasNecesariasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		otrasZonasComunesReformasNecesariasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("otraszonascomunesreformasnecesariasedificio", otrasZonasComunesReformasNecesariasEdificio);
		
		//otrosReformasNecesariasEdificio
		HashMap<String, Boolean> otrosReformasNecesariasEdificio = new HashMap<String, Boolean>();
		otrosReformasNecesariasEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		otrosReformasNecesariasEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		otrosReformasNecesariasEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("otrosreformasnecesariasedificio", otrosReformasNecesariasEdificio);
		
		//infraestructurasEntornoEdificio
		HashMap<String, Boolean> infraestructurasEntornoEdificio = new HashMap<String, Boolean>();
		infraestructurasEntornoEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		infraestructurasEntornoEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		infraestructurasEntornoEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("infraestructurasentornoedificio", infraestructurasEntornoEdificio);
		
		//comunicacionesEntornoEdificio
		HashMap<String, Boolean> comunicacionesEntornoEdificio = new HashMap<String, Boolean>();
		comunicacionesEntornoEdificio.put(DDTipoActivo.COD_VIVIENDA, true);
		comunicacionesEntornoEdificio.put(DDTipoActivo.COD_COMERCIAL, true);
		comunicacionesEntornoEdificio.put(DDTipoActivo.COD_OTROS, true);
		obligatorios.put("comunicacionesentornoedificio", comunicacionesEntornoEdificio);
		
		//existeOcio
		HashMap<String, Boolean> existeOcio = new HashMap<String, Boolean>();
		existeOcio.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existeocio", existeOcio);
		
		//existenHoteles
		HashMap<String, Boolean> existenHoteles = new HashMap<String, Boolean>();
		existenHoteles.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenhoteles", existenHoteles);
		
		//hoteles
		HashMap<String, Boolean> hoteles = new HashMap<String, Boolean>();
		hoteles.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("hoteles", hoteles);
		
		//existenTeatros
		HashMap<String, Boolean> existenTeatros = new HashMap<String, Boolean>();
		existenTeatros.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("existenteatros", existenTeatros);
		
		//teatros
		HashMap<String, Boolean> teatros = new HashMap<String, Boolean>();
		teatros.put(DDTipoActivo.COD_VIVIENDA, true);
		obligatorios.put("teatros", teatros);
		
		
		
		
		
	}

	@Override
	public void validateInformeField(List<String> errorsList, String fiedlName, Object fieldValor,
			String codigoTipoBien) {
		fiedlName = fiedlName.substring(3);
		HashMap<String, Boolean> permisos = obligatorios.get(fiedlName.toLowerCase());
		if (permisos != null) {
			if (permisos.containsKey(codigoTipoBien)
					&& (fieldValor == null || (fieldValor instanceof String && ((String) fieldValor).isEmpty()))) {
				errorsList.add("El campo ".concat(fiedlName)
						.concat(" no puede ser null para el tipo activo ".concat(codigoTipoBien)));
			}
		}
	}

	@Override
	public void validateInformeMediadorDto(InformeMediadorDto informe, String codigoTipoBien, List<String> errorsList)
			throws IntrospectionException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		for (PropertyDescriptor propertyDescriptor : Introspector.getBeanInfo(InformeMediadorDto.class)
				.getPropertyDescriptors()) {
			Object obj = propertyDescriptor.getReadMethod().invoke(informe);
			this.validateInformeField(errorsList, propertyDescriptor.getReadMethod().getName(), obj, codigoTipoBien);

		}

	}

}
