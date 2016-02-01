package es.capgemini.devon.registry;

import java.util.List;
import java.util.Map;

/**
 * @author Nicolás Cornaglia
 */
public interface Registry<ManagedType> {

    public void put(Registry<ManagedType> registry);

    public void setRegistriesRegistry(List<Registry<ManagedType>> registriesRegistry);

    public void put(String id, ManagedType managedBean);

    public void putAll(Map<String, ManagedType> managedBeans);

    public ManagedType get(String id);

    public Map<String, ManagedType> getObjectsRegistry();
}
