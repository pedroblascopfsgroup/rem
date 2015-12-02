package es.capgemini.pfs.diccionarios.comparator;

import java.text.Collator;

import es.capgemini.pfs.diccionarios.Dictionary;

public class CodigoDictionaryComparator implements
		IDictionaryComparator {

	private Collator collator;
	
	public CodigoDictionaryComparator(Collator c) 
	{
		this.collator = c;
	}
	
	@Override
	public int compare(Dictionary o1, Dictionary o2) 
	{
		return collator.compare(o1.getCodigo(), o2.getCodigo());
	}
}
