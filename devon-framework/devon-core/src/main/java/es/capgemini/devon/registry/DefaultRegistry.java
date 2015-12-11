package es.capgemini.devon.registry;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Nicolás Cornaglia
 */
public abstract class DefaultRegistry<ManagedType> implements Registry<ManagedType> {

    /**
     * Objects Registry
     */
    private final Map<String, ManagedType> objectsRegistry = new HashMap<String, ManagedType>();
    private List<Registry<ManagedType>> registriesRegistry = new ArrayList<Registry<ManagedType>>();

    /**
     * @see es.capgemini.devon.registry.Registry#put(java.lang.String, java.lang.Object)
     */
    @Override
    public void put(String id, ManagedType managedBean) {
        objectsRegistry.put(id, managedBean);
    }

    /**
     * @see es.capgemini.devon.registry.Registry#get(java.lang.String)
     */
    @Override
    public ManagedType get(String id) {
        ManagedType result = objectsRegistry.get(id);
        if (result == null) {
            for (Registry<ManagedType> registry : registriesRegistry) {
                result = registry.get(id);
                if (result != null) {
                    break;
                }
            }
        }
        return result;
    }

    /**
     * @see es.capgemini.devon.registry.Registry#put(es.capgemini.devon.registry.Registry)
     */
    @Override
    public void put(Registry<ManagedType> registry) {
        registriesRegistry.add(registry);
    }

    /**
     * @see es.capgemini.devon.registry.Registry#setRegistriesRegistry(java.util.List)
     */
    @Override
    public void setRegistriesRegistry(List<Registry<ManagedType>> registriesRegistry) {
        this.registriesRegistry = registriesRegistry;
    }

    @Override
    public void putAll(Map<String, ManagedType> objects) {
        objectsRegistry.putAll(objects);
    }

    @Override
    public Map<String, ManagedType> getObjectsRegistry() {
        return objectsRegistry;
    }

}
