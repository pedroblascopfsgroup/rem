package es.pfsgroup.plugin.rem.utils;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.rem.model.dd.DDAcabadoCarpinteria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadEjecutante;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdjudicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConstruccion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDisponibilidadComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDivHorizontal;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresupuesto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdelanto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCuota;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFachada;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOrientacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRenta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUbicaAparcamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUbicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposTextoOferta;

@Component
public class DiccionarioTargetClassMap{

	public static Map<String, Class<?>> mapaDiccionarios = createHashMap();
	
	/**
	 * Método que devuelve la clase del diccionario solicitado
	 * @param diccionario
	 * @return Class del diccinario
	 */
	public static Class<?> convertToTargetClass(String diccionario) {
		
		return mapaDiccionarios.get(diccionario);
		
	}

	/**
	 * Método que crea el mapa con los valores tipoDiccionario y clase a la que pertenece
	 * @return {@link HashMap}
	 */
	private static Map<String, Class<?>> createHashMap() {
		
		Map<String, Class<?>> mapa = new HashMap<String, Class<?>>();
		
		mapa.put("tiposVia", DDTipoVia.class);		
		mapa.put("entidadesPropietarias", DDCartera.class);
		mapa.put("tiposUsoDestino", DDTipoUsoDestino.class);
		mapa.put("acabadosCarpinteria", DDAcabadoCarpinteria.class);
		mapa.put("estadosActivo", DDEstadoActivo.class);
		mapa.put("paises", DDCicCodigoIsoCirbeBKP.class);
		mapa.put("tiposCuota", DDTipoCuota.class);
		mapa.put("tiposVpo", DDTipoVpo.class);
		mapa.put("tiposPosesorio", DDTipoTituloPosesorio.class);
		mapa.put("estadosObraNueva", DDEstadoObraNueva.class);
		mapa.put("estadosDivHorizontal", DDEstadoDivHorizontal.class);
		mapa.put("estadosPresupuesto", DDEstadoPresupuesto.class);
		mapa.put("tiposGradoPropiedad", DDTipoGradoPropiedad.class);
		mapa.put("tiposTitulo", DDTipoTituloActivo.class);
		mapa.put("subtiposTitulo", DDSubtipoTituloActivo.class);
		mapa.put("estadosTitulo", DDEstadoTitulo.class);
		mapa.put("tiposUbicacion", DDTipoUbicacion.class);
		mapa.put("ubicacionesAparcamiento", DDTipoUbicaAparcamiento.class);
		mapa.put("estadosConstruccion", DDEstadoConstruccion.class);
		mapa.put("estadosConservacion", DDEstadoConservacion.class);
		mapa.put("tiposFachada",DDTipoFachada.class);
		mapa.put("tiposVivienda", DDTipoVivienda.class);
		mapa.put("tiposOrientacion", DDTipoOrientacion.class);
		mapa.put("tiposRenta", DDTipoRenta.class);
		mapa.put("tiposActivo", DDTipoActivo.class);
		mapa.put("provincias", DDProvincia.class);
		mapa.put("subtiposActivo", DDSubtipoActivo.class);
		mapa.put("tiposCarga", DDTipoCargaActivo.class);
		mapa.put("subtiposCarga", DDSubtipoCarga.class);
		mapa.put("tiposHabitaculo", DDTipoHabitaculo.class);
		mapa.put("estadosCarga", DDSituacionCarga.class);
		mapa.put("estadosAdjudicacion", DDEstadoAdjudicacion.class);
		mapa.put("tiposJuzgado", TipoJuzgado.class);
		mapa.put("entidadesAdjudicacion", DDEntidadAdjudicataria.class);
		mapa.put("estadoDocumento", DDEstadoDocumento.class);	
		mapa.put("tipoAgrupacion", DDTipoAgrupacion.class);
		mapa.put("tiposTrabajo", DDTipoTrabajo.class);
		mapa.put("subtiposTrabajo", DDSubtipoTrabajo.class);
		mapa.put("estadoTrabajo", DDEstadoTrabajo.class);
		mapa.put("valoracionTrabajo", DDTipoCalidad.class);
		mapa.put("tiposDocumento", DDTipoDocumentoActivo.class);
		mapa.put("tiposFoto", DDTipoFoto.class);
		mapa.put("tiposTramite", TipoProcedimiento.class);
		mapa.put("tiposCalculo", DDTipoCalculo.class);
		mapa.put("tiposRecargo", DDTipoRecargoProveedor.class);
		mapa.put("tiposAdelanto", DDTipoAdelanto.class);
		mapa.put("tiposPlaza", TipoPlaza.class);
		mapa.put("entidadEjecutante", DDEntidadEjecutante.class);
		mapa.put("estadosPropuesta", DDEstadoPropuestaPrecio.class);
		mapa.put("estadosPropuestaActivo", DDEstadoPropuestaActivo.class);
		mapa.put("estadoDisponibilidadComercial", DDEstadoDisponibilidadComercial.class);
		mapa.put("estadosOfertas", DDEstadoOferta.class);
		mapa.put("tiposOfertas", DDTipoOferta.class);
		mapa.put("tiposTextoOferta", DDTiposTextoOferta.class);

		return Collections.unmodifiableMap(mapa);
	}
	

