package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.VBusquedaActivos;


public class ActivoExcelReport extends AbstractExcelReport implements ExcelReport {

	private static final String CAB_NUM_ACTIVO = "Nº activo";
	private static final String CAB_TIPO = "Tipo";
	private static final String CAB_SUBTIPO = "Subtipo";
	private static final String CAB_CARTERA = "Cartera";
	private static final String CAB_ORIGEN = "Origen";
	private static final String CAB_VIA = "Via";
	private static final String CAB_MUNICIPIO = "Municipio";
	private static final String CAB_PROVINCIA = "Provincia";
	private static final String CAB_CP = "Código Postal";
	private static final String CAB_DPTO_COMERCIAL = "Dpto. Comercial";
	private static final String CAB_ESTADO_OCUPACION = "Estado ocupación";
	private static final String CAB_ESTADO_FISCO_ACTIVO = "Estado físico del activo";
	private static final String CAB_DPTO_ADMISION = "Dpto. Admisión";
	private static final String CAB_DPTO_GESTION = "Dtpo. Gestion";
	private static final String CAB_DPTO_CALIDAD = "Dpto. Calidad";
	private static final String CAB_RATING = "Rating";
	
	private List<VBusquedaActivos> listaActivos;
	private Map<String,String> mapRating;

	private final GenericABMDao genericDao;

	public ActivoExcelReport(List<VBusquedaActivos> listaActivos, Map<String,String> mapRating, GenericABMDao genericDao) {
		this.listaActivos = listaActivos;
		this.mapRating = mapRating;
		this.genericDao = genericDao;
	}
		

	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add(CAB_NUM_ACTIVO);
		listaCabeceras.add(CAB_TIPO);
		listaCabeceras.add(CAB_SUBTIPO);
		listaCabeceras.add(CAB_CARTERA);
		listaCabeceras.add(CAB_ORIGEN);
		listaCabeceras.add(CAB_VIA);
		listaCabeceras.add(CAB_MUNICIPIO);
		listaCabeceras.add(CAB_PROVINCIA);
		listaCabeceras.add(CAB_CP);
		listaCabeceras.add(CAB_DPTO_COMERCIAL);
		listaCabeceras.add(CAB_ESTADO_OCUPACION);
		listaCabeceras.add(CAB_ESTADO_FISCO_ACTIVO);
		listaCabeceras.add(CAB_DPTO_ADMISION);
		listaCabeceras.add(CAB_DPTO_GESTION);
		listaCabeceras.add(CAB_DPTO_CALIDAD);
		listaCabeceras.add(CAB_RATING);

		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VBusquedaActivos vBActivo: listaActivos)
		{
			Activo activo = null;
			if(!Checks.esNulo(genericDao))
			{
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", vBActivo.getId());
				activo = genericDao.get(Activo.class, f1);
			}

			List<String> fila = new ArrayList<String>();
			fila.add(vBActivo.getNumActivo());
			fila.add(vBActivo.getTipoActivoDescripcion());
			fila.add(vBActivo.getSubtipoActivoDescripcion());
			fila.add(vBActivo.getEntidadPropietariaDescripcion());
			fila.add(vBActivo.getTipoTituloActivoDescripcion());
			fila.add(vBActivo.getNombreVia());
			fila.add(vBActivo.getLocalidadDescripcion());
			fila.add(vBActivo.getProvinciaDescripcion());
			fila.add(vBActivo.getCodPostal());
			fila.add(vBActivo.getSituacionComercial());
			fila.add(mapeoEstadoOcupacion(activo));
			fila.add(mapeoEstadoFisico(activo));
			fila.add(mapeoString(vBActivo.getAdmision()));
			fila.add(mapeoString(vBActivo.getGestion()));
			fila.add(mapeoCalidad(vBActivo.getSelloCalidad()));
			fila.add(mapRating.get(vBActivo.getFlagRating()));
			valores.add(fila);
		}
		
		return valores;
	}
	
	private String mapeoString(Boolean dato){
		return (dato == null) ? null : dato ? "OK" : "KO";
	}
	
	private String mapeoCalidad(Boolean dato){
		return (dato == null) ? null : dato ? "OK" : "";
	}

	private String mapeoEstadoOcupacion(Activo activo)
	{
		ActivoSituacionPosesoria situacion;
		if(!Checks.esNulo(activo) && !Checks.esNulo(situacion = activo.getSituacionPosesoria()) && !Checks.esNulo(situacion.getOcupado()))
		{
			if(situacion.getOcupado() == 0) return "No ocupado";
			else if(!Checks.esNulo(situacion.getConTitulo()) && situacion.getOcupado() == 1)
			{
				if(situacion.getConTitulo() == 0) return "Ocupado sin título";
				else if(situacion.getConTitulo() == 1)
				{
					if(!Checks.esNulo(situacion.getTipoTituloPosesorio())) return "Ocupado con título de " + situacion.getTipoTituloPosesorio().getDescripcion();
					else return "Ocupado con título";
				}
			}
			else if(situacion.getOcupado() == 1) return "Ocupado sin título";
		}
		return "";
	}

	private String mapeoEstadoFisico(Activo activo)
	{
		String descripcion = "";
		if(!Checks.esNulo(activo.getEstadoActivo()) && !Checks.esNulo(descripcion = activo.getEstadoActivo().getDescripcion())){}
		return descripcion;
	}

	public String getReportName() {
		return LISTA_DE_ACTIVOS_XLS;
	}
	

}
