package es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model;

import java.util.Comparator;

@SuppressWarnings("unchecked")
public class ComparaPorPrioridad implements Comparator {
	  
		public int compare(Object o1, Object o2) { 
		        ARQModeloArquetipo arq1 = (ARQModeloArquetipo)o1; 
		        ARQModeloArquetipo arq2 = (ARQModeloArquetipo)o2; 
		        return arq1.getPrioridad(). 
		                compareTo(arq2.getPrioridad()); 

		} 

}
