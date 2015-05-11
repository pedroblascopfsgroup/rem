package es.pfsgroup.recovery.geninformes.factories.imp;

import org.springframework.stereotype.Component;

import es.pfsgroup.recovery.geninformes.api.GENINFInformeEntidadGenerator;
import es.pfsgroup.recovery.geninformes.factories.GENINFInformeEntidadFactory;

@Component
public class GENINFInformeEntidadFactoryImpl extends GENGenericFactoryImpl<GENINFInformeEntidadGenerator>  implements GENINFInformeEntidadFactory{

//	@Autowired(required=false)
//	List<GENINFInformeEntidadGenerator> lista;
//	
//	public GENINFInformeEntidad dameInstancia(String tipoEntidad) {
//		
//		if (lista == null || lista.size() == 0){
//			return null;
//		}
//		
//		Collections.sort(lista, Collections.reverseOrder(this.getGENINFInformeEntidadGeneratorCompartor()));
//		return lista.get(0).getInformeEntidad(tipoEntidad);
//
//	}
	
//	private Comparator<GENINFInformeEntidadGenerator> getGENINFInformeEntidadGeneratorCompartor(){
//		return new Comparator<GENINFInformeEntidadGenerator>(){
//
//			@Override
//			public int compare(GENINFInformeEntidadGenerator arg0, GENINFInformeEntidadGenerator arg1) {
//				
//				if (arg0 == null){
//					return -1;
//				}
//				if (arg1 == null){
//					return 1;
//				}
//				return arg0.getPrioridad() - arg1.getPrioridad();
//			}
//			
//		};
//	}
//
//	@Override
//	public GENINFInformeEntidad getBusinessObject() {
//		// TODO Auto-generated method stub
//		return null;
//	}
	
}