	/**
	 * Método que mapea la relación entre tipo documento y subtipo de trabajo. Devuelve un subtipo trabajo para un codigo documento dado.
	 * @return {@link HashMap}
	 */
    public String getSubtipoTrabajo(String codigoDocumento){
    	
    	Map<String,String> mapa = new HashMap<String,String>();
    	
    	//mapa.put(DDTipoDocumentoActivo.CODIGO_INFORME_COMERCIAL, DDSubtipoTrabajo.CODIGO_INFORME_COMERCIAL);
    	//mapa.put(DDTipoDocumentoActivo.CODIGO_DECRETO_ADJUDICACION, DDSubtipoTrabajo.CODIGO_DECRETO_ADJUDICACION);
    	//mapa.put(DDTipoDocumentoActivo.CODIGO_ESCRITURA_PUBLICA, DDSubtipoTrabajo.CODIGO_ESCRITURA_PUBLICA);
    	//mapa.put(DDTipoDocumentoActivo.CODIGO_DILIGENCIA_TOMA_POSESION, DDSubtipoTrabajo.CODIGO_DILIGENCIA_TOMA_POSESION);
    	//mapa.put(DDTipoDocumentoActivo.CODIGO_NOTA_SIMPLE_SIN_CARGAS, DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_SIN_CARGAS);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_NOTA_SIMPLE_ACTUALIZADA, DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_ACTUALIZADA);
    	//mapa.put(DDTipoDocumentoActivo.CODIGO_TASACION_ADJUDICACION, DDSubtipoTrabajo.CODIGO_TASACION_ADJUDICACION);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_VPO_SOLICITUD_AUTORIZACION, DDSubtipoTrabajo.CODIGO_VPO_AUTORIZACION_VENTA);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_VPO_NOTIFICACION_ADJUDICACION, DDSubtipoTrabajo.CODIGO_VPO_NOTIFICACION_ADJUDICACION);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_VPO_SOLICITUD_IMPORTE, DDSubtipoTrabajo.CODIGO_VPO_SOLICITUD_DEVOLUCION);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_CEE, DDSubtipoTrabajo.CODIGO_CEE);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_LPO, DDSubtipoTrabajo.CODIGO_LPO);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_CEDULA_HABITABILIDAD, DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_CFO, DDSubtipoTrabajo.CODIGO_CFO);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_BOLETIN_AGUA, DDSubtipoTrabajo.CODIGO_BOLETIN_AGUA);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_BOLETIN_ELECTRICIDAD, DDSubtipoTrabajo.CODIGO_BOLETIN_ELECTRICIDAD);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_BOLETIN_GAS, DDSubtipoTrabajo.CODIGO_BOLETIN_GAS);
    	
		return mapa.get(codigoDocumento);
    }
	
	
    public String getTipoDocumento(String codigoSubtipoTrabajo){
    	
    	Map<String,String> mapa = new HashMap<String,String>();
    	
    	//mapa.put(DDSubtipoTrabajo.CODIGO_INFORME_COMERCIAL, DDTipoDocumentoActivo.CODIGO_INFORME_COMERCIAL);
    	//mapa.put(DDSubtipoTrabajo.CODIGO_DECRETO_ADJUDICACION, DDTipoDocumentoActivo.CODIGO_DECRETO_ADJUDICACION);
    	//mapa.put(DDSubtipoTrabajo.CODIGO_ESCRITURA_PUBLICA, DDTipoDocumentoActivo.CODIGO_ESCRITURA_PUBLICA);
    	//mapa.put(DDSubtipoTrabajo.CODIGO_DILIGENCIA_TOMA_POSESION, DDTipoDocumentoActivo.CODIGO_DILIGENCIA_TOMA_POSESION);
    	//mapa.put(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_SIN_CARGAS, DDTipoDocumentoActivo.CODIGO_NOTA_SIMPLE_SIN_CARGAS);
    	mapa.put(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_ACTUALIZADA, DDTipoDocumentoActivo.CODIGO_NOTA_SIMPLE_ACTUALIZADA);
    	//mapa.put(DDSubtipoTrabajo.CODIGO_TASACION_ADJUDICACION, DDTipoDocumentoActivo.CODIGO_TASACION_ADJUDICACION);
    	mapa.put(DDSubtipoTrabajo.CODIGO_VPO_AUTORIZACION_VENTA, DDTipoDocumentoActivo.CODIGO_VPO_SOLICITUD_AUTORIZACION);
    	mapa.put(DDSubtipoTrabajo.CODIGO_VPO_NOTIFICACION_ADJUDICACION, DDTipoDocumentoActivo.CODIGO_VPO_NOTIFICACION_ADJUDICACION);
    	mapa.put(DDSubtipoTrabajo.CODIGO_VPO_SOLICITUD_DEVOLUCION, DDTipoDocumentoActivo.CODIGO_VPO_SOLICITUD_IMPORTE);
    	mapa.put(DDSubtipoTrabajo.CODIGO_CEE, DDTipoDocumentoActivo.CODIGO_CEE);
    	mapa.put(DDSubtipoTrabajo.CODIGO_LPO, DDTipoDocumentoActivo.CODIGO_LPO);
    	mapa.put(DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD, DDTipoDocumentoActivo.CODIGO_CEDULA_HABITABILIDAD);
    	mapa.put(DDSubtipoTrabajo.CODIGO_CFO, DDTipoDocumentoActivo.CODIGO_CFO);
    	mapa.put(DDSubtipoTrabajo.CODIGO_BOLETIN_AGUA, DDTipoDocumentoActivo.CODIGO_BOLETIN_AGUA);
    	mapa.put(DDSubtipoTrabajo.CODIGO_BOLETIN_ELECTRICIDAD, DDTipoDocumentoActivo.CODIGO_BOLETIN_ELECTRICIDAD);
    	mapa.put(DDSubtipoTrabajo.CODIGO_BOLETIN_GAS, DDTipoDocumentoActivo.CODIGO_BOLETIN_GAS);
    	
		return mapa.get(codigoSubtipoTrabajo);
    }
	
	
	
	
}
