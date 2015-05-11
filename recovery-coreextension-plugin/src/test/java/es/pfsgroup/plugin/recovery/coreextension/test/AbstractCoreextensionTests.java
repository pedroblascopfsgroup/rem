package es.pfsgroup.plugin.recovery.coreextension.test;

import java.util.Random;

/**
 * Clase abstracta para todos los tests.
 * 
 * @author manuel
 *
 */
public abstract class AbstractCoreextensionTests {
	
	protected Random random;

    public abstract void childBefore();

    public abstract void childAfter();

}
