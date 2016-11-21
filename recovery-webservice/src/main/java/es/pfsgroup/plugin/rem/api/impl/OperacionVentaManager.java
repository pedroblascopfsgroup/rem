package es.pfsgroup.plugin.rem.api.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.HojaDatosApi;
import es.pfsgroup.plugin.rem.api.HojaDatosPDF;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoPropuestaOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.utils.FileUtilsREM;

@Service("operacionVentaManager")
public class OperacionVentaManager extends HojaDatosPDF implements HojaDatosApi{
	
	@Autowired 
	private OfertaApi ofertaApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;

	@Override
	public Map<String, Object> paramsHojaDatos(Oferta oferta, ModelMap model) {
		
		Map<String, Object> mapaValores = new HashMap<String, Object>();

		try {
			// Obteniedo el activo relacionado con la OFERTA
			Activo activo = oferta.getActivoPrincipal();
			if (activo == null) {
				model.put("error", RestApi.REST_NO_RELATED_ASSET);
				throw new Exception(RestApi.REST_NO_RELATED_ASSET);
			}
			mapaValores.put("Activo", activo.getNumActivoUvem().toString());
			mapaValores.put("NumOfProp", oferta.getNumOferta() + "/1");
			
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM");
			Long tipo = genericDao.get(EXTDDTipoGestor.class, filter).getId();		
			if (gestorActivoApi.getGestorByActivoYTipo(activo, tipo)!=null) {
				mapaValores.put("Gestor", gestorActivoApi.getGestorByActivoYTipo(activo, tipo).getApellidoNombre());
			} else {
				mapaValores.put("Gestor", FileUtilsREM.stringify(null));
			}
			
			mapaValores.put("FAprobacion",FileUtilsREM.stringify(null));
			mapaValores.put("Referencia",FileUtilsREM.stringify(null));
			mapaValores.put("Prescriptor",FileUtilsREM.stringify(null));
			mapaValores.put("Sucursal",FileUtilsREM.stringify(null));
			
			
			mapaValores.put("Direccion",FileUtilsREM.stringify(activo.getDireccion()));
			if (activo.getTipoActivo()!=null) {
				mapaValores.put("Tipo",FileUtilsREM.stringify(activo.getTipoActivo().getDescripcionLarga()));
			} else {
				mapaValores.put("Tipo",FileUtilsREM.stringify(null));
			}
			if (activo.getSubtipoActivo()!=null) {
				mapaValores.put("Subtipo",FileUtilsREM.stringify(activo.getSubtipoActivo().getDescripcionLarga()));
			} else {
				mapaValores.put("Subtipo",FileUtilsREM.stringify(null));
			}

			List<ActivoAdmisionDocumento> listaAdmisionDocumento = activo.getAdmisionDocumento();
			boolean isFoundCalificacion = false;
			for (int m = 0; m < listaAdmisionDocumento.size(); m++) {
				ActivoAdmisionDocumento admisionDocumento = listaAdmisionDocumento.get(m);
				if (admisionDocumento.getTipoCalificacionEnergetica()!=null && 
					admisionDocumento.getEstadoDocumento()!=null && 
					DDEstadoDocumento.CODIGO_ESTADO_OBTENIDO.equals(admisionDocumento.getEstadoDocumento().getCodigo())) {
					mapaValores.put("CertificadoEnergetico", admisionDocumento.getTipoCalificacionEnergetica().getDescripcionLarga());
					isFoundCalificacion = true;
				} 				
			}
			if (!isFoundCalificacion) {
				mapaValores.put("CertificadoEnergetico",FileUtilsREM.stringify(null));
			}
			mapaValores.put("SuperficieConstruida",FileUtilsREM.stringify(activo.getTotalSuperficieConstruida()));
			mapaValores.put("SuperficieUtil",FileUtilsREM.stringify(activo.getTotalSuperficieUtil()));
			mapaValores.put("SuperficieRegistro",FileUtilsREM.stringify(activo.getTotalSuperficieSuelo()));
			
			List<ActivoPropietarioActivo> listaPropietarios = activo.getPropietariosActivo();
			if (listaPropietarios!=null && listaPropietarios.get(0).getPropietario()!=null && listaPropietarios.get(0).getPropietario().getFullName()!=null){
				mapaValores.put("SociedadPatrimonial",listaPropietarios.get(0).getPropietario().getFullName());
				Double porcentaje =  (double) (100/listaPropietarios.size());
				mapaValores.put("PorcentajePropiedad",FileUtilsREM.stringify(porcentaje));
			} else {
				mapaValores.put("SociedadPatrimonial",FileUtilsREM.stringify(null));
				mapaValores.put("PorcentajePropiedad",FileUtilsREM.stringify(null));
			}
			
			NMBBien bien =  activo.getBien();
			if (bien!=null) {
				if (bien.getDatosRegistrales()!=null) {
					mapaValores.put("FincaRegistral",FileUtilsREM.stringify(bien.getDatosRegistrales()));
				} else {
					mapaValores.put("FincaRegistral",FileUtilsREM.stringify(null));
				}
			} else {
				mapaValores.put("FincaRegistral",FileUtilsREM.stringify(null));
			}

			Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(activo);
			if (ofertaAceptada==null) {
				model.put("error", RestApi.REST_NO_RELATED_OFFER_ACCEPTED);
				throw new Exception(RestApi.REST_NO_RELATED_OFFER_ACCEPTED);					
			}
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaAceptada.getId());
			ExpedienteComercial expediente = (ExpedienteComercial) genericDao.get(ExpedienteComercial.class, filtro);
			if (expediente==null) {
				model.put("error", RestApi.REST_NO_RELATED_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_EXPEDIENT);					
			} 
			CondicionanteExpediente condExp = expediente.getCondicionante();
			if (condExp==null) {
				model.put("error", RestApi.REST_NO_RELATED_COND_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_COND_EXPEDIENT);					
			}
//			Si con posesión inicial "sí": El ofertante requiere que haya posesión inicial.
//			Si con posesión inicial "no": El ofertante acepta que no haya posesión inicial.
//			Si con situación posesoria "vacío": El ofertante acepta cualquier situación posesoria.
//			Si con situación posesoria "libre": El ofertante requiere que el activo esté libre de ocupantes.
//			Si con situación posesoria "ocupado con título": El ofertante acepta que el activo esté arrendado.
			Integer poseInicial = condExp.getPosesionInicial();
			DDSituacionesPosesoria sitaPosesion = condExp.getSituacionPosesoria();
			String txtPosesion = "";
			if (poseInicial==null) {
				txtPosesion += "";
			} else {
				if (poseInicial.equals(new Integer(1))) {
					txtPosesion += "El ofertante requiere que haya posesión inicial.";
				} else {
					txtPosesion += "El ofertante acepta que no haya posesión inicial.";
				}
			}
			if (sitaPosesion==null) {
				txtPosesion += "El ofertante acepta cualquier situación posesoria.";
			} else {
				if (sitaPosesion.getCodigo().equals(DDSituacionesPosesoria.SITUACION_POSESORIA_LIBRE)) {
					txtPosesion += "El ofertante requiere que el activo esté libre de ocupantes.";
				} else if (sitaPosesion.getCodigo().equals(DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_CON_TITULO)) {
					txtPosesion += "El ofertante acepta que el activo esté arrendado.";
				}
			}
			mapaValores.put("Posesion", txtPosesion);
			
//			Si hay contenido en impuestos y en el combo "por cuenta de" pone "comprador": El comprador asume el pago de los impuestos pendientes.
//			Si hay contenido en comunidades y en el combo "por cuenta de" pone "vendedor": El comprador no asume el pago de los impuestos pendientes.
//			Si hay contenido en otros y en el combo "por cuenta de" pone "según ley": El comprador requiere que los gastos sean asumidos por quien corresponda según ley.
			DDTiposPorCuenta porCuentaImpuestos = condExp.getTipoPorCuentaImpuestos();
			DDTiposPorCuenta porCuentaComunidad = condExp.getTipoPorCuentaComunidad();
			DDTiposPorCuenta porCuentaOtros = condExp.getTipoPorCuentaCargasOtros();
			String txtCargas = "";
			if (condExp.getCargasImpuestos()!=null && porCuentaImpuestos!=null && porCuentaImpuestos.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_COMPRADOR)) {
				txtCargas += "El comprador asume el pago de los impuestos pendientes. ";
			}
			if (condExp.getCargasComunidad()!=null && porCuentaComunidad!=null && porCuentaComunidad.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_VENDEDOR)) {
				txtCargas += "El comprador no asume el pago de los impuestos pendientes. ";
			}
			if (condExp.getCargasOtros()!=null && porCuentaOtros!=null && porCuentaOtros.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_SEGUN_LEY)) {
				txtCargas += "El comprador requiere que los gastos sean asumidos por quien corresponda según ley. ";
			}
			mapaValores.put("Tratamientodecargas", txtCargas);

			if (activo.getInfoRegistral()!=null && activo.getInfoRegistral().getInfoRegistralBien()!=null) {
				if (activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion()==null) {
					mapaValores.put("Inscripcion", "SI");
				} else {
					mapaValores.put("Inscripcion", "NO");
				}				
				mapaValores.put("Registro",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getCodigoRegistro()));
				mapaValores.put("RegistroNo",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro()));
				mapaValores.put("Tomo",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getTomo()));
				mapaValores.put("Libro",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getLibro()));
				mapaValores.put("Folio",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getFolio()));
			} else {
				mapaValores.put("Inscripcion", FileUtilsREM.stringify(null));
				mapaValores.put("Registro",FileUtilsREM.stringify(null));
				mapaValores.put("RegistroNo",FileUtilsREM.stringify(null));
				mapaValores.put("Tomo",FileUtilsREM.stringify(null));
				mapaValores.put("Libro",FileUtilsREM.stringify(null));
				mapaValores.put("Folio",FileUtilsREM.stringify(null));
			}
			
			
			
			mapaValores.put("TipoPropiedad",FileUtilsREM.stringify(null));
			


			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return mapaValores;
	}

	@Override
	public List<Object> dataSourceHojaDatos(Oferta oferta, Activo activo, ModelMap model) {
		List<Object> array = new ArrayList<Object>();
		
		try {
			Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(activo);
			if (ofertaAceptada==null) {
				model.put("error", RestApi.REST_NO_RELATED_OFFER_ACCEPTED);
				throw new Exception(RestApi.REST_NO_RELATED_OFFER_ACCEPTED);					
			}
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaAceptada.getId());
			ExpedienteComercial expediente = (ExpedienteComercial) genericDao.get(ExpedienteComercial.class, filtro);
			if (expediente==null) {
				model.put("error", RestApi.REST_NO_RELATED_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_EXPEDIENT);					
			} else {
				List<CompradorExpediente> listaComprador = expediente.getCompradores();
				for (int i = 0; i < listaComprador.size(); i++) {
					//TODO: listaComprador.get(i).get
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		
		//Datos vacios para que jasperReport no falle.
		DtoPropuestaOferta propuestaOferta = new DtoPropuestaOferta();
		List<Object> listaCliente = new ArrayList<Object>();
		propuestaOferta.setListaCliente(listaCliente);
		array.add(propuestaOferta);
		
		return array;
	}
	
}
